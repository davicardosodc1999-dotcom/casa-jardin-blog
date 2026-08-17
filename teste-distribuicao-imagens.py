from pathlib import Path

PASTA_ARTIGOS = Path("articles")
PASTA_IMAGENS = Path("img/novas-imagens")

extensoes = {".jpg", ".jpeg", ".png", ".webp"}

artigos = sorted(
    p for p in PASTA_ARTIGOS.glob("*.html")
    if p.is_file()
)

imagens = sorted(
    p for p in PASTA_IMAGENS.iterdir()
    if p.is_file() and p.suffix.lower() in extensoes
)

print(f"Artigos encontrados: {len(artigos)}")
print(f"Imagens encontradas: {len(imagens)}")
print()

if len(artigos) != 100:
    print("ATENÇÃO: não foram encontrados exatamente 100 artigos.")
    raise SystemExit

if len(imagens) != 178:
    print("ATENÇÃO: não foram encontradas exatamente 178 imagens.")
    raise SystemExit

# Precisamos de 300 usos:
# 100 artigos x 3 imagens.
# As 178 imagens serão reutilizadas de forma espalhada.
for i, artigo in enumerate(artigos):
    img1 = imagens[i % len(imagens)]
    img2 = imagens[(i + 59) % len(imagens)]
    img3 = imagens[(i + 119) % len(imagens)]

    print(f"ARTIGO {i + 1:03d}: {artigo.name}")
    print(f"  Principal : {img1.name}")
    print(f"  Interna 1 : {img2.name}")
    print(f"  Interna 2 : {img3.name}")
    print("-" * 70)

print()
print("TESTE FINALIZADO.")
print("Nenhum HTML foi alterado.")