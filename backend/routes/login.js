const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const constants = require('../constants');
const { response } = require('express');

router.post('/', (req, res, next) => {
    var email = req.body.email;
    var password = req.body.password;
    var firstName, avatarName = "";
    dbConnection.connection.query(`SELECT * FROM user WHERE mail='${email}'`, (err, data) => {
        if (err) {
            return res.json({ "sessionToken": null });
        }
        else if (data.length > 0) {
            firstName = data[0].firstName;
            avatarName = data[0].avatarName;
            bcrypt.compare(password, data[0].password, function (err, response) {
                if (response) {
                    const token = jwt.sign({
                        email: data[0].mail,
                        username: data[0].username
                    }, constants.jwtKey);
                    dbConnection.connection.query(`UPDATE user SET sessionToken='${token}' WHERE mail='${email}'`, (err, data) => {
                        if (err) {
                            return res.json({ "sessionToken": null });
                        } else {
                            return res.json({ "sessionToken": token, "userName": firstName, "userAvatar": avatarName });
                        }
                    });
                }
                else {
                    return res.json({ "sessionToken": null });
                }
            });
        }
        else {
            return res.json({ "sessionToken": null });
        }
    });
});

router.post('/tokenCheck/', (req, res, next) => {
    var token = req.body.sessionToken;
    dbConnection.connection.query(`SELECT * FROM user WHERE sessionToken='${token}'`, (err, data) => {
        if (err) {
            return res.json({ "sessionToken": false })
        } else if (data.length > 0) {
            return res.json({ "sessionToken": true })
        } else {
            return res.json({ "sessionToken": false })
        }
    })
});

module.exports = router;
