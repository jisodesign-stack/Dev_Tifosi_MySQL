-- ============================================================
-- SCRIPT DE CRÉATION DU SCHÉMA DE LA BASE DE DONNÉES TIFOSI
-- Restaurant de Street-Food Italien
-- Auteur : [Votre nom]
-- Date : 06/01/2026
-- ============================================================

-- ============================================================
-- 1. CRÉATION DE LA BASE DE DONNÉES
-- ============================================================
DROP DATABASE IF EXISTS tifosi;
CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tifosi;

-- ============================================================
-- 2. CRÉATION DE L'UTILISATEUR ET ATTRIBUTION DES DROITS
-- ============================================================
-- Suppression de l'utilisateur s'il existe déjà
DROP USER IF EXISTS 'tifosi'@'localhost';

-- Création de l'utilisateur avec un mot de passe sécurisé
CREATE USER 'tifosi'@'localhost' IDENTIFIED BY 'Tifosi_2026!';

-- Attribution des droits d'administration sur la base tifosi
GRANT ALL PRIVILEGES ON tifosi.* TO 'tifosi'@'localhost';

-- Application des privilèges
FLUSH PRIVILEGES;

-- ============================================================
-- 3. CRÉATION DES TABLES
-- ============================================================

-- ------------------------------------------------------------
-- Table : ingredient
-- Description : Liste des ingrédients disponibles
-- ------------------------------------------------------------
CREATE TABLE ingredient (
    id_ingredient INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_ingredient PRIMARY KEY (id_ingredient),
    CONSTRAINT uk_ingredient_nom UNIQUE (nom)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : marque
-- Description : Marques des boissons
-- ------------------------------------------------------------
CREATE TABLE marque (
    id_marque INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    CONSTRAINT pk_marque PRIMARY KEY (id_marque),
    CONSTRAINT uk_marque_nom UNIQUE (nom)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : boisson
-- Description : Liste des boissons avec leur marque
-- ------------------------------------------------------------
CREATE TABLE boisson (
    id_boisson INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(60) NOT NULL,
    id_marque INT UNSIGNED NOT NULL,
    CONSTRAINT pk_boisson PRIMARY KEY (id_boisson),
    CONSTRAINT uk_boisson_nom UNIQUE (nom),
    CONSTRAINT fk_boisson_marque FOREIGN KEY (id_marque) 
        REFERENCES marque(id_marque)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : focaccia
-- Description : Liste des focaccias proposées
-- ------------------------------------------------------------
CREATE TABLE focaccia (
    id_focaccia INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(60) NOT NULL,
    prix DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_focaccia PRIMARY KEY (id_focaccia),
    CONSTRAINT uk_focaccia_nom UNIQUE (nom),
    CONSTRAINT chk_focaccia_prix CHECK (prix > 0)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : client
-- Description : Informations sur les clients
-- ------------------------------------------------------------
CREATE TABLE client (
    id_client INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL,
    code_postal INT UNSIGNED NOT NULL,
    CONSTRAINT pk_client PRIMARY KEY (id_client),
    CONSTRAINT uk_client_email UNIQUE (email),
    CONSTRAINT chk_client_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_client_code_postal CHECK (code_postal BETWEEN 1000 AND 99999)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table : menu
-- Description : Menus proposés (combinaison focaccia + boisson)
-- ------------------------------------------------------------
CREATE TABLE menu (
    id_menu INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nom VARCHAR(60) NOT NULL,
    prix DECIMAL(5,2) NOT NULL,
    CONSTRAINT pk_menu PRIMARY KEY (id_menu),
    CONSTRAINT uk_menu_nom UNIQUE (nom),
    CONSTRAINT chk_menu_prix CHECK (prix > 0)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table de liaison : comprend
-- Description : Association entre focaccia et ingrédients avec quantité
-- Cardinalités : focaccia (1,n) - ingredient (0,n)
-- ------------------------------------------------------------
CREATE TABLE comprend (
    id_focaccia INT UNSIGNED NOT NULL,
    id_ingredient INT UNSIGNED NOT NULL,
    quantite INT UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT pk_comprend PRIMARY KEY (id_focaccia, id_ingredient),
    CONSTRAINT fk_comprend_focaccia FOREIGN KEY (id_focaccia) 
        REFERENCES focaccia(id_focaccia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_comprend_ingredient FOREIGN KEY (id_ingredient) 
        REFERENCES ingredient(id_ingredient)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT chk_comprend_quantite CHECK (quantite > 0)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table de liaison : est_constitue
-- Description : Association entre menu et focaccia
-- Cardinalités : menu (1,1) - focaccia (0,n)
-- ------------------------------------------------------------
CREATE TABLE est_constitue (
    id_menu INT UNSIGNED NOT NULL,
    id_focaccia INT UNSIGNED NOT NULL,
    CONSTRAINT pk_est_constitue PRIMARY KEY (id_menu, id_focaccia),
    CONSTRAINT fk_est_constitue_menu FOREIGN KEY (id_menu) 
        REFERENCES menu(id_menu)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_est_constitue_focaccia FOREIGN KEY (id_focaccia) 
        REFERENCES focaccia(id_focaccia)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table de liaison : contient
-- Description : Association entre menu et boisson
-- Cardinalités : menu (1,n) - boisson (0,n)
-- ------------------------------------------------------------
CREATE TABLE contient (
    id_menu INT UNSIGNED NOT NULL,
    id_boisson INT UNSIGNED NOT NULL,
    CONSTRAINT pk_contient PRIMARY KEY (id_menu, id_boisson),
    CONSTRAINT fk_contient_menu FOREIGN KEY (id_menu) 
        REFERENCES menu(id_menu)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_contient_boisson FOREIGN KEY (id_boisson) 
        REFERENCES boisson(id_boisson)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Table de liaison : achete
-- Description : Historique des achats clients
-- Cardinalités : client (0,n) - menu (0,n)
-- ------------------------------------------------------------
CREATE TABLE achete (
    id_client INT UNSIGNED NOT NULL,
    id_menu INT UNSIGNED NOT NULL,
    date_achat DATE NOT NULL,
    CONSTRAINT pk_achete PRIMARY KEY (id_client, id_menu, date_achat),
    CONSTRAINT fk_achete_client FOREIGN KEY (id_client) 
        REFERENCES client(id_client)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_achete_menu FOREIGN KEY (id_menu) 
        REFERENCES menu(id_menu)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- 4. CRÉATION DES INDEX POUR OPTIMISATION
-- ============================================================
CREATE INDEX idx_boisson_marque ON boisson(id_marque);
CREATE INDEX idx_comprend_ingredient ON comprend(id_ingredient);
CREATE INDEX idx_achete_date ON achete(date_achat);

-- ============================================================
-- FIN DU SCRIPT DE CRÉATION
-- ============================================================
