from pathlib import Path
import re

ROOT = Path.cwd()
PAGES = ROOT / "pages"

arquivos = [
    "sobre-nosotros.html",
    "contacto.html",
    "politica-de-privacidad.html",
    "politica-de-cookies.html",
    "terminos-de-uso.html",
]

marcadores = [
    r"\bnuestro\b",
    r"\bnuestra\b",
    r"\bnuestros\b",
    r"\bnuestras\b",
    r"\bpuede\b",
    r"\bpueden\b",
    r"\busuario\b",
    r"\bsitio\b",
    r"\bpolítica\b",
    r"\bpágina\b",
    r"\bcorreo\b",
    r"\bcontenido\b",
    r"\bcontenidos\b",
    r"\btérminos\b",
    r"\bprivacidad\b",
    r"\bcontacto\b",
    r"\bpublicidad\b",
    r"\butilizar\b",
    r"\binformación\b",
    r"\bderechos\b",
    r"[¿¡]",
]

regex = re.compile(
    "|".join(marcadores),
    re.IGNORECASE
)

print()
print("=" * 65)
print("BLOCK 02C - LOCATING REMAINING SPANISH")
print("=" * 65)

total = 0

for nome in arquivos:

    arquivo = PAGES / nome

    if not arquivo.exists():
        continue

    linhas = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    ).splitlines()

    encontrados = []

    for numero, linha in enumerate(linhas, start=1):

        if regex.search(linha):

            texto = linha.strip()

            # Ignorar linhas vazias
            if not texto:
                continue

            encontrados.append((numero, texto))

    if encontrados:

        print()
        print("-" * 65)
        print(nome)
        print("-" * 65)

        for numero, texto in encontrados:
            print(f"LINE {numero}: {texto}")
            total += 1

print()
print("=" * 65)
print(f"LINES TO REVIEW: {total}")
print("=" * 65)
print()