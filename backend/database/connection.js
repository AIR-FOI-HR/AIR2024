var mysql = require('mysql');
var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'weatheractivity',
  multipleStatements: true
})
if(connection.state != "connected"){
  connection.connect((err) => {
    if(err) {
      console.log(err.code);
      console.log(err.fatal);
    } else {
      console.log("Connected")
    }
  });
}


exports.connection = connection
