
# 📱 Application mobile administrative – Projet E5 (BTS SIO SLAM)

Ce projet a été réalisé dans le cadre de l’épreuve **E5** du **BTS SIO SLAM** pour l’épreuve **E6**.  
Il s'agit d'une application mobile développée avec **Flutter**, visant à permettre la **gestion des opérations administratives** d’un site e-commerce (commandes, produits, stocks, etc.).

---

## 🎯 Objectif du projet

Développer une application mobile dédiée à l’administrateur d’un site web, avec les fonctionnalités suivantes :

- 🔐 Authentification sécurisée
- 📦 Gestion du catalogue produits
- 🧾 Suivi des commandes
- 🧺 Gestion des stocks
- 📊 Tableau de bord
- ➕ Ajout futur d’un système de panier (en cours)

---

## 🧠 Architecture technique

- **Flutter** : Application mobile multiplateforme (Windows, Web, Android…)
- **Node.js** : API intermédiaire (fichier `index.js`)
- **MySQL** : Base de données partagée avec un projet web PHP
- **WAMP** : Serveur local pour PHP/MySQL
- Le fichier `consts.js` gère dynamiquement les adresses IP de l’API selon le poste utilisé (portable ou salle de classe)

---

## 📁 Structure du projet

```
e5/
├── lib/
│   ├── main.dart          # Point d’entrée principal de l’application
│   └── consts.dart        # Fichier contenant les constantes (ex : URLs API)
├── index.js               # API Node.js qui communique avec MySQL
├── php (1).sql            # Script SQL à importer dans PhpMyAdmin
```

---

## ⚙️ Installation et mise en route

### 🧰 Prérequis

- Flutter SDK ≥ 3.x
- Node.js ≥ 18.x
- WAMP ou équivalent (MySQL 8.x + PhpMyAdmin)
- Git
- Éditeur de code (ex : VS Code)

### 🔽 Étapes d’installation

1. **Cloner le projet**
   ```bash
   git clone -b k https://github.com/SamuelJ2021/e5.git
   cd e5
   ```

2. **Installer les dépendances Flutter**
   ```bash
   flutter pub get
   ```

3. **Configurer la base de données**
   - Démarrer WAMP
   - Créer une base `php` dans PhpMyAdmin
   - Importer le fichier `php (1).sql`

4. **Lancer l’API Node.js**
   - Adapter les IP dans `consts.js` si besoin
   - Lancer :
     ```bash
     node index.js
     ```

5. **Lancer l'application Flutter**
   ```bash
   flutter run -d windows
   ```

---

## ✅ Fonctionnalités implémentées

- ✔️ Authentification (distinction admin/utilisateur normal)
- ✔️ Recherche produit (avec `LIKE`)
- ✔️ Ajout / modification de produit pour les admins
- ❌ Panier (bouton présent mais pas encore fonctionnel)
- ⚠️ Inscription : création d’un compte partiellement fonctionnelle (certains champs non enregistrés)

---

## 🗃️ Base de données

Les tables principales sont :

- `utilisateurs` : comptes avec rôles
- `role` : `admin` ou `normal`
- `produits` : articles du catalogue
- `achats` : historique des ajouts au panier
- `sous` : solde utilisateur
- `stock_updates` : file d’attente de mise à jour de stock

⚙️ Des procédures stockées permettent la gestion des produits, du stock et des paniers.  
Un **événement MySQL** exécute `process_stock_updates()` toutes les 5 secondes.

---

## 📌 Remarques

- Le projet fonctionne en local (pas encore prévu pour la production)
- Le site PHP MVC prévu est minimal et non exploité à ce jour
- Le code Flutter n’utilise pas d’architecture type MVC ou Provider ; toute la logique est centralisée dans `main.dart`

---

## 📄 Livrables prévus pour l’épreuve

- Dossier projet
- Présentation du besoin métier
- Présentation de l’architecture
- Modélisation de la base
- Procédure de déploiement
- Jeu de tests
- Accès GitHub (ce dépôt)

---

## 👤 Auteur

Samuel Jehanno — [GitHub](https://github.com/SamuelJ2021)

Projet réalisé seul dans le cadre du **BTS SIO SLAM** – Session 2025
