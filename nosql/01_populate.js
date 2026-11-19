db.prodotti.insertMany([
  {
	"_id": "prod_001",
	"nome": "Laptop XYZ",
	"descrizione": "Un laptop potente con 16GB di RAM e 512GB di SSD.",
	"prezzo": 1299.99,
	"categoria": "Elettronica"
  },
  {
	"_id": "prod_002",
	"nome": "Smartphone ABC",
	"descrizione": "Uno smartphone con fotocamera da 48MP e display AMOLED.",
	"prezzo": 699.99,
	"categoria": "Telefonia"
  },
  {
	"_id": "prod_003",
	"nome": "Cuffie Wireless",
	"descrizione": "Cuffie con cancellazione del rumore e lunga durata della batteria.",
	"prezzo": 199.99,
	"categoria": "Accessori"
  }	
])

db.utenti.insertMany([
  {
    "_id": "user_001",
    "nome": "Mario",
    "cognome": "Rossi",
    "email": "mario.rossi@example.com",
    "data_di_nascita": "1985-06-15"
  },
  {
    "_id": "user_002",
    "nome": "Luigi",
    "cognome": "Bianchi",
    "email": "luigi.bianchi@example.com",
    "data_di_nascita": "1990-09-23"
  },
  {
    "_id": "user_003",
    "nome": "Anna",
    "cognome": "Verdi",
    "email": "anna.verdi@example.com",
    "data_di_nascita": "1982-01-30"
  }
])

db.recensioni.insertMany([
  {
    "_id": "rev_001",
    "id_utente": "user_001",
    "id_prodotto": "prod_001",
    "voto": 5,
    "commento": "Ottimo laptop, super veloce e leggero!",
    "data_recensione": "2023-05-12",
    "multimedia": {
      "foto": [
        "http://example.com/review1_1.jpg"
      ],
      "video": [
        "http://example.com/review1_1.mp4"
      ]
    }
  },
  {
    "_id": "rev_002",
    "id_utente": "user_002",
    "id_prodotto": "prod_002",
    "voto": 4,
    "commento": "Smartphone con ottime prestazioni, ma la batteria potrebbe durare di più.",
    "data_recensione": "2023-06-15",
    "multimedia": {
      "foto": [
        "http://example.com/review2_1.jpg"
      ],
      "video": []
    }
  },
  {
    "_id": "rev_003",
    "id_utente": "user_003",
    "id_prodotto": "prod_003",
    "voto": 3,
    "commento": "Buona qualità audio, ma un po' scomode da indossare per lungo tempo.",
    "data_recensione": "2023-07-20",
    "multimedia": {
      "foto": [],
      "video": [
        "http://example.com/review3_1.mp4"
      ]
    }
  }
])
