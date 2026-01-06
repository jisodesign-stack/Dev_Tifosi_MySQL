# Tifosi - Base de données MySQL

Base de données pour le restaurant de Street-Food italien **Tifosi**.

## 📁 Fichiers

| Fichier | Description |
|---------|-------------|
| `01_creation_schema_tifosi.sql` | Création de la BDD et des tables |
| `02_insertion_donnees_tifosi.sql` | Insertion des données de test |
| `03_requetes_test_tifosi.sql` | 10 requêtes de vérification |

## 🚀 Installation

```bash
mysql -u root -p < 01_creation_schema_tifosi.sql
mysql -u root -p < 02_insertion_donnees_tifosi.sql
mysql -u root -p < 03_requetes_test_tifosi.sql
```

## 🗄️ Tables

**Principales** : `ingredient` (25), `marque` (4), `boisson` (12), `focaccia` (8), `client`, `menu`

**Liaison** : `comprend`, `est_constitue`, `contient`, `achete`

## 👤 Connexion

| Utilisateur | Mot de passe |
|-------------|--------------|
| `tifosi` | `Tifosi_2026!` |

---
*Projet CEF - Janvier 2026*
