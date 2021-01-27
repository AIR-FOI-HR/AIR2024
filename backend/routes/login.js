const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const constants = require('../constants');

router.post('/', (req, res, next) => {
    var email = req.body.email;
    var password = req.body.password;
    dbConnection.connection.query(`SELECT * FROM user WHERE mail='${email}'`, (err, data) => {
        if (err) {
            return res.status(500).json(err);
        } else if (data.length > 0) {
            bcrypt.compare(password, data[0].password, function (err, response) {
                if (response) {
                    const token = jwt.sign({
                        email: data[0].mail,
                        username: data[0].username
                    }, constants.jwtKey);
                    dbConnection.connection.query(`UPDATE user SET sessionToken='${token}' WHERE mail='${email}'`, (err, data) => {
                        if (err) {
                            return res.status(500).json(err);
                        } else {
                            return res.json({ "sessionToken": token });
                        }
                    });
                } else {
                    return res.status(401).json({ "sessionToken": null });
                }
            });
        } else {
            return res.status(204).json({ "sessionToken": null });
        }
    });
});

router.post('/tokenCheck', (req, res, next) => {
    dbConnection.connection.query(`SELECT * FROM user WHERE sessionToken='${req.body.sessionToken}'`, (err, data) => {
        if (err) {
            return res.status(500).json(err)
        } else if (data.length > 0) {
            return res.json({ "sessionToken": true })
        } else {
            return res.status(204).json({ "sessionToken": false })
        }
    })
});

module.exports = router;
