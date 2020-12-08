var express = require('express');
var router = express.Router();
var dbConnection = require('../database/connection')

router.get('/allCategories', function(req, res, next) {
    try{
        dbConnection.connection.query(`select * from category order by name asc`, (err, data) => {
            if (err) {
                return res.json({ "categories": "false" })
            }
            else if (data.length > 0) {
                var allCategoryNames = data.map(x => x.name);
                return res.json({"categories": allCategoryNames})
            }
            else {
                return res.json({ "categories": "false" })
            }
        })
    }
    catch(err){
        return res.json({"categories": "false"})
    }
});

module.exports = router;