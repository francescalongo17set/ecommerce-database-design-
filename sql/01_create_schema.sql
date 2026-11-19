-- Crea il database
CREATE DATABASE progetto_fav;

-- Usa il db
use progetto_fav;

-- Crea le tabelle del database
CREATE TABLE Categoria (
		ID_categoria VARCHAR(20) NOT NULL,
        Nome VARCHAR(25),
        Descrizione VARCHAR(100) NULL,
CONSTRAINT Categoria_PK PRIMARY KEY (ID_categoria));

CREATE TABLE Prodotto (
	ID_prodotto CHAR(7) NOT NULL,
    ID_categoria VARCHAR(20) NOT NULL,
    Nome VARCHAR(25),
    Descrizione VARCHAR(100), 
    Prezzo DECIMAL(7,2),
    Foto_Prodotto VARCHAR(2083) NULL,
    Quantita_Magazzino INT(5),
CONSTRAINT Prodotto_PK PRIMARY KEY (ID_prodotto),
CONSTRAINT Prodotto_FK FOREIGN KEY (ID_categoria) REFERENCES Categoria(ID_categoria)
);

CREATE TABLE Ruolo (
	ID_Ruolo CHAR(1) NOT NULL,
    Nome VARCHAR(10),
CONSTRAINT Ruolo_PK PRIMARY KEY (ID_Ruolo)
);

CREATE TABLE Utente (
	ID_utente CHAR(15) NOT NULL,
    Nome VARCHAR(25),
    Cognome VARCHAR(25),
    Data_di_nascita DATE,
    E_mail VARCHAR(50),
    Telefono CHAR(13),
    Password_utente VARCHAR(15),
    ID_Ruolo CHAR(1) NOT NULL,
CONSTRAINT Utente_PK PRIMARY KEY (ID_Utente),
CONSTRAINT Utente_FK FOREIGN KEY (ID_Ruolo) REFERENCES Ruolo(ID_Ruolo)
);

CREATE TABLE Promozione (
	ID_promozione CHAR(7) NOT NULL,
    ID_categoria CHAR(7) NULL,
    ID_prodotto CHAR(7) NULL,
    Nome VARCHAR(25),
    Percentuale_sconto INT(3),
    Data_inizio DATE NULL,
    Data_fine DATE NULL,
CONSTRAINT Promozione_PK PRIMARY KEY (ID_promozione),
CONSTRAINT Promozione_FK1 FOREIGN KEY (ID_categoria) REFERENCES Categoria(ID_categoria),
CONSTRAINT Promozione_FK2 FOREIGN KEY (ID_prodotto) REFERENCES Prodotto(ID_prodotto)
);

CREATE TABLE Carrello (
    ID_carrello CHAR(7) NOT NULL,
    ID_utente CHAR(15) NOT NULL,
CONSTRAINT Carrello_PK PRIMARY KEY (ID_carrello),
CONSTRAINT Carrello_FK FOREIGN KEY (ID_utente) REFERENCES Utente(ID_utente)
);

CREATE TABLE Linea_di_carrello (
    ID_carrello CHAR(7) NOT NULL,
    ID_prodotto CHAR(7) NOT NULL,
    Quantita_di_ordine INT(4) NOT NULL,
CONSTRAINT Linea_di_carrello_PK PRIMARY KEY (ID_carrello, ID_prodotto),
CONSTRAINT Linea_di_carrello_FK1 FOREIGN KEY (ID_carrello) REFERENCES Carrello(ID_carrello),
CONSTRAINT Linea_di_carrello_FK2 FOREIGN KEY (ID_prodotto) REFERENCES Prodotto(ID_prodotto)
);

CREATE TABLE Ordine (
	ID_ordine CHAR(15) NOT NULL,
    ID_utente CHAR(7) NOT NULL,
	ID_carrello CHAR(7) NOT NULL,
	Data_ordine DATE, 
    Totale_ordine FLOAT(6),
	Modalita_di_pagamento VARCHAR(50),
	Tipo_carta VARCHAR(25),
	Numero_carta CHAR(17),
	Data_scadenza DATE,
	Intestatario VARCHAR(50),
    Zona_di_spedizione VARCHAR(7),
    Via VARCHAR(50),
    Numero_civico CHAR(5),
    Cap CHAR(5),
    Comune VARCHAR(25),
    Provincia VARCHAR(25),
CONSTRAINT Ordine_PK PRIMARY KEY (ID_ordine),
CONSTRAINT Ordine_FK1 FOREIGN KEY (ID_utente) REFERENCES Utente(ID_utente),
CONSTRAINT Ordine_FK2 FOREIGN KEY (ID_carrello) REFERENCES Carrello(ID_carrello)
);


CREATE TABLE Recensione ( 
	ID_recensione CHAR(7) NOT NULL,
    ID_ordine CHAR(7) NOT NULL,
    ID_utente CHAR(7) NOT NULL,
    ID_prodotto CHAR(7),
    Voto INT,
    Commento VARCHAR(100) NULL,
CONSTRAINT Recensione_PK PRIMARY KEY (ID_recensione),
CONSTRAINT Recensione_FK1 FOREIGN KEY (ID_ordine) REFERENCES Ordine(ID_ordine),
CONSTRAINT Recensione_FK2 FOREIGN KEY (ID_utente) REFERENCES Utente(ID_utente),
CONSTRAINT Recensione_FK3 FOREIGN KEY (ID_prodotto) REFERENCES Prodotto(ID_prodotto)
);