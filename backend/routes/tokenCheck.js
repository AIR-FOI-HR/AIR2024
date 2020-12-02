const express = require('express');
const router = express.Router();
const dbConnection = require('../database/connection')
const jwt = require('jsonwebtoken')
const constants = require('../constants');

/* GET home page. */
router.post('/', function (req, res, next) {
    console.log(req.body)
    var token = req.body.sessionToken
    dbConnection.connection.query(`SELECT * FROM user WHERE sessionToken='${token}'`, (err, data) => {
        if (err) {
            return res.json({ "token": false })
        }
        else if (data.length > 0) {
            return res.json({ "token": true })
        }
        else {
            return res.json({ "token": false })
        }
    })
});

module.exports = router;
