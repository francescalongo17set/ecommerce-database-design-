use progetto_fav_dw;
SELECT c.Nome AS Categoria, SUM(fv.Totale_ordine) AS Vendite_totali
FROM FattoVendite fv
JOIN DimProdotto p ON fv.ID_prodotto = p.ID_prodotto
JOIN DimCategoria c ON p.ID_categoria = c.ID_categoria
GROUP BY c.Nome;

SELECT dp.Nome AS Prodotto, SUM(fv.Quantita_ordine) AS Quantita_venduta
FROM FattoVendite fv
JOIN DimProdotto dp ON fv.ID_prodotto = dp.ID_prodotto
GROUP BY Prodotto
ORDER BY Quantita_venduta DESC;


SELECT dt.Anno, dt.Mese, SUM(fv.Totale_ordine) AS Vendite_totali
FROM FattoVendite fv
JOIN DimTempo dt ON fv.Data_ordine = dt.Data_ordine
GROUP BY dt.Anno, dt.Mese
ORDER BY dt.Anno, dt.Mese;




