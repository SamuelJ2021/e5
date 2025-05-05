DROP PROCEDURE IF EXISTS change_prix_produit;
DELIMITER //

CREATE PROCEDURE change_prix_produit(
    IN orname VARCHAR(255),
    IN newprix INTEGER)
BEGIN
    UPDATE produits SET prix = newprix WHERE nom = orname;
END;
//
DELIMITER ;


DROP TRIGGER checkupdate;
DELIMITER //
CREATE TRIGGER checkupdate
BEFORE UPDATE ON produits
FOR EACH ROW
BEGIN
    DECLARE temp_name VARCHAR(255);
    DECLARE i INT DEFAULT 0;
    SET temp_name = NEW.nom;
    WHILE EXISTS (SELECT 1 FROM produits WHERE nom = temp_name AND id <> NEW.id) DO
        SET i = i + 1;
        SET temp_name = CONCAT(NEW.nom, '_', i);
    END WHILE;
    SET NEW.nom = temp_name;
	END//
DELIMITER ;

DROP TRIGGER IF EXISTS checkupdate;
DELIMITER //

CREATE TRIGGER checkupdate
BEFORE UPDATE ON produits
FOR EACH ROW
BEGIN
    DECLARE temp_name VARCHAR(255);
    DECLARE i INT DEFAULT 0;
    DECLARE aid INT;
    DECLARE anom VARCHAR(255);

    SET temp_name = NEW.nom;
    SET aid = NULL;
    SET anom = NULL;

    -- Check for duplicates
    SELECT id, nom INTO aid, anom FROM produits WHERE nom = temp_name AND id <> NEW.id LIMIT 1;

    -- Modify name if a duplicate is found
    WHILE anom IS NOT NULL DO
        SET i = i + 1;
        SET temp_name = CONCAT(NEW.nom, '_', i);
        SET aid = NULL;
        SET anom = NULL;
        SELECT id, nom INTO aid, anom FROM produits WHERE nom = temp_name AND id <> NEW.id LIMIT 1;
    END WHILE;

    SET NEW.nom = temp_name;
END//

DELIMITER ;






DROP TRIGGER IF EXISTS checkinsert;
DELIMITER //

CREATE TRIGGER checkinsert
BEFORE INSERT ON produits
FOR EACH ROW
BEGIN
    DECLARE temp_name VARCHAR(255);
    DECLARE i INT DEFAULT 0;
    DECLARE aid INT;
    DECLARE anom VARCHAR(255);

    SET temp_name = NEW.nom;
    SET anom = NULL;

    -- Check for duplicates
    SELECT nom INTO anom FROM produits WHERE nom = temp_name LIMIT 1;

    -- Modify name if a duplicate is found
    WHILE anom IS NOT NULL DO
        SET i = i + 1;
        SET temp_name = CONCAT(NEW.nom, '_', i);
        SET anom = NULL;
        SELECT nom INTO anom FROM produits WHERE nom = temp_name LIMIT 1;
    END WHILE;

    SET NEW.nom = temp_name;
END//

DELIMITER ;