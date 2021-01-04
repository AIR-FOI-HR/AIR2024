const { json } = require('body-parser');
const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');

router.post('/', function (req, res, next) {
    dbConnection.connection.query(
        `SELECT a.activityId, startTime, endTime, title, description, locationName, forecastId, categoryId, activityStatusId FROM activity a
        JOIN doing d ON a.activityId=d.activityId
        JOIN location l ON a.locationId=l.locationId
        JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}'`, (err, data) => {
            if (err) {
                return res.json(err)
            } else {
                return res.json(data)
            }
        }
    )
});

router.post('/insert/', function (req, res, next) {
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
                        forecastSql = `INSERT INTO forecast VALUES ('default', null, null, null, null, null)`;
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
                                        categoryId = null;
                                    }
                                    connection.query(`INSERT INTO activity (startTime, endTime, title, description, forecastId, locationId, categoryId, activityStatusId) VALUES ('${activity.TimeDetails.timeDetails.fromTime}', '${activity.TimeDetails.timeDetails.untilTime}', '${activity.FinalDetails.title}', '${activity.FinalDetails.description}', ${forecastId}, ${locationId}, ${categoryId}, ${1})`, (err, result) => {
                                        var activityId = result.insertId;
                                        if (err) {
                                            handleTransaction(connection, false);
                                        } else {
                                            connection.query(`INSERT INTO doing VALUES ('bobi', ${activityId}, true)`, (err, result) => {
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
