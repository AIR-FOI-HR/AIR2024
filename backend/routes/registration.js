var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection');
const { hash } = require('bcrypt');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const constants = require('../constants');

router.post('/', (req, res, next) => {
    try {
        bcrypt.hash(req.body.password, saltRounds, (err, hash) => {
            const token = jwt.sign({
                email: req.body.email,
                username: req.body.username
            }, constants.jwtKey)
            let hashedPassword = hash;
            let insertUserRegistrationSql = `INSERT INTO user VALUES ('${req.body.email}', '${req.body.username}', '${hashedPassword}', '${req.body.firstName}', '${req.body.lastName}', '1', ${req.body.avatarId}, '${token}');`
            dbConnection.connection.query(insertUserRegistrationSql, (err, result) => {
                if (err) {
                    return res.status(500).json(err)
                } else {
                    return res.status(201).json({ "sessionToken": token })
                }
            })
        });
    } catch (err) {
        return res.status(500).json(err);
    }
});

router.post('/mailcheck', (req, res, next) => {
    try {
        let checkEmailSql = `SELECT * FROM user WHERE mail='${req.body.email}'`
        dbConnection.connection.query(checkEmailSql, (err, data) => {
            if (err) {
                return res.status(500).json(err);
            } else if (data.length > 0) {
                return res.json({ "exists": true });
            } else {
                return res.json({ "exists": false });
            }
        });
    } catch (err) {
        return res.status(500).json(err);
    }
});

module.exports = router;
