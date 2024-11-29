const mariadb = require('mariadb');

const pool = mariadb.createPool({
   host: '127.0.0.1', // or your server address
   user: 'root',
   password: 'dbkm34',
   database: 'knowledge_match',
   connectionLimit: 5,
   connectTimeout: 20000, // Increased timeout
   acquireTimeout: 20000,  // Increased timeout
   // Fix for BIGINT serialization issue
   bigIntAsNumber: true,
   supportBigNumbers: true,
   bigNumberStrings: true
});

module.exports = pool;