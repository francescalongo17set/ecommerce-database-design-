import os
import mysql.connector
from mysql.connector import Error
import matplotlib.pyplot as plt
from prettytable import PrettyTable

def connetti_database():
    try:
        connessione = mysql.connector.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            database=os.getenv('DB_NAME', 'progetto_fav_dw'),
            user=os.getenv('DB_USER', 'root'),
            password=os.getenv('DB_PASSWORD', '')
        )
        if connessione.is_connected():
            print("Connessione al database MySQL avvenuta con successo.")
            return connessione
    except Error as e:
        print("Errore durante la connessione al MySQL:", e)
        return None

def execute_query(conn, query):
    try:
        cursor = conn.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as e:
        print("Errore durante l'esecuzione della query:", e)
        return None

def v_categoria(conn):
    query = """
    SELECT c.Nome AS Categoria, SUM(fv.Totale_ordine) AS Vendite_totali
    FROM FattoVendite fv
    JOIN DimProdotto p ON fv.ID_prodotto = p.ID_prodotto
    JOIN DimCategoria c ON p.ID_categoria = c.ID_categoria
    GROUP BY c.Nome;
    """
    print("\nVendite totali per categoria:")
    result = execute_query(conn, query)
    if result:
        
        print("1. Grafico a torta")
        print("2. Tabella")
        scelta_grafico = input("Scegli un'opzione: ")
        if scelta_grafico=="1":
            # Creazione del grafico a torta
            # Estrai le categorie e le vendite dai dati contenuti in `result`
            categorie = [row[0] for row in result]  # Lista delle categorie (primo elemento di ogni riga)
            vendite = [row[1] for row in result]    # Lista delle vendite (secondo elemento di ogni riga)
            plt.figure(figsize=(8, 6))# Crea una nuova figura di dimensioni 8x6 pollici
            plt.pie(vendite, labels=categorie, autopct='%1.1f%%', startangle=140)
            # Crea un grafico a torta con le vendite, usando le categorie come etichette e formattando le percentuali con una cifra decimale
            plt.axis('equal')# Assicura che il grafico a torta sia disegnato in modo circolare
            plt.title('Vendite totali per categoria')# Aggiungi un titolo al grafico
            plt.show()# Mostra il grafico a torta

        if scelta_grafico=="2":
            # Mostrare il numero esatto di prodotti venduti per ogni categoria
            table = PrettyTable(['Categoria', 'Vendite Totali'])# Crea una nuova tabella PrettyTable con le colonne 'Categoria' e 'Vendite Totali'
            # Aggiungi ogni riga di `result` alla tabella
            for row in result:
                table.add_row(row)
            print(table)# Stampa la tabella


def v_prodotto(conn):
    query = """
    SELECT dp.Nome AS Prodotto, SUM(fv.Quantita_ordine) AS Quantita_venduta
    FROM FattoVendite fv
    JOIN DimProdotto dp ON fv.ID_prodotto = dp.ID_prodotto
    GROUP BY Prodotto
    ORDER BY Quantita_venduta DESC;
    """
    print("\nQuantità venduta per prodotto:")
    result = execute_query(conn, query)
    if result:
        table = PrettyTable(['Prodotto', 'Quantità Venduta'])
        for row in result:
            table.add_row(row)
        print(table)

def v_totale(conn):
    query = """
    SELECT dt.Anno, dt.Mese, SUM(fv.Totale_ordine) AS Vendite_totali
    FROM FattoVendite fv
    JOIN DimTempo dt ON fv.Data_ordine = dt.Data_ordine
    GROUP BY dt.Anno, dt.Mese
    ORDER BY dt.Anno, dt.Mese;
    """
    print("\nVendite totali per anno e mese:")
    result = execute_query(conn, query)
    if result:
        table = PrettyTable(['Anno', 'Mese', 'Vendite Totali'])
        for row in result:
            table.add_row(row)
        print(table)

def main():
    conn = connetti_database()
    if conn:
        while True:
            print("Menu:")
            print("1. Vendite totali per categoria")
            print("2. Quantità venduta per prodotto")
            print("3. Vendite totali per anno e mese")
            print("0. Esci")
            scelta = input("Scegli un'opzione: ")
            
            if scelta == "1":
                v_categoria(conn)
            elif scelta == "2":
                v_prodotto(conn)
            elif scelta == "3":
                v_totale(conn)
            elif scelta == "0":
                if conn.is_connected():
                    conn.close()
                    print("Connessione chiusa.")
                break  # Esci dal ciclo while
            else:
                print("Opzione non valida, riprova.")

if __name__ == "__main__":
    main()
