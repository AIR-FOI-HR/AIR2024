const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const constants = require('../constants');

/* GET home page. */
router.post('/', function (req, res, next) {
    console.log(req.body)
    var email = req.body.email
    var password = req.body.password
    dbConnection.connection.query(`SELECT * FROM user WHERE mail='${email}'`, (err, data) => {
        if (err) {
            return res.json({ "logged": false, "sessionToken": null })
        }
        else if (data.length > 0) {
            bcrypt.compare(password, data[0].password, function (err, ress) {
                if (ress) {
                    const token = jwt.sign({
                        email: data[0].mail,
                        username: data[0].username
                    }, constants.jwtKey)
                    console.log(token)
                    dbConnection.connection.query(`UPDATE user SET sessionToken='${token}' WHERE mail='${email}'`, (err, data) => {
                        if (err)
                            return res.json({ "logged": false, "sessionToken": null })
                        else
                            return res.json({ "logged": true, "sessionToken": token });
                    })
                }
                else
                    return res.json({ "logged": false, "sessionToken": null })
            });
        }
        else {
            return res.json({ "logged": false, "sessionToken": null })
        }
    })
});

module.exports = router;
