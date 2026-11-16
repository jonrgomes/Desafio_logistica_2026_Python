import json

with open("logistica_2026.json", encoding="utf-8") as arquivo:
    dados = json.load(arquivo)
    
emissoes = dados["emissoes"] # Exemplo para acessar a lista emissões em no dicionário dados.
print(len(emissoes))    

import sqlite3
conexao = sqlite3.connect("logistica_2026.db")
cursor = conexao.cursor()
cursor.execute("SELECT COUNT(*) FROM emissoes")
print(cursor.fetchone()[0])
conexao.close()

print(f"\n=====DESAFIO LOGISTICA - ANALISE DE DADOS=====\n")

print("Rotas:", len(dados["rotas"]))
print("Emissões:", len(dados["emissoes"]))
print("Clientes:", len(dados["clientes"]))
print("Veiculos:", len(dados["veiculos"]))
print("Ocorrencias:", len(dados["ocorrencias"]))
print("Rastreio:", len(dados["rastreio"]))







    