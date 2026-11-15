import json

with open("logistica_2026.json", encoding="utf-8") as arquivo:
    dados = json.load(arquivo)
    
emissoes = dados["emissoes"]
print(len(emissoes))    

import sqlite3
conexao = sqlite3.connect("logistica_2026.db")
cursor = conexao.cursor()
cursor.execute("SELECT COUNT(*) FROM emissoes")
print(cursor.fetchone()[0])
conexao.close()