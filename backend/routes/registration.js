const { hash } = require('bcrypt');
var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection')
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken')
const constants = require('../constants');

router.post('/', function(req,res,next) {
    try {
        bcrypt.hash(req.body.password, saltRounds, (err, hash) => {
            const token = jwt.sign({
                email: req.body.email,
                username: req.body.username
            }, constants.jwtKey)
            let hashedPassword = hash    
            let insertUserRegistrationSql = `INSERT INTO user VALUES ('${req.body.email}', '${req.body.username}', '${hashedPassword}', '${req.body.firstName}', '${req.body.lastName}', '1', ${req.body.avatar}, '${token}');`
            console.log(insertUserRegistrationSql)
            dbConnection.connection.query(insertUserRegistrationSql, (err,data) => {
                if(err) {
                    return res.json({"msg":"Error"})
                } else {
                    return res.json({"msg":"Inserted", "token": token})
                }
            })
        });
    } catch(err) {
        console.log(err)
    }
})

/* GET home page. */
// router.post('/', function(req, res, next) {
//     dbConnection.connection.query("SELECT * FROM user", (err,data) => {
//         if(err) {
//             res.json({"logged":false})
//         } else {
//             if(req.body.email == data[0].mail && req.body.password == data[0].password) {
//                 res.json({"logged":true})
//             }
//             else {
//                 res.json({"logged":false})
//             }
//         }
//     })
// });

module.exports = router;
