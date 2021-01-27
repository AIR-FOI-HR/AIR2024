var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection');

router.get('/allCategories', (req, res, next) => {
    try {
        dbConnection.connection.query(`select * from category order by name asc`, (err, data) => {
            if (err) {
                return res.status(500).json(err);
            } else if (data.length > 0) {
                var allCategoryNames = data.map(x => x.name);
                jsonObject = {};
                jsonObject.categories = [];
                allCategoryNames.forEach(category => {
                    jsonObject.categories.push({"categoryName": category});    
                });
                return res.json(jsonObject)
            } else {
                return res.json({ "categories": []});
            }
        });
    } catch(err) {
        return res.status(500).json(err);
    }
});

router.post('/recentCategories', (req, res, next) => {
    try {
        let recentCategoriesQuery = `SELECT DISTINCT(category.name) FROM activity
        join category on (activity.categoryId = category.categoryId)
        join doing on (doing.activityId = activity.activityId)
        join user on (doing.mail = user.mail)
        where user.sessionToken = '${req.body.sessionToken}'
        order by created_at desc limit 4`;
        dbConnection.connection.query(recentCategoriesQuery, (err, data) => {
            if (err) {
                return res.status(500).json(err);
            } else if (data.length > 0) {
                var allCategoryNames = data.map(x => x.name);
                jsonObject = {};
                jsonObject.categories = [];
                allCategoryNames.forEach(category => {
                    jsonObject.categories.push({"categoryName": category});    
                });
                return res.json(jsonObject);
            } else {
                return res.json({"categories": []});
            }
        });
    } catch(err) {
        return res.status(500).json(err);
    }
});

module.exports = router;
