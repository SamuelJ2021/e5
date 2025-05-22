-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : jeu. 22 mai 2025 à 15:26
-- Version du serveur : 8.3.0
-- Version de PHP : 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `php`
--

DELIMITER $$
--
-- Procédures
--
DROP PROCEDURE IF EXISTS `accrediter_compte`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `accrediter_compte` (IN `utilisateur` VARCHAR(255), IN `montant` INT)   BEGIN
	DECLARE idutilisateur INT;
    SET idutilisateur = (SELECT id FROM utilisateurs WHERE username = utilisateur);
    UPDATE sous SET balance = balance + montant WHERE id_user = idutilisateur;
END$$

DROP PROCEDURE IF EXISTS `addtopanier`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addtopanier` (IN `utilisateur` VARCHAR(255), IN `produit` VARCHAR(255), IN `quantite` INTEGER)   BEGIN
	DECLARE idutilisateur INT;
    DECLARE idproduit INT;
    SET idutilisateur = (SELECT id FROM utilisateurs WHERE nom = utilisateur);
    SET idproduit = (SELECT id FROM produits WHERE nom = produit);
    INSERT INTO achats (id_user, id_produit, effectif)
    VALUES (idutilisateur, idproduit, quantite);
END$$

DROP PROCEDURE IF EXISTS `change_nom_produit`$$
CREATE DEFINER=`samuel`@`%` PROCEDURE `change_nom_produit` (IN `oldname` VARCHAR(255), IN `newname` VARCHAR(255))   BEGIN
    -- Vérifier si le nouveau nom existe déjà
    IF (SELECT COUNT(*) FROM produits WHERE nom = newname) = 0 THEN
        UPDATE produits SET nom = newname WHERE nom = oldname;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `change_prix_produit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_prix_produit` (IN `orname` VARCHAR(255), IN `newprix` INTEGER)   BEGIN
    UPDATE produits SET prix = newprix WHERE nom = orname;
END$$

DROP PROCEDURE IF EXISTS `change_stock_produit`$$
CREATE DEFINER=`samuel`@`%` PROCEDURE `change_stock_produit` (IN `p_nom` VARCHAR(255), IN `p_prix` INT, IN `p_stock` INT)   BEGIN
    UPDATE produits SET stock = p_stock WHERE nom = p_nom;
END$$

DROP PROCEDURE IF EXISTS `checkupdate_procedure`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkupdate_procedure` (IN `p_nom` VARCHAR(255), IN `p_prix` INT, IN `p_stock` INT)   BEGIN
    DECLARE temp_name VARCHAR(255);
    DECLARE i INT DEFAULT 0;
    DECLARE aid INT;
    DECLARE anom VARCHAR(255);
   	DECLARE aprix INT;
    DECLARE flag INT;

    SET temp_name = p_nom;
    SET aid = NULL;
    SET anom = NULL;
    SET aprix = NULL;
    SET flag = 0;

    -- Check for duplicates
    SELECT id, nom, prix INTO aid, anom, aprix FROM produits WHERE nom = p_nom LIMIT 1;-- AND id <> NEW.id LIMIT 1;

    -- Modify name if a duplicate is found
    WHILE anom IS NOT NULL DO
    	IF (p_prix = aprix) THEN
        	INSERT INTO stock_updates(product_id, stock_change) VALUES (aid, p_stock);-- NEW.stock);
            -- LEAVE checkinsert;
            SET anom = NULL;
		ELSE
        	SET flag = 1;
        	-- SIGNAL SQLSTATE '45000'
            -- SET MESSAGE_TEXT='erreur';
            SET i = i + 1;
            SET temp_name = CONCAT(p_nom, '_', i);
            SET aid = NULL;
            SET anom = NULL;
            SELECT id, nom INTO aid, anom FROM produits WHERE nom = temp_name;-- AND id <> p_id LIMIT 1;
		END IF;
    END WHILE;
    
	IF (flag = 1) THEN
    	INSERT INTO produits (nom, prix, stock)
        VALUES (temp_name, aprix, p_stock);
    ELSE
    	UPDATE produits SET stock = stock + p_stock
        WHERE nom = p_nom;
	END IF;
    -- SET NEW.nom = temp_name;
END$$

DROP PROCEDURE IF EXISTS `insert_or_update_produit`$$
CREATE DEFINER=`samuel`@`%` PROCEDURE `insert_or_update_produit` (IN `p_nom` VARCHAR(255), IN `p_prix` INT, IN `p_stock` INT)   BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM produits WHERE nom = p_nom;--  AND prix = p_prix;
    IF v_count > 0 THEN
        CALL checkupdate_procedure(p_nom, p_prix, p_stock);-- UPDATE produits SET stock = stock + p_stock WHERE nom = p_nom;
    ELSE
        INSERT INTO produits (nom, prix, stock) VALUES (p_nom, p_prix, p_stock);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `process_stock_updates`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_stock_updates` ()   BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE product_id INT;
    DECLARE stock_change INT;
    DECLARE cur CURSOR FOR SELECT product_id, stock_change FROM stock_updates WHERE processed = 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO product_id, stock_change;
        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE produits SET stock = stock + stock_change WHERE id = product_id;
        UPDATE stock_updates SET processed = 1 WHERE product_id = product_id AND processed = 0;
    END LOOP;

    CLOSE cur;
END$$

DROP PROCEDURE IF EXISTS `update_produit`$$
CREATE DEFINER=`samuel`@`%` PROCEDURE `update_produit` (IN `p_nom` VARCHAR(255), IN `p_prix` INT, IN `p_stock` INT)   BEGIN
    UPDATE produits SET stock = stock + p_stock WHERE nom = p_nom;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `achats`
--

DROP TABLE IF EXISTS `achats`;
CREATE TABLE IF NOT EXISTS `achats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statut` int NOT NULL DEFAULT '0',
  `effectif` int NOT NULL DEFAULT '1',
  `id_produit` int DEFAULT NULL,
  `id_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `produits`
--

DROP TABLE IF EXISTS `produits`;
CREATE TABLE IF NOT EXISTS `produits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) DEFAULT NULL,
  `prix` int DEFAULT NULL,
  `stock` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `produits`
--

INSERT INTO `produits` (`id`, `nom`, `prix`, `stock`) VALUES
(1, 'Stylo bille_1', 2, 425),
(2, 'Carnet A5', 4, 124),
(3, 'Lampe de bureau', 13, 40),
(4, 'Câble USB-C', 6, 80),
(5, 'Souris optique', 10, 40),
(6, 'Tapis de souris', 5, 67),
(7, 'Chargeur téléphone_1', 15, 26),
(8, 'Écouteurs filaires', 8, 35),
(9, 'Bouteille isotherme', 11, 20),
(10, 'Clé USB 32Go', 9, 45),
(11, 'Produit de test', 69, 420),
(12, 'testtest', 42, 176),
(13, 'extincteur', 500, 10),
(14, 'testtest_1', 669, 10),
(15, 'bruh_1', 696, 6),
(16, 'armure', 8888, 3),
(17, 'armure_1', 4200, 1),
(18, 'hu_1_1', 42, 27502),
(19, 'hgzf', 69, 8901),
(20, 'gateau_1', 8, 1192),
(21, 'gateau', 6, -2),
(22, 'klhaz_1_1', 2147483647, 3),
(23, 'nouveau_3', 45, 690),
(24, 'nouveau_1', 48, 5438),
(25, 'nouveau_2', 48, 5424),
(26, 'nouveau_1_1', 48, 5424),
(27, 'nouveau_4', 45, 264),
(28, 'nouveau_5', 45, 264),
(29, 'nouveau', 45, 370),
(30, 'a', 14, 1438),
(31, 'ab', 10, 1),
(32, 'abb', 10, 1),
(33, 'a_1', 14, 1),
(34, 'a_2', 14, 11),
(35, 'a_3', 14, 11),
(36, 'a_4', 14, 11),
(37, 'a_5', 14, 7),
(38, 'a_6', 14, 7);

-- --------------------------------------------------------

--
-- Structure de la table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `role`
--

INSERT INTO `role` (`id`, `libelle`) VALUES
(1, 'admin'),
(2, 'normal');

-- --------------------------------------------------------

--
-- Structure de la table `sous`
--

DROP TABLE IF EXISTS `sous`;
CREATE TABLE IF NOT EXISTS `sous` (
  `id` int NOT NULL AUTO_INCREMENT,
  `balance` int DEFAULT '0',
  `id_user` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `sous`
--

INSERT INTO `sous` (`id`, `balance`, `id_user`) VALUES
(1, 0, 1),
(2, 2000, 2),
(3, 0, 3),
(4, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `stock_updates`
--

DROP TABLE IF EXISTS `stock_updates`;
CREATE TABLE IF NOT EXISTS `stock_updates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `stock_change` int DEFAULT NULL,
  `processed` bit(1) DEFAULT b'0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `stock_updates`
--

INSERT INTO `stock_updates` (`id`, `product_id`, `stock_change`, `processed`) VALUES
(1, 23, 242, b'0'),
(2, 23, 242, b'0'),
(3, 23, 242, b'0'),
(4, 30, 1423, b'0'),
(5, 30, 1424, b'0'),
(6, 30, 1425, b'0'),
(7, 30, 1426, b'0'),
(8, 30, 1427, b'0'),
(9, 30, 11, b'0'),
(10, 30, 11, b'0'),
(11, 30, 11, b'0');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(127) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `mdp` varchar(511) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `prenom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `idRole` int DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `email`, `mdp`, `nom`, `prenom`, `idRole`, `username`) VALUES
(1, NULL, 'MotDePasseNonSécuris&', NULL, NULL, 2, 'mario'),
(2, NULL, 'BouuuhtropNul', NULL, NULL, 1, 'samuel'),
(3, 'salut@gmail.com', 'pass123', 'salut', 'coucou', 1, 'salut'),
(4, NULL, NULL, NULL, NULL, NULL, 'test');

--
-- Déclencheurs `utilisateurs`
--
DROP TRIGGER IF EXISTS `checksous`;
DELIMITER $$
CREATE TRIGGER `checksous` BEFORE INSERT ON `utilisateurs` FOR EACH ROW BEGIN
	INSERT INTO sous (id_user)
    VALUES (NEW.id);
END
$$
DELIMITER ;

DELIMITER $$
--
-- Évènements
--
DROP EVENT IF EXISTS `process_stock_updates_event`$$
CREATE DEFINER=`root`@`localhost` EVENT `process_stock_updates_event` ON SCHEDULE EVERY 5 SECOND STARTS '2025-05-06 11:25:10' ON COMPLETION NOT PRESERVE ENABLE DO CALL process_stock_updates()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
