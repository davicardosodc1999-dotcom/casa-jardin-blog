from pathlib import Path

ROOT = Path.cwd()

arquivos = [
    ROOT / "404.html",
    ROOT / "index.html",
    ROOT / "pages" / "sobre-nosotros.html",
]

substituicoes = {
    "Inicio": "Home",
    "INICIO": "HOME",
    "Categorías": "Categories",
    "CATEGORÍAS": "CATEGORIES",
    "Sobre nosotros": "About Us",
    "Sobre Nosotros": "About Us",
    "SOBRE NOSOTROS": "ABOUT US",
}

print()
print("=" * 55)
print("BLOCK 01B - FINAL INTERFACE CLEANUP")
print("=" * 55)
print()

alterados = 0

for arquivo in arquivos:

    if not arquivo.exists():
        print(f"NOT FOUND - {arquivo.relative_to(ROOT)}")
        continue

    texto = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    )

    original = texto

    for antigo, novo in substituicoes.items():
        texto = texto.replace(antigo, novo)

    if texto != original:
        arquivo.write_text(texto, encoding="utf-8")
        alterados += 1
        print(f"OK - {arquivo.relative_to(ROOT)}")
    else:
        print(f"NO CHANGE - {arquivo.relative_to(ROOT)}")


# ============================================================
# VALIDACAO
# ============================================================

termos = [
    "Inicio",
    "Categorías",
    "Sobre nosotros",
]

restantes = []

for arquivo in arquivos:

    if not arquivo.exists():
        continue

    texto = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    )

    encontrados = []

    for termo in termos:
        if termo.lower() in texto.lower():
            encontrados.append(termo)

    if encontrados:
        restantes.append(
            (
                str(arquivo.relative_to(ROOT)),
                encontrados
            )
        )

print()
print("=" * 55)
print("RESULT")
print("=" * 55)
print()
print(f"Files changed: {alterados}")

if not restantes:
    print("Remaining Spanish interface terms: 0")
    print()
    print("BLOCK 01: APPROVED")
else:
    print()
    print("Still found:")
    for arquivo, termos_encontrados in restantes:
        print(
            f"{arquivo} -> {', '.join(termos_encontrados)}"
        )

print()