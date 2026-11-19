-- 1 Query per visualizzare il catalogo per categoria
SELECT *
FROM Prodotto 
WHERE ID_Categoria = 'ALI';

-- 2 Query per visualizzare il catalogo per tipo di prodotto
SELECT *
FROM PRODOTTO 
WHERE Nome LIKE "%Smartphone%";

-- 3 Query per visualizzare il carrello con il costo complessivo per un utente specifico (USR002)
SELECT Utente.Nome, Utente.Cognome, Carrello.ID_carrello, SUM(Prodotto.Prezzo * Linea_di_carrello.Quantita_di_ordine) AS Totale_Carrello
FROM Utente 
JOIN Carrello ON Utente.ID_utente = Carrello.ID_utente 
JOIN Linea_di_carrello ON Carrello.ID_carrello = Linea_di_carrello.ID_carrello  
JOIN Prodotto ON Linea_di_carrello.ID_prodotto = Prodotto.ID_prodotto
WHERE Utente.ID_utente = 'USR002'  
GROUP BY Utente.Nome, Utente.Cognome, Carrello.ID_carrello;

-- 4 Query per visualizzare le recensioni con voto maggiore di 4
SELECT *
FROM Recensione
WHERE Voto > 4;

-- 5 Query per visualizzare le specifiche di spedizione per un ordine specifico (ORD005)
SELECT Zona_di_spedizione, Via, Numero_civico, Cap, Comune, Provincia
FROM Ordine
WHERE ID_Ordine = 'ORD005';

-- 6 Query per visualizzare gli acquisti suddivisi per zona di spedizione (Italia)
SELECT Prodotto.Nome, Linea_di_carrello.Quantita_di_ordine
FROM Carrello 
JOIN Linea_di_carrello ON Carrello.ID_carrello = Linea_di_carrello.ID_carrello 
JOIN Prodotto ON Linea_di_carrello.ID_prodotto = Prodotto.ID_prodotto 
JOIN Ordine ON Carrello.ID_carrello = Ordine.ID_carrello
WHERE Zona_di_spedizione = 'Italia';

-- 7 Query per visualizzare la lista dei clienti con il numero di ordini effettuati
SELECT Utente.Nome, Utente.Cognome, COUNT(Ordine.ID_ordine) AS Numero_ordini
FROM Ordine 
JOIN Utente ON Ordine.ID_utente = Utente.ID_utente
WHERE Utente.ID_Ruolo = '1'
GROUP BY Utente.Nome, Utente.Cognome;

-- 8 Query per visualizzare il numero di acquisti per ogni prodotto
SELECT Prodotto.Nome, SUM(Linea_di_carrello.Quantita_di_ordine) AS Quantita_acquistata
FROM Carrello 
JOIN Linea_di_carrello ON Carrello.ID_carrello = Linea_di_carrello.ID_carrello 
JOIN Prodotto ON Linea_di_carrello.ID_prodotto = Prodotto.ID_prodotto 
JOIN Ordine ON Carrello.ID_carrello = Ordine.ID_carrello
GROUP BY Prodotto.Nome;

-- 9 Query per aggiungere un prodotto al catalogo
INSERT INTO Prodotto (ID_prodotto, ID_categoria, Nome, Descrizione, Prezzo, Foto_Prodotto, Quantita_Magazzino) VALUES 
('PRD111', 'ELE', 'Smartphone APPLE', 'Descrizione del Prodotto A', 19.99, 'http://example.com/fotoA.jpg', 50); 

-- 10 Query per eliminare un prodotto dal catalogo
DELETE FROM Linea_di_Carrello WHERE ID_prodotto = 'PRD021';
DELETE FROM Recensione WHERE ID_prodotto = 'PRD021';
DELETE FROM Prodotto WHERE ID_prodotto = 'PRD021';

-- 11 Query per modificare le specifiche di un prodotto (cambiare il nome in 'Portagoli' per il prodotto con ID 'PRD022')
UPDATE Prodotto
SET Nome = 'Portagoli'
WHERE ID_prodotto = 'PRD022';

-- 12 Query per aggiungere un prodotto al carrello
INSERT INTO Linea_di_carrello (ID_carrello, ID_prodotto, Quantita_di_ordine) VALUES 
('CART001', 'PRD005', 1);

-- 13 Query per eliminare un prodotto dal carrello
DELETE FROM Linea_di_carrello WHERE ID_prodotto = 'PRD005';

-- 14 Query per identificare i prodotti più acquistati
CREATE VIEW AcquistoProdotti AS 
SELECT Prodotto.Nome AS Nome, SUM(Linea_di_carrello.Quantita_di_ordine) AS Quantita_acquistata
FROM Carrello 
JOIN Linea_di_carrello ON Carrello.ID_carrello = Linea_di_carrello.ID_carrello 
JOIN Prodotto ON Linea_di_carrello.ID_prodotto = Prodotto.ID_prodotto 
JOIN Ordine ON Carrello.ID_carrello = Ordine.ID_carrello
GROUP BY Prodotto.Nome;
SELECT Nome, Quantita_acquistata
FROM AcquistoProdotti
WHERE Quantita_acquistata = (
    SELECT MAX(Quantita_acquistata) 
    FROM AcquistoProdotti
);

-- 15 Query per identificare i clienti più fedeli
CREATE VIEW Clienti_fedeli AS  
SELECT CONCAT(Utente.Nome, ' ', Utente.Cognome) AS Nominativo, COUNT(Ordine.ID_ordine) AS Numero_ordini
FROM Ordine 
JOIN Utente ON Ordine.ID_utente = Utente.ID_utente
WHERE Utente.ID_Ruolo = '1'
GROUP BY Utente.Nome, Utente.Cognome;
SELECT Nominativo, Numero_ordini
FROM Clienti_fedeli
WHERE Numero_ordini = (
    SELECT MAX(Numero_ordini) 
    FROM Clienti_fedeli
);

-- 16 Query per visualizzare lo storico degli acquisti basato sull'anno di vendita (2024)
SELECT Utente.Nome, Utente.Cognome, Carrello.ID_carrello, Prodotto.nome, Linea_di_carrello.Quantita_di_ordine, Ordine.Data_ordine
FROM Utente 
JOIN Carrello ON Utente.ID_utente = Carrello.ID_utente 
JOIN Ordine ON Carrello.ID_carrello = Ordine.ID_carrello 
JOIN Linea_di_carrello ON Carrello.ID_carrello = Linea_di_carrello.ID_carrello  
JOIN Prodotto ON Linea_di_carrello.ID_prodotto = Prodotto.ID_prodotto
WHERE YEAR(Ordine.Data_ordine) = 2024
GROUP BY Utente.Nome, Utente.Cognome, Carrello.ID_carrello, Prodotto.Nome, Linea_di_carrello.Quantita_di_ordine, Ordine.Data_ordine;

-- 17 Query per effettuare un ordine
INSERT INTO Ordine (ID_ordine, ID_utente, ID_carrello, Data_ordine, Totale_ordine, Modalita_di_pagamento, Tipo_carta, Numero_carta, Data_scadenza, Intestatario, Zona_di_spedizione, Via, Numero_civico, Cap, Comune, Provincia) VALUES
('ORD042', 'USR011', 'CART045', '2024-06-26', 120.30, 'Carta di Credito', 'American Express', '1122334455667788', '2026-12-01', 'Chiara Esposito', 'Z017', 'Via Lecce', '170', '73100', 'Lecce', 'LE');

-- 18 Query per generare una recensione
INSERT INTO Recensione (ID_recensione, ID_ordine, ID_utente, ID_prodotto, Voto, Commento) VALUES
('REV027', 'ORD042', 'USR011', 'PRD014', 3, 'Orologio mediocre');

-- 19 Query per generare una promozione
INSERT INTO Promozione (ID_promozione, ID_categoria, ID_prodotto, Nome, Percentuale_sconto, Data_inizio, Data_fine) VALUES
('PRM011', 'ABB', NULL, 'Sconto abbigliamento estivo', 20, '2024-06-01', '2024-06-30');

-- 20 Query per eliminare una promozione
DELETE FROM Promozione 
WHERE ID_promozione = 'PRM011';

-- 21 Query per modificare le specifiche di una promozione (cambiare la percentuale di sconto al 25% per la promozione 'PRM001')
UPDATE Promozione
SET Percentuale_sconto = 25 
WHERE ID_promozione = 'PRM001'; 

-- 22 Query per registrare un nuovo cliente
INSERT INTO Utente (ID_utente, Nome, Cognome, Data_di_nascita, E_mail, Telefono, Password_utente, ID_Ruolo) VALUES
('USR035', 'Angelo', 'WINDSTORM', '2002-05-15', 'AN.WIND@example.com', '3238492004', 'password123', '1');

-- 23 Query per modificare l'indirizzo email di un cliente
UPDATE UTENTE 
SET E_mail = 'ciao@gmail.com'
WHERE ID_utente = 'USR032' AND ID_Ruolo = '1'; 
