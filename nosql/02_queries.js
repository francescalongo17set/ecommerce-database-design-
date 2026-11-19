db.prodotti.find({
    prezzo: { $gte: 500.00, $lte: 750.00 }
})

db.utenti.aggregate([
  {
    "$lookup": {
      "from": "recensioni",
      "localField": "_id",
      "foreignField": "id_utente",
      "as": "recensioni"
    }
  },
  {
    "$match": {
      "recensioni": { "$elemMatch": { "voto": { "$gt": 3 } } }
    }
  },
  {
    "$project": {
      "_id": 1,
      "nome": 1,
      "cognome": 1,
      "email": 1,
      "data_di_nascita": 1
    }
  }
])

db.prodotti.aggregate([
  {
    "$lookup": {
      "from": "recensioni",
      "localField": "_id",
      "foreignField": "id_prodotto",
      "as": "recensioni"
    }
  },
  {
    "$match": {
      "recensioni.commento": { "$regex": "ottimo", "$options": "i" }
    }
  },
  {
    "$project": {
      "nome": 1
    }
  }
])

db.prodotti.aggregate([
  {
    "$lookup": {
      "from": "recensioni",
      "localField": "_id",
      "foreignField": "id_prodotto",
      "as": "recensioni"
    }
  },
  {
    "$unwind": "$recensioni"
  },
  {
    "$group": {
      "_id": "$_id",
      "nome_prodotto": { "$first": "$nome" },
      "media_voti": { "$avg": "$recensioni.voto" }
    }
  },
  {
    "$project": {
      "_id": 0,
      "nome_prodotto": 1,
      "media_voti": 1
    }
  }
])
