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