require('./consts.js').get_info();
//console.log(tmp.get("host"));


const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

// Middleware pour parser le body des requêtes en JSON
app.use(bodyParser.json());

// Configuration de la connexion à MySQL
const db = mysql.createConnection({
  host: host, // Remplacez par l'IP de votre serveur MySQL
  user: user,         // Nom d'utilisateur de la base de données
  password: password,     // Mot de passe de la base de données
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
        return res.status(404).json({ message: 'No user found' });
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


app.get('/produits', (req, res) => {
  const sql = 'SELECT * FROM produits';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});

app.get('/produits/:_nom', (req, res) => {
  const nom = '%'+req.params._nom+'%';
  const sql = 'SELECT * FROM produits WHERE nom LIKE ?';
  db.query(sql, [nom], (err, results) => {
  if (err) {
      return res.status(500).send(err);
  }
  // if (results.length === 0) {
  //     return res.status(404).json({ message: 'No product found' });
  // }
  res.json(results);
  });
});

app.post('/insert_or_update_produit', (req, res) => {//app.post('/insert_produit', (req, res) => {
  const { nom, prix, stock } = req.body;
  console.log(nom, prix, stock);
  if (!nom || prix == null || stock == null) {
    return res.status(400).json({ error: 'Nom, prix, and stock are required' });
  }
  const sql = 'CALL insert_or_update_produit(?, ?, ?)';
  db.query(sql, [nom, prix, stock], (err, result) => {
    if (err) {
      console.error('Database insertion error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json({ id: result.insertId, nom, prix, stock });
  });
});

app.post('/change_stock_produit', (req, res) => {//app.post('/insert_produit', (req, res) => {
  const { nom, prix, stock } = req.body;
  if (nom==null || prix == null || stock == null) {
    return res.status(400).json({ error: 'Nom, prix, and stock are required' });
  }
  console.log(stock);
  const sql = 'CALL change_stock_produit(?, ?, ?)';
  db.query(sql, [nom, prix, stock], (err, result) => {
    if (err) {
      console.error('Database update error:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    // res.json({ id: result.insertId, nom, prix, stock });
    res.json({ success: true, message: `Le nouveau stock du produit ${nom} est de ${stock}.` })
  });
  console.log(nom);
});

app.post('/change_nom_produit/:oldname/:newname', (req, res) => {
  console.log('oldname : ${oldname}, newname : ${newname}')
  const { oldname, newname } = req.params; // Récupération des paramètres dans l'URL
  
  const sql = 'CALL change_nom_produit(?, ?)';

  db.query(sql, [oldname, newname], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ success: true, message: `Le produit "${oldname}" a été renommé en "${newname}".` });
  });
});


app.post('/change_prix_produit/:orname/:newprix', (req, res) => {
  const { orname, newprix } = req.params; // Récupération des paramètres dans l'URL

  const sql = 'CALL change_prix_produit(?, ?)';

  db.query(sql, [orname, newprix], (err, result) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ success: true, message: `Le prix du produit "${orname}" est maintenant de "${newprix}".` });
  });
});




// Endpoint pour récupérer le panier d'un utilisateur
app.get('/panier/:utilisateur', (req, res) => {
  const { utilisateur } = req.params;
  const sql = 'CALL get_panier(?)';
  db.query(sql, [utilisateur], (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results[0]);
  });
});

// Endpoint pour ajouter un produit au panier
app.post('/addtopanier', (req, res) => {
  const { utilisateur, produit, quantite } = req.body;
  const sql = 'CALL addtopanier(?, ?, ?)';
  db.query(sql, [utilisateur, produit, quantite], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json({ success: true, message: `Produit ajouté au panier` });
  });
});

// Endpoint pour accréditer le compte d'un utilisateur
app.post('/accrediter_compte', (req, res) => {
  const { utilisateur, montant } = req.body;
  const sql = 'CALL accrediter_compte(?, ?)';
  db.query(sql, [utilisateur, montant], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json({ success: true, message: `Compte accrédité avec succès` });
  });
});

// // Function to hash the password
// async function hashPassword(password) {
//   const saltRounds = 7; // Number of salt rounds
//   return await bcrypt.hash(password, saltRounds);
// }


// Endpoint to create a new user
app.post('/utilisateurs', (req, res) => {
  const { username, mdp } = req.body;

  if (!username || !mdp) {
    return res.status(400).json({ error: 'Username and password are required' });
  }

  const sql = 'INSERT INTO utilisateurs (username, mdp) VALUES (?, ?)';
  db.query(sql, [username, mdp], (err, result) => {
    if (err) {
      console.error('Error inserting into MySQL:', err);
      return res.status(500).json({ error: 'Database error' });
    }
    res.json({ id: result.insertId, username, mdp });
  });
});

// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur API en écoute sur http://localhost:${port}`);
});