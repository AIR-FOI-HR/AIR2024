const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');

router.post('/', function (req, res, next) {
    console.log(req.body)
    var token = req.body.sessionToken
    dbConnection.connection.query(`SELECT mail FROM user WHERE sessionToken='${token}'`, (error, data) => {
        dbConnection.connection.query(`SELECT a.activityId, startTime, endTime, title, description, locationName, forecastId, categoryId, activityStatusId FROM activity a, doing d, user u, location l WHERE a.activityId=d.activityId AND d.mail='${data[0].mail}' AND a.locationId=l.locationId`, (err, data) => {
            console.log(data)
            if (err) {
                return res.json({ "act": false })
            }
            else if (data.length > 0) {
                return res.json({ data })
            }
            else {
                return res.json({ "act": false })
            }
        })
    })
    
});

module.exports = router;
