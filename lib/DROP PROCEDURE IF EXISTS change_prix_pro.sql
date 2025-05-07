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
    DECLARE aprix INT;

    SET temp_name = NEW.nom;
    SET aid = NULL;
    SET anom = NULL;
    SET aprix = NULL;

    -- Check for duplicates
    SELECT id, nom, prix INTO aid, anom, aprix FROM produits WHERE nom = temp_name LIMIT 1;

    -- Modify name if a duplicate is found, if same price stock is added to the existing
    WHILE anom IS NOT NULL DO
    	IF (NEW.prix = aprix) THEN
        	INSERT INTO stock_updates (product_id, stock_change) VALUES (aid, NEW.stock);
            -- LEAVE checkinsert;
            SET anom = NULL;
        ELSE
            SET i = i + 1;
            SET temp_name = CONCAT(NEW.nom, '_', i);
            SET anom = NULL;
            SET aprix = NULL;
            SELECT id, nom, prix INTO aid, anom, aprix FROM produits WHERE nom = temp_name LIMIT 1;
        END IF;
    END WHILE;

    SET NEW.nom = temp_name;
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE process_stock_updates()
BEGIN
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
END//

DELIMITER ;

CREATE EVENT process_stock_updates_event
ON SCHEDULE EVERY 5 SECOND
DO
CALL process_stock_updates();