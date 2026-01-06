-- ============================================================
-- REQUETES DE TEST - BASE TIFOSI
-- ============================================================
USE tifosi;

-- ============================================================
-- REQUETE 1
-- But : Afficher la liste des noms des focaccias par ordre alphabetique croissant
-- ============================================================
SELECT nom FROM focaccia ORDER BY nom ASC;

-- Resultat attendu : 8 focaccias triees de A a Z
-- | nom             |
-- |-----------------|  
-- | Americaine      |
-- | Emmentalaccia   |
-- | Gorgonzollaccia |
-- | Hawaienne       |
-- | Mozaccia        |
-- | Paysanne        |
-- | Raclaccia       |
-- | Tradizione      |

-- Resultat obtenu : Conforme
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 2
-- But : Afficher le nombre total d'ingredients
-- ============================================================
SELECT COUNT(*) AS nombre_total_ingredients FROM ingredient;

-- Resultat attendu : 25
-- | nombre_total_ingredients |
-- |--------------------------|  
-- | 25                       |

-- Resultat obtenu : 25
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 3
-- But : Afficher le prix moyen des focaccias
-- ============================================================
SELECT ROUND(AVG(prix), 2) AS prix_moyen_focaccia FROM focaccia;

-- Resultat attendu : 10.38 (moyenne de 9.80+10.80+8.90+9.80+8.90+11.20+10.80+12.80 = 83/8)
-- | prix_moyen_focaccia |
-- |---------------------|
-- | 10.38               |

-- Resultat obtenu : 10.38
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 4
-- But : Afficher la liste des boissons avec leur marque, triee par nom de boisson
-- ============================================================
SELECT b.nom AS boisson, m.nom AS marque
FROM boisson b
INNER JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

-- Resultat attendu : 12 boissons avec leur marque
-- | boisson                   | marque      |
-- |---------------------------|-------------|
-- | Capri-sun                 | Coca-cola   |
-- | Coca-cola original        | Coca-cola   |
-- | Coca-cola zero            | Coca-cola   |
-- | Eau de source             | Cristalline |
-- | Fanta citron              | Coca-cola   |
-- | Fanta orange              | Coca-cola   |
-- | Lipton Peach              | Pepsico     |
-- | Lipton zero citron        | Pepsico     |
-- | Monster energy ultra blue | Monster     |
-- | Monster energy ultra gold | Monster     |
-- | Pepsi                     | Pepsico     |
-- | Pepsi Max Zero            | Pepsico     |

-- Resultat obtenu : 12 lignes conformes
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 5
-- But : Afficher la liste des ingredients pour une Raclaccia
-- ============================================================
SELECT i.nom AS ingredient, c.quantite AS grammes
FROM ingredient i
INNER JOIN comprend c ON i.id_ingredient = c.id_ingredient
INNER JOIN focaccia f ON c.id_focaccia = f.id_focaccia
WHERE f.nom = 'Raclaccia'
ORDER BY i.nom ASC;

-- Resultat attendu : 7 ingredients
-- | ingredient  | grammes |
-- |-------------|---------|
-- | Ail         | 2       |
-- | Base Tomate | 200     |
-- | Champignon  | 40      |
-- | Cresson     | 20      |
-- | Parmesan    | 50      |
-- | Poivre      | 1       |
-- | Raclette    | 50      |

-- Resultat obtenu : 7 lignes conformes
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 6
-- But : Afficher le nom et le nombre d'ingredients pour chaque focaccia
-- ============================================================
SELECT f.nom AS focaccia, COUNT(c.id_ingredient) AS nb_ingredients
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
GROUP BY f.id_focaccia, f.nom
ORDER BY f.nom ASC;

-- Resultat attendu : 8 lignes
-- | focaccia        | nb_ingredients |
-- |-----------------|----------------|
-- | Americaine      | 8              |
-- | Emmentalaccia   | 7              |
-- | Gorgonzollaccia | 8              |
-- | Hawaienne       | 9              |
-- | Mozaccia        | 10             |
-- | Paysanne        | 12             |
-- | Raclaccia       | 7              |
-- | Tradizione      | 9              |

-- Resultat obtenu : 8 lignes conformes
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 7
-- But : Afficher le nom de la focaccia qui a le plus d'ingredients
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

-- Resultat attendu : Paysanne avec 12 ingredients
-- | focaccia | nb_ingredients |
-- |----------|----------------|
-- | Paysanne | 12             |

-- Resultat obtenu : Paysanne (12)
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 8
-- But : Afficher la liste des focaccia qui contiennent de l'ail
-- ============================================================
SELECT DISTINCT f.nom AS focaccia
FROM focaccia f
INNER JOIN comprend c ON f.id_focaccia = c.id_focaccia
INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
WHERE i.nom = 'Ail'
ORDER BY f.nom ASC;

-- Resultat attendu : 4 focaccias
-- | focaccia        |
-- |-----------------|
-- | Gorgonzollaccia |
-- | Mozaccia        |
-- | Paysanne        |
-- | Raclaccia       |

-- Resultat obtenu : 4 lignes conformes
-- Commentaire : Aucun ecart

-- ============================================================
-- REQUETE 9
-- But : Afficher la liste des ingredients inutilises
-- ============================================================
SELECT i.nom AS ingredient_inutilise
FROM ingredient i
LEFT JOIN comprend c ON i.id_ingredient = c.id_ingredient
WHERE c.id_ingredient IS NULL
ORDER BY i.nom ASC;

-- Resultat attendu : 2 ingredients non utilises
-- | ingredient_inutilise |
-- |----------------------|
-- | Salami               |
-- | Tomate cerise        |

-- Resultat obtenu : Salami, Tomate cerise
-- Commentaire : Aucun ecart - Ces ingredients sont dans la liste mais pas dans les recettes

-- ============================================================
-- REQUETE 10
-- But : Afficher la liste des focaccia qui n'ont pas de champignons
-- ============================================================
SELECT f.nom AS focaccia
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT c.id_focaccia FROM comprend c
    INNER JOIN ingredient i ON c.id_ingredient = i.id_ingredient
    WHERE i.nom = 'Champignon'
)
ORDER BY f.nom ASC;

-- Resultat attendu : 2 focaccias sans champignon
-- | focaccia   |
-- |------------|
-- | Americaine |
-- | Hawaienne  |

-- Resultat obtenu : Americaine, Hawaienne
-- Commentaire : Aucun ecart - Seules ces 2 focaccias n'ont pas de champignon dans leur composition

-- ============================================================
-- FIN DES REQUETES DE TEST
-- ============================================================
