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
    const handleTransaction = (connection, bool) => {
        bool ? connection.commit() : connection.rollback();
        connection.release();
        return res.json(bool);
    }

    dbConnection.connection.getConnection((err, connection) => {
        connection.beginTransaction((err) => {
            if (err) console.log(err)
            connection.query(`INSERT INTO location VALUES (NULL, 'tecst', '12.221', '12.231')`, (err, result) => {
                var locationId = result.insertId;
                if (err) {
                    handleTransaction(connection, false);
                } else {
                    let values = [
                        ['default', 'testnalokacija', '12.34', '12.34']
                    ];
                    values.push(['default', 'test', '12', '34']);
                    connection.query(`INSERT INTO location VALUES ?`, [values], (err, result) => {
                        if (err) {
                            handleTransaction(connection, false);
                        } else {
                            handleTransaction(connection, true);
                        }
                    });
                }
            });
        });
    });
});

module.exports = router;
