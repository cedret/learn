require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const app = express();

const pool = mysql.createPool({
 host: 'myapp1database.cfsqamwuwe6v.eu-north-1.rds.amazonaws.com',
 user: 'admin',
 password: 'cp4zcWLJHsYxy1tsYV5o',
 database: 'webappdb'
});

app.get('/', async (req, res) => {
 try {
 const [rows] = await pool.query('SELECT * FROM users');
 res.send(`
 <h1>Liste des utilisateurs</h1>
 ${rows.map(user => `
 <div>
 <p>Utilisateur : ${user.username}</p>
 <p>Email : ${user.email}</p>
 </div>
 `).join('')}
 `);
 } catch (error) {
 console.error(error);
 res.status(500).send('Erreur serveur');
 }
});

app.listen(3000, () => {
 console.log('Serveur en cours d\'exécution sur le port 3000');
});