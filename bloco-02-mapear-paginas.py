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

print()
print("=" * 60)
print("BLOCK 02A - INSTITUTIONAL PAGES MAPPING")
print("=" * 60)
print()

for nome in arquivos:

    arquivo = PAGES / nome

    print()
    print("=" * 60)
    print(nome)
    print("=" * 60)

    if not arquivo.exists():
        print("NOT FOUND")
        continue

    html = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    )

    # Title
    title = re.search(
        r"<title[^>]*>(.*?)</title>",
        html,
        re.I | re.S
    )

    if title:
        texto = re.sub(r"\s+", " ", title.group(1)).strip()
        print(f"TITLE: {texto}")

    # Meta description
    meta = re.search(
        r'<meta[^>]+name=["\']description["\'][^>]+content=["\']([^"\']*)',
        html,
        re.I | re.S
    )

    if not meta:
        meta = re.search(
            r'<meta[^>]+content=["\']([^"\']*)["\'][^>]+name=["\']description["\']',
            html,
            re.I | re.S
        )

    if meta:
        print(f"DESCRIPTION: {meta.group(1).strip()}")

    # Headings
    headings = re.findall(
        r"<(h1|h2|h3)[^>]*>(.*?)</\1>",
        html,
        re.I | re.S
    )

    print()
    print("HEADINGS:")

    for tag, conteudo in headings:

        texto = re.sub(
            r"<[^>]+>",
            "",
            conteudo
        )

        texto = re.sub(
            r"\s+",
            " ",
            texto
        ).strip()

        if texto:
            print(f"{tag.upper()}: {texto}")

    # Paragraphs
    paragraphs = re.findall(
        r"<p[^>]*>(.*?)</p>",
        html,
        re.I | re.S
    )

    print()
    print("PARAGRAPHS:")

    contador = 0

    for conteudo in paragraphs:

        texto = re.sub(
            r"<[^>]+>",
            "",
            conteudo
        )

        texto = (
            texto
            .replace("&nbsp;", " ")
            .replace("&amp;", "&")
        )

        texto = re.sub(
            r"\s+",
            " ",
            texto
        ).strip()

        if texto:
            contador += 1
            print(f"P{contador}: {texto}")

    print()
    print(f"Paragraphs found: {contador}")

print()
print("=" * 60)
print("BLOCK 02A FINISHED")
print("=" * 60)
print()