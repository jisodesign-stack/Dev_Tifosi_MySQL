-- ============================================================
-- SCRIPT DES REQUÊTES DE TEST - BASE TIFOSI
-- Restaurant de Street-Food Italien
-- Auteur : [Votre nom]
-- Date : 06/01/2026
-- ============================================================

USE tifosi;

-- ============================================================
-- REQUÊTE 1
-- But : Afficher la liste des noms des focaccias par ordre 
--       alphabétique croissant
-- ============================================================
-- Résultat attendu : 8 focaccias triées de A à Z
-- (Américaine, Emmentalaccia, Gorgonzollaccia, Hawaienne, 
--  Mozaccia, Paysanne, Raclaccia, Tradizione)

SELECT nom
FROM focaccia
ORDER BY nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 2
-- But : Afficher le nombre total d'ingrédients
-- ============================================================
-- Résultat attendu : 25 ingrédients

SELECT COUNT(*) AS nombre_total_ingredients
FROM ingredient;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 3
-- But : Afficher le prix moyen des focaccias
-- ============================================================
-- Résultat attendu : Moyenne de (9.80+10.80+8.90+9.80+8.90+11.20+10.80+12.80)/8 = 10.375

SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccia
FROM focaccia;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 4
-- But : Afficher la liste des boissons avec leur marque, 
--       triée par nom de boisson
-- ============================================================
-- Résultat attendu : 12 boissons avec leur marque associée,
-- triées alphabétiquement par nom de boisson

SELECT b.nom AS nom_boisson, m.nom AS marque
FROM boisson b
INNER JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 5
-- But : Afficher la liste des ingrédients pour une Raclaccia
-- ============================================================
-- Résultat attendu : 7 ingrédients
-- (Base Tomate, Raclette, Cresson, Ail, Champignon, Parmesan, Poivre)

SELECT i.nom AS ingredient, c.quantite AS quantite_grammes
FROM ingredient i
INNER JOIN comprend c ON i.id_ingredient = c.id_ingredient
INNER JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 6
-- But : Afficher le nom et le nombre d'ingrédients pour 
--       chaque focaccia
-- ============================================================
-- Résultat attendu : 8 lignes avec le nom de chaque focaccia
-- et son nombre d'ingrédients

SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 7
-- But : Afficher le nom de la focaccia qui a le plus 
--       d'ingrédients
-- ============================================================
-- Résultat attendu : Paysanne (12 ingrédients)

SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nombre_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
HAVING COUNT(c.id_ingredient) = (
    SELECT MAX(nb_ing)
    FROM (
        SELECT COUNT(id_ingredient) AS nb_ing
        FROM comprend
        GROUP BY id_focaccia
    ) AS sous_requete
);

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 8
-- But : Afficher la liste des focaccia qui contiennent de l'ail
-- ============================================================
-- Résultat attendu : Focaccias contenant l'ingrédient "Ail"
-- (Mozaccia, Gorgonzollaccia, Raclaccia, Paysanne)

SELECT DISTINCT f.nom AS focaccia
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 9
-- But : Afficher la liste des ingrédients inutilisés
-- ============================================================
-- Résultat attendu : Ingrédients qui ne sont dans aucune focaccia
-- (Salami, Tomate cerise)

SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- REQUÊTE 10
-- But : Afficher la liste des focaccia qui n'ont pas de 
--       champignons
-- ============================================================
-- Résultat attendu : Focaccias sans l'ingrédient "Champignon"
-- (Hawaienne, Américaine) - Note: vérifier selon les données

SELECT f.nom AS focaccia
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia
    FROM comprend c
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;

-- Résultat obtenu : [À compléter après exécution]
-- Commentaire : [À compléter si écart]


-- ============================================================
-- FIN DU SCRIPT DE REQUÊTES DE TEST
-- ============================================================
