-- Crea il database "progetto_fav_dw"
CREATE DATABASE progetto_fav_dw;

-- Seleziona il database "progetto_fav_dw" per l'uso
USE progetto_fav_dw;

-- Crea la tabella di dimensione del tempo con chiave primaria "Data_ordine"
CREATE TABLE DimTempo (
    Data_ordine DATE PRIMARY KEY, -- Data dell'ordine
    Anno INT,                     -- Anno dell'ordine
    Mese INT,                     -- Mese dell'ordine
    Giorno INT,                   -- Giorno dell'ordine
    Trimestre INT                 -- Trimestre dell'ordine
);

-- Crea la tabella di dimensione del prodotto con chiave primaria "ID_prodotto"
CREATE TABLE DimProdotto (
    ID_prodotto CHAR(7) PRIMARY KEY,  -- ID univoco del prodotto
    Nome VARCHAR(25),                 -- Nome del prodotto
    ID_categoria VARCHAR(20),         -- ID della categoria del prodotto
    Prezzo DECIMAL(7,2),              -- Prezzo del prodotto
    Quantità_magazzino INT(5)         -- Quantità disponibile in magazzino
);

-- Crea la tabella di dimensione dell'utente con chiave primaria "ID_utente"
CREATE TABLE DimUtente (
    ID_utente CHAR(15) PRIMARY KEY,   -- ID univoco dell'utente
    Nome VARCHAR(25),                 -- Nome dell'utente
    Cognome VARCHAR(25),              -- Cognome dell'utente
    Data_di_nascita DATE,             -- Data di nascita dell'utente
    E_mail VARCHAR(50),               -- Email dell'utente
    Telefono CHAR(13)                 -- Telefono dell'utente
);

-- Crea la tabella di dimensione della categoria con chiave primaria "ID_categoria"
CREATE TABLE DimCategoria (
    ID_categoria VARCHAR(20) PRIMARY KEY, -- ID univoco della categoria
    Nome VARCHAR(25),                     -- Nome della categoria
    Descrizione VARCHAR(100)              -- Descrizione della categoria
);

-- Crea la tabella dei fatti delle vendite con chiave primaria composta da "ID_ordine" e "ID_prodotto"
CREATE TABLE FattoVendite (
    ID_ordine CHAR(15),                -- ID univoco dell'ordine
    Data_ordine DATE,                  -- Data dell'ordine
    Totale_ordine DECIMAL(10,2),       -- Totale dell'ordine
    Quantita_ordine INT,               -- Quantità dell'ordine
    ID_utente CHAR(15),                -- ID univoco dell'utente che ha fatto l'ordine
    ID_prodotto CHAR(7),               -- ID univoco del prodotto ordinato
    PRIMARY KEY (ID_ordine, ID_prodotto), -- Chiave primaria composta
    FOREIGN KEY (Data_ordine) REFERENCES DimTempo(Data_ordine),  -- Chiave esterna riferita alla tabella DimTempo
    FOREIGN KEY (ID_utente) REFERENCES DimUtente(ID_utente),     -- Chiave esterna riferita alla tabella DimUtente
    FOREIGN KEY (ID_prodotto) REFERENCES DimProdotto(ID_prodotto) -- Chiave esterna riferita alla tabella DimProdotto
);

-- Popola la tabella DimTempo con dati distinti dalla tabella Ordine del database originale
INSERT INTO DimTempo (Data_ordine, Anno, Mese, Giorno, Trimestre)
SELECT DISTINCT
    Data_ordine,
    YEAR(Data_ordine),
    MONTH(Data_ordine),
    DAY(Data_ordine),
    QUARTER(Data_ordine)
FROM progetto_fav.Ordine;

-- Popola la tabella DimProdotto con dati dalla tabella Prodotto del database originale
INSERT INTO DimProdotto (ID_prodotto, Nome, ID_categoria, Prezzo, Quantità_magazzino)
SELECT
    ID_prodotto,
    Nome,
    ID_categoria,
    Prezzo,
    Quantita_Magazzino
FROM progetto_fav.Prodotto;

-- Popola la tabella DimUtente con dati dalla tabella Utente del database originale
INSERT INTO DimUtente (ID_utente, Nome, Cognome, Data_di_nascita, E_mail, Telefono)
SELECT
    ID_utente,
    Nome,
    Cognome,
    Data_di_nascita,
    E_mail,
    Telefono
FROM progetto_fav.Utente;

-- Popola la tabella DimCategoria con dati dalla tabella Categoria del database originale
INSERT INTO DimCategoria (ID_categoria, Nome, Descrizione)
SELECT
    ID_categoria,
    Nome,
    Descrizione
FROM progetto_fav.Categoria;

-- Popola la tabella FattoVendite con dati combinati dalle tabelle Ordine e Linea_di_carrello del database originale
INSERT INTO FattoVendite (ID_ordine, Data_ordine, Totale_ordine, Quantita_ordine, ID_utente, ID_prodotto)
SELECT
    o.ID_ordine,
    o.Data_ordine,
    o.Totale_ordine,
    lc.Quantita_di_ordine,
    o.ID_utente,
    lc.ID_prodotto
FROM progetto_fav.Ordine o
JOIN progetto_fav.Linea_di_carrello lc ON o.ID_carrello = lc.ID_carrello;
