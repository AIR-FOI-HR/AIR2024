var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection')

router.get('/allCategories', function(req, res, next) {
    try{
        dbConnection.connection.query(`select * from category order by name asc`, (err, data) => {
            if (err) {
                return res.json({ "empty": true })
            }
            else if (data.length > 0) {
                var allCategoryNames = data.map(x => x.name);
                return res.json({"categories": allCategoryNames, "empty": false})
            }
            else {
                return res.json({ "empty": true})
            }
        })
    }
    catch(err){
        return res.json({"empty": true})
    }
});

router.post('/recentCategories', function(req, res, next) {
    try{
        let recentCategoriesQuery = `SELECT DISTINCT(category.name) FROM activity
        join category on (activity.categoryId = category.categoryId)
        join doing on (doing.activityId = activity.activityId)
        join user on (doing.mail = user.mail)
        where user.mail = '${req.body.email}'
        order by created_at desc limit 4`;
        dbConnection.connection.query(recentCategoriesQuery, (err, data) => {
            if (err) {
                return res.json({ "empty": true })
            }
            else if (data.length > 0) {
                var allCategoryNames = data.map(x => x.name);
                return res.json({"categories": allCategoryNames, "empty": false})
            }
            else {
                return res.json({"empty": true})
            }
        })
    }
    catch(err){
        return res.json({"empty": true})
    }
});

module.exports = router;