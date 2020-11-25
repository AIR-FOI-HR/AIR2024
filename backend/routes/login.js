var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection')
var bcrypt = require('bcrypt')

/* GET home page. */
router.post('/', function(req, res, next) {
    console.log(req.body)
    var email = req.body.email
    var password = req.body.password
    dbConnection.connection.query(`SELECT * FROM user WHERE mail='${email}'`, (err,data) => {
        if(err) {
            res.json({"logged":false})
        } 
        else if(data.length > 0) {
            bcrypt.compare(password, data[0].password, function(err, ress) {
                if (ress==true) {
                    return res.json({"logged":true})
                }
                return res.json({"logged":false})
            });
        } 
        else {
            return res.json({"logged":false})
        }
    })    
});

module.exports = router;
