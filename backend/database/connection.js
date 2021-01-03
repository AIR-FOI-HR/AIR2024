var mysql = require('mysql');

var pool = mysql.createPool({
  host: 'www.seyziich.com',
  user: 'bobi',
  password: 'zg4w8aaQWVPn8zGs',
  database: 'bobi'
});

exports.connection = pool;
