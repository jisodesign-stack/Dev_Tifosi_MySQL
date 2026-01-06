# 🍕 Tifosi - Base de données MySQL

Projet de base de données pour le restaurant de Street-Food italien **Tifosi**.

## 📋 Description

Ce projet contient les scripts SQL pour créer et gérer une base de données MySQL permettant de gérer :
- Les focaccias et leurs ingrédients
- Les boissons et leurs marques
- Les menus et les achats clients

## 📁 Structure du projet

```
Dev_Tifosi_MySQL/
├── 01_creation_schema_tifosi.sql   # Création du schéma de la BDD
├── 02_insertion_donnees_tifosi.sql # Insertion des données de test
├── 03_requetes_test_tifosi.sql     # 10 requêtes de vérification
└── README.md                        # Ce fichier
```

## 🚀 Installation

### Prérequis
- MySQL Server 8.0 ou supérieur
- Client MySQL (ligne de commande ou GUI comme phpMyAdmin, MySQL Workbench)

### Exécution des scripts

Exécutez les scripts dans l'ordre suivant :

```sql
-- 1. Création du schéma (inclut la création de l'utilisateur 'tifosi')
source 01_creation_schema_tifosi.sql;

-- 2. Insertion des données de test
source 02_insertion_donnees_tifosi.sql;

-- 3. Exécution des requêtes de test
source 03_requetes_test_tifosi.sql;
```

Ou en ligne de commande :

```bash
mysql -u root -p < 01_creation_schema_tifosi.sql
mysql -u root -p < 02_insertion_donnees_tifosi.sql
mysql -u root -p < 03_requetes_test_tifosi.sql
```

## 🗄️ Schéma de la base de données

### Tables principales
| Table | Description |
|-------|-------------|
| `ingredient` | Liste des 25 ingrédients disponibles |
| `marque` | Marques de boissons (4 marques) |
| `boisson` | Liste des 12 boissons |
| `focaccia` | Liste des 8 focaccias avec prix |
| `client` | Informations clients |
| `menu` | Menus proposés |

### Tables de liaison
| Table | Description |
|-------|-------------|
| `comprend` | Focaccia ↔ Ingrédients (avec quantité en grammes) |
| `est_constitue` | Menu ↔ Focaccia |
| `contient` | Menu ↔ Boisson |
| `achete` | Client ↔ Menu (historique d'achats) |

## 👤 Utilisateur créé

- **Nom d'utilisateur** : `tifosi`
- **Mot de passe** : `Tifosi_2026!`
- **Droits** : Tous les privilèges sur la base `tifosi`

## 📝 Requêtes de test

Le script `03_requetes_test_tifosi.sql` contient 10 requêtes de vérification :

1. Liste des focaccias par ordre alphabétique
2. Nombre total d'ingrédients
3. Prix moyen des focaccias
4. Boissons avec leur marque (triées)
5. Ingrédients de la Raclaccia
6. Nombre d'ingrédients par focaccia
7. Focaccia avec le plus d'ingrédients
8. Focaccias contenant de l'ail
9. Ingrédients inutilisés
10. Focaccias sans champignons

## 📄 Licence

Projet réalisé dans le cadre de la formation du Centre Européen de Formation.

---
*Date : Janvier 2026*
