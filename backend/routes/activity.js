const { json } = require('body-parser');
const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');

router.post('/', (req, res, next) => {
    sql = `SELECT a.activityId, startTime, endTime, title, description, locationName, latitude, longitude, temperature, feelsLike, wind, humidity, forecastType, c.name, type, statusType FROM activity a
            JOIN location l ON a.locationId=l.locationId
            JOIN forecast f ON a.forecastId=f.forecastId
            JOIN forecasttype ftype ON f.forecastTypeId=ftype.forecastTypeId
            JOIN category c ON a.categoryId=c.categoryId
            JOIN activitystatus astatus ON a.activityStatusId=astatus.activityStatusId
            JOIN doing d ON a.activityId=d.activityId
            JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}'`;
    if (req.body.purpose === 'home') {
        sql += ' AND a.endTime>=CURDATE()';
    }
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.json(err);
        } else {
            let list = data.map((activity) => {
                activity.type = activity.type === 3 ? "Indoor" : "Outdoor";
                return activity;
            })
            return res.json(list);
        }
    })
});

router.post('/widgetActivityDetails/:id', (req, res, next) => {
    sql = `SELECT a.activityId, startTime, endTime, title, description, locationName, latitude, longitude, temperature, feelsLike, wind, humidity, forecastType, c.name, type, statusType FROM activity a
            JOIN location l ON a.locationId=l.locationId
            JOIN forecast f ON a.forecastId=f.forecastId
            JOIN forecasttype ftype ON f.forecastTypeId=ftype.forecastTypeId
            JOIN category c ON a.categoryId=c.categoryId
            JOIN activitystatus astatus ON a.activityStatusId=astatus.activityStatusId
            JOIN doing d ON a.activityId=d.activityId
            JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}' AND a.activityId=${req.params.id}`;
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.json(err);
        } else {
            let list = data.map((activity) => {
                activity.type = activity.type === 3 ? "Indoor" : "Outdoor";
                return activity;
            })
            return res.json(list[0]);
        }
    })
});

router.post('/getWidgetActivities', (req, res, next) => {
    sql = `SELECT a.activityId, startTime, title, locationName, c.name FROM activity a
            JOIN location l ON a.locationId=l.locationId
            JOIN category c ON a.categoryId=c.categoryId
            JOIN doing d ON a.activityId=d.activityId
            JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}' AND a.startTime>=CURDATE() ORDER BY startTime LIMIT 3`;
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.json(err);
        } else {
            return res.json(data);
        }
    })
});

router.post('/delete/:id', (req, res, next) => {
    dbConnection.connection.query(
        `DELETE a, l, f, df, d FROM activity a
        JOIN location l ON a.locationId=l.locationId
        JOIN forecast f ON a.forecastId=f.forecastId
        JOIN desiredforecast df ON a.activityId=df.activityId
        JOIN doing d ON a.activityId=d.activityId
        JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}' AND a.activityId='${req.params.id}'`, (err, result) => {
            if (err) {
                return res.json(false);
            } else if (result.affectedRows > 0) {
                return res.json(true);
            } else {
                return res.json(false);
            }
        }
    )
});

router.post('/update/:id', (req, res, next) => {
    var activity = JSON.parse(req.body.activityData);

    let temperature, feelsLike, wind, humidity, forecastTypeId;
    if (activity.TimeDetails.weatherDetails) {
        temperature = activity.TimeDetails.weatherDetails.temperature;
        feelsLike = activity.TimeDetails.weatherDetails.feelsLike;
        wind = activity.TimeDetails.weatherDetails.wind;
        humidity = activity.TimeDetails.weatherDetails.humidity;
        forecastTypeId = activity.TimeDetails.weatherDetails.weatherIdentifier;
    } else {
        temperature, feelsLike, wind, humidity = null;
        forecastTypeId = 0;
    }

    const handleTransaction = (connection, bool) => {
        bool ? connection.commit() : connection.rollback();
        connection.release();
        return res.json(bool);
    }

    dbConnection.connection.getConnection((err, connection) => {
        connection.beginTransaction((err) => {
            if (err) console.log(err)
            connection.query(`DELETE FROM desiredforecast WHERE activityId='${req.params.id}'`, (err, result) => {
                if (err) {
                    handleTransaction(connection, false);
                } else {
                    connection.query(`SELECT * FROM category WHERE name='${activity.CategoriesDetails.selectedCategory}'`, (err, data) => {
                        if (err) {
                            handleTransaction(connection, false);
                        } else {
                            let categoryId;
                            if (data.length > 0) {
                                categoryId = data[0].categoryId;
                            } else {
                                categoryId = 0;
                            }
                            connection.query(
                                `UPDATE activity a
                                JOIN location l ON a.locationId=l.locationId
                                JOIN forecast f ON a.forecastId=f.forecastId
                                SET a.startTime='${activity.TimeDetails.timeDetails.fromTime}', a.endTime='${activity.TimeDetails.timeDetails.untilTime}', a.title='${activity.FinalDetails.title}', a.description='${activity.FinalDetails.description}', a.categoryId=${categoryId}, a.type=${activity.FinalDetails.typeOfActivity},
                                    l.locationName='${activity.LocationDetails.locationName}', l.latitude=${activity.LocationDetails.latitude}, l.longitude=${activity.LocationDetails.longitude},
                                    f.temperature=${temperature}, f.feelsLike=${feelsLike}, f.wind=${wind}, f.humidity=${humidity}, f.forecastTypeId=${forecastTypeId}
                                WHERE a.activityId='${req.params.id}'`, (err, result) => {
                                    console.log(result);
                                    if (err) {
                                        handleTransaction(connection, false)
                                    } else {
                                        if (activity.FinalDetails.supportedWeather.length !== 0) {
                                            let supportedWeathers = []
                                            for (let i = 0; i < activity.FinalDetails.supportedWeather.length; i++) {
                                                supportedWeathers.push([req.params.id, activity.FinalDetails.supportedWeather[i]]);
                                            }
                                            connection.query(`INSERT INTO desiredforecast VALUES ?`, [supportedWeathers], (err, result) => {
                                                if (err) {
                                                    handleTransaction(connection, false);
                                                } else {
                                                    handleTransaction(connection, true);
                                                }
                                            });
                                        } else {
                                            handleTransaction(connection, true);
                                        }
                                    }
                                }
                            );
                        }
                    });
                }
            });
        });
    });
});

router.post('/insert/', (req, res, next) => {
    var activity = JSON.parse(req.body.activityData);

    const handleTransaction = (connection, bool) => {
        bool ? connection.commit() : connection.rollback();
        connection.release();
        return res.json(bool);
    }

    dbConnection.connection.getConnection((err, connection) => {
        connection.beginTransaction((err) => {
            if (err) console.log(err)
            connection.query(`INSERT INTO location VALUES ('default', '${activity.LocationDetails.locationName}', ${activity.LocationDetails.latitude}, ${activity.LocationDetails.longitude})`, (err, result) => {
                var locationId = result.insertId;
                if (err) {
                    handleTransaction(connection, false);
                } else {
                    let forecastSql;
                    if (activity.TimeDetails.weatherDetails) {
                        forecastSql = `INSERT INTO forecast VALUES ('default', ${activity.TimeDetails.weatherDetails.temperature}, ${activity.TimeDetails.weatherDetails.feelsLike}, ${activity.TimeDetails.weatherDetails.wind}, ${activity.TimeDetails.weatherDetails.humidity}, ${activity.TimeDetails.weatherDetails.weatherIdentifier})`;
                    } else {
                        forecastSql = `INSERT INTO forecast VALUES ('default', null, null, null, null, 0)`;
                    }
                    connection.query(forecastSql, (err, result) => {
                        var forecastId = result.insertId;
                        if (err) {
                            handleTransaction(connection, false);
                        } else {
                            connection.query(`SELECT * FROM category WHERE name='${activity.CategoriesDetails.selectedCategory}'`, (err, data) => {
                                if (err) {
                                    handleTransaction(connection, false);
                                } else {
                                    let categoryId;
                                    if (data.length > 0) {
                                        categoryId = data[0].categoryId;
                                    } else {
                                        categoryId = 0;
                                    }
                                    connection.query(`INSERT INTO activity (startTime, endTime, title, description, forecastId, locationId, categoryId, activityStatusId, type) VALUES ('${activity.TimeDetails.timeDetails.fromTime}', '${activity.TimeDetails.timeDetails.untilTime}', '${activity.FinalDetails.title}', '${activity.FinalDetails.description}', ${forecastId}, ${locationId}, ${categoryId}, ${1}, ${activity.FinalDetails.typeOfActivity})`, (err, result) => {
                                        var activityId = result.insertId;
                                        if (err) {
                                            handleTransaction(connection, false);
                                        } else {
                                            connection.query(`SELECT mail FROM user WHERE sessionToken='${req.body.sessionToken}'`, (err, data) => {
                                                let mail;
                                                if (err) {
                                                    handleTransaction(connection, false);
                                                } else {
                                                    mail = data[0].mail;
                                                    connection.query(`INSERT INTO doing VALUES ('${mail}', ${activityId}, true)`, (err, result) => {
                                                        if (err) {
                                                            handleTransaction(connection, false);
                                                        } else {
                                                            if (activity.FinalDetails.supportedWeather.length !== 0) {
                                                                let supportedWeathers = []
                                                                for (let i = 0; i < activity.FinalDetails.supportedWeather.length; i++) {
                                                                    supportedWeathers.push([activityId, activity.FinalDetails.supportedWeather[i]]);
                                                                }
                                                                connection.query(`INSERT INTO desiredforecast VALUES ?`, [supportedWeathers], (err, result) => {
                                                                    if (err) {
                                                                        handleTransaction(connection, false);
                                                                    } else {
                                                                        handleTransaction(connection, true);
                                                                    }
                                                                });
                                                            } else {
                                                                handleTransaction(connection, true);
                                                            }
                                                        }
                                                    });
                                                }
                                            })
                                        }
                                    });
                                }
                            });
                        }
                    });
                }
            });
        });
    });
});

module.exports = router;
