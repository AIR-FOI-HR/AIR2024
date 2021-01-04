const bcrypt = require('bcrypt');
const saltRounds = 10;

const hashedPassword = ""

const encrypt = (password) => {
    bcrypt.hash(password, saltRounds, (err, hash) => {
        hashedPassword = hash
    });
}

module.exports = {
    encrypt
}
