const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware pour parser le body des requêtes en JSON
app.use(bodyParser.json());

// Configuration de la connexion à MySQL
const db = mysql.createConnection({
  host: '10.51.4.100', // Remplacez par l'IP de votre serveur MySQL
  user: 'samuel',         // Nom d'utilisateur de la base de données
  password: 'samuel',     // Mot de passe de la base de données
  database: 'php',
  connectTimeout: 100000           // Nom de la base de données
});

// Connexion à MySQL
db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à MySQL:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL');
});

// Endpoint pour récupérer toutes les nations
app.get('/utilisateurs', (req, res) => {
  const sql = 'SELECT * FROM utilisateurs';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});


// Endpoint pour récupérer toutes les nations
app.get('/utilisateurs/:_username', (req, res) => {
    const username = '%'+req.params._username+'%';
    // Crée la requête SQL avec un paramètre pour le nom
    const sql = 'SELECT * FROM utilisateurs WHERE username LIKE ?';
    db.query(sql, [username], (err, results) => {
    if (err) {
        return res.status(500).send(err);
    }
    if (results.length === 0) {
    // Si aucune nation n'est trouvée, renvoyer une erreur 404
        return res.status(404).json({ message: 'User not found' });
    }
    // Si des résultats sont trouvés, renvoyer les données
    res.json(results);
    });
});

// Endpoint pour ajouter une nouvelle nation
app.post('/utilisateurs', (req, res) => {
  const { username, mdp } = req.body;
  const sql = 'INSERT INTO utilisateurs (username, mdp) VALUES (?, ?)';
  db.query(sql, [username, mdp], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json({ id: result.insertId, username, mdp });
  });
});


app.get('/produits/:_nom', (req, res) => {
  const nom = '%'+req.params._nom+'%';
  const sql = 'SELECT * FROM produits WHERE nom LIKE ?';
  db.query(sql, [nom], (err, results) => {
  if (err) {
      return res.status(500).send(err);
  }
  if (results.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
  }
  res.json(results);
  });
});

// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur API en écoute sur http://localhost:${port}`);
});