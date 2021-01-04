const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');

router.post('/', function (req, res, next) {
    dbConnection.connection.query(
        `SELECT a.activityId, startTime, endTime, title, description, locationName, latitude, longitude, temperature, feelsLike, wind, humidity, forecastType, c.name, type, statusType FROM activity a
        JOIN location l ON a.locationId=l.locationId
        JOIN forecast f ON a.forecastId=f.forecastId
        JOIN forecasttype ftype ON f.forecastTypeId=ftype.forecastTypeId
        JOIN category c ON a.categoryId=c.categoryId
        JOIN activitystatus astatus ON a.activityStatusId=astatus.activityStatusId
        JOIN doing d ON a.activityId=d.activityId
        JOIN user u ON d.mail=u.mail WHERE u.sessionToken='${req.body.sessionToken}'`, (err, data) => {
            if (err) {
                return res.json(err)
            } else {
                let list = data.map((activity) => {
                    activity.type = activity.type === 3 ? "Indoor" : "Outdoor";
                    return activity;
                })
                return res.json(list)
            }
        }
    )
});

module.exports = router;
