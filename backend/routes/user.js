const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');

router.post('/profile', (req, res, next) => {
    sql = `SELECT mail, username, firstName, lastName, avatarName, u.avatarId FROM user u, avatar a WHERE u.sessionToken='${req.body.sessionToken}' AND u.avatarId=a.avatarId`;
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.status(500).json(err);
        } else if (data.length > 0) {
            return res.json(data[0]);
        } else {
            let error = {
                status: 204,
                message: "User not found."
            }
            return res.status(error.status).json(error);
        }
    });
});

router.post('/profile/update', (req, res, next) => {
    sql = `UPDATE user SET firstName='${req.body.firstName}', lastName='${req.body.lastName}', username='${req.body.username}', avatarId=${req.body.avatarId} WHERE sessionToken='${req.body.sessionToken}'`;
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.status(500).json(false);
        } else {
            return res.json(true);
        }
    });
});

router.post('/homeData', (req, res, next) => {
    sql = `SELECT firstName, avatarName FROM user u, avatar a WHERE u.sessionToken='${req.body.sessionToken}' AND u.avatarId=a.avatarId`;
    dbConnection.connection.query(sql, (err, data) => {
        if (err) {
            return res.status(500).json(err);
        } else if (data.length > 0) {
            return res.json(data[0]);
        } else {
            let error = {
                status: 204,
                message: "User not found."
            }
            return res.status(error.status).json(error);
        }
    });
});

module.exports = router;
