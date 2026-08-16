from pathlib import Path

pasta = Path("articles")

substituicoes = {
    '../../index.html': '../index.html',
    '../../pages/': '../pages/',
    '../../css/': '../css/',
    '../../img/': '../img/',
    '../../js/': '../js/'
}

alterados = 0

for arquivo in pasta.glob("*.html"):
    texto = arquivo.read_text(encoding="utf-8")
    original = texto

    for errado, correto in substituicoes.items():
        texto = texto.replace(errado, correto)

    if texto != original:
        arquivo.write_text(texto, encoding="utf-8")
        alterados += 1
        print(f"Corrigido: {arquivo.name}")

print()
print(f"Arquivos corrigidos: {alterados}")
print("Finalizado.")