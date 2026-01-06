-- REQUETES DE TEST - BASE TIFOSI
USE tifosi;

-- 1. Liste des focaccias par ordre alphabetique
SELECT nom FROM focaccia ORDER BY nom ASC;

-- 2. Nombre total d'ingredients
SELECT COUNT(*) AS nombre_total_ingredients FROM ingredient;

-- 3. Prix moyen des focaccias
SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccia FROM focaccia;

-- 4. Boissons avec leur marque, triees par nom
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
INNER JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

-- 5. Ingredients de la Raclaccia
SELECT i.nom AS ingredient, c.quantite AS grammes
FROM ingredient i
INNER JOIN comprend c ON i.id_ingredient = c.id_ingredient
INNER JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

-- 6. Nombre d'ingredients par focaccia
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

-- 7. Focaccia avec le plus d'ingredients
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
HAVING COUNT(c.id_ingredient) = (
    SELECT MAX(nb) FROM (
        SELECT COUNT(id_ingredient) AS nb FROM comprend GROUP BY id_focaccia
    ) t
);

-- 8. Focaccias contenant de l'ail
SELECT DISTINCT f.nom AS focaccia
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

-- 9. Ingredients inutilises
SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;

-- 10. Focaccias sans champignons
SELECT f.nom AS focaccia
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia FROM comprend c
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;
