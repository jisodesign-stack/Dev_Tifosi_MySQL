-- REQUETES DE TEST - BASE TIFOSI
USE tifosi;

-- ============================================================
-- REQUETE 1 : Liste des focaccias par ordre alphabetique
-- ============================================================
SELECT nom FROM focaccia ORDER BY nom ASC;
-- Attendu : 8 focaccias (Americaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, Mozaccia, Paysanne, Raclaccia, Tradizione)
-- Obtenu : Conforme

-- ============================================================
-- REQUETE 2 : Nombre total d'ingredients
-- ============================================================
SELECT COUNT(*) AS nombre_total_ingredients FROM ingredient;
-- Attendu : 25
-- Obtenu : 25 - Conforme

-- ============================================================
-- REQUETE 3 : Prix moyen des focaccias
-- ============================================================
SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccia FROM focaccia;
-- Attendu : 10.38
-- Obtenu : 10.38 - Conforme

-- ============================================================
-- REQUETE 4 : Boissons avec leur marque, triees par nom
-- ============================================================
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
INNER JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;
-- Attendu : 12 boissons avec leur marque associee
-- Obtenu : 12 lignes - Conforme

-- ============================================================
-- REQUETE 5 : Ingredients de la Raclaccia
-- ============================================================
SELECT i.nom AS ingredient, c.quantite AS grammes
FROM ingredient i
INNER JOIN comprend c ON i.id_ingredient = c.id_ingredient
INNER JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;
-- Attendu : 7 ingredients (Ail, Base Tomate, Champignon, Cresson, Parmesan, Poivre, Raclette)
-- Obtenu : 7 lignes - Conforme

-- ============================================================
-- REQUETE 6 : Nombre d'ingredients par focaccia
-- ============================================================
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;
-- Attendu : 8 lignes (Americaine:8, Emmentalaccia:7, Gorgonzollaccia:8, Hawaienne:9, Mozaccia:10, Paysanne:12, Raclaccia:7, Tradizione:9)
-- Obtenu : Conforme

-- ============================================================
-- REQUETE 7 : Focaccia avec le plus d'ingredients
-- ============================================================
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
HAVING COUNT(c.id_ingredient) = (
    SELECT MAX(nb) FROM (
        SELECT COUNT(id_ingredient) AS nb FROM comprend GROUP BY id_focaccia
    ) t
);
-- Attendu : Paysanne (12 ingredients)
-- Obtenu : Paysanne (12) - Conforme

-- ============================================================
-- REQUETE 8 : Focaccias contenant de l'ail
-- ============================================================
SELECT DISTINCT f.nom AS focaccia
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;
-- Attendu : 4 focaccias (Gorgonzollaccia, Mozaccia, Paysanne, Raclaccia)
-- Obtenu : 4 lignes - Conforme

-- ============================================================
-- REQUETE 9 : Ingredients inutilises
-- ============================================================
SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;
-- Attendu : 2 ingredients (Salami, Tomate cerise)
-- Obtenu : Salami, Tomate cerise - Conforme

-- ============================================================
-- REQUETE 10 : Focaccias sans champignons
-- ============================================================
SELECT f.nom AS focaccia
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia FROM comprend c
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;
-- Attendu : 2 focaccias (Americaine, Hawaienne)
-- Obtenu : Americaine, Hawaienne - Conforme
