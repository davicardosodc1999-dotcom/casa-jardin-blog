from pathlib import Path
import shutil
import re

# ============================================================
# CASA & JARDIN -> HOME & GARDEN
# BLOCO 01 - INTERFACE + TIPOGRAFIA
# ============================================================

ROOT = Path.cwd()
BACKUP = ROOT / "backup-bloco-01"

print()
print("=" * 55)
print("BLOCK 01 - ENGLISH INTERFACE")
print("=" * 55)
print()

# ------------------------------------------------------------
# Arquivos que vamos trabalhar
# ------------------------------------------------------------

html_files = []

# Home e páginas principais
for name in ["index.html", "articulos.html", "404.html"]:
    path = ROOT / name
    if path.exists():
        html_files.append(path)

# Categorias e páginas institucionais
for folder_name in ["categorias", "pages"]:
    folder = ROOT / folder_name

    if folder.exists():
        html_files.extend(folder.glob("*.html"))

# NÃO tocar nos artigos neste bloco
articles_folder = ROOT / "articles"

html_files = sorted(set(html_files))

print(f"HTML files found: {len(html_files)}")
print("Article content will NOT be modified.")
print()

# ------------------------------------------------------------
# Criar backup
# ------------------------------------------------------------

if not BACKUP.exists():
    BACKUP.mkdir(parents=True)

for file in html_files:
    relative = file.relative_to(ROOT)
    destination = BACKUP / relative

    destination.parent.mkdir(parents=True, exist_ok=True)

    if not destination.exists():
        shutil.copy2(file, destination)

# Backup do CSS
for css_name in ["style.css", "article.css", "search.css"]:
    css = ROOT / "css" / css_name

    if css.exists():
        destination = BACKUP / "css" / css_name
        destination.parent.mkdir(parents=True, exist_ok=True)

        if not destination.exists():
            shutil.copy2(css, destination)

print("Backup: OK")
print()

# ============================================================
# TRADUÇÕES SEGURAS DA INTERFACE
# ============================================================

replacements = [
    # Marca
    ("Casa & Jardín", "Home & Garden"),
    ("Casa &amp; Jardín", "Home &amp; Garden"),

    # Menu
    ("Inicio", "Home"),
    ("Categorías", "Categories"),
    ("Destacados", "Featured"),
    ("Sobre nosotros", "About Us"),
    ("Contacto", "Contact"),

    # Pesquisa
    ("¿Qué estás buscando?", "What are you looking for?"),
    ("Buscar artículos", "Search articles"),
    ("Buscar", "Search"),
    ("RESULTADOS", "RESULTS"),
    ("Resultados de búsqueda", "Search Results"),

    # Home
    ("CASA · JARDÍN · INSPIRACIÓN", "HOME · GARDEN · INSPIRATION"),
    ("Ideas que transforman", "Ideas that transform"),
    ("tu hogar y tu jardín", "your home and garden"),

    (
        "Consejos prácticos, inspiración y soluciones para crear espacios más bonitos, cómodos y funcionales.",
        "Practical tips, inspiration and solutions for creating more beautiful, comfortable and functional spaces."
    ),

    ("Explorar artículos", "Explore Articles"),
    ("SELECCIÓN EDITORIAL", "EDITOR'S PICKS"),
    ("Artículos destacados", "Featured Articles"),
    ("Ver todos →", "View All →"),
    ("Leer artículo →", "Read Article →"),
    ("Leer articulo →", "Read Article →"),

    # Categorias
    ("EXPLORA", "EXPLORE"),
    ("Encuentra tu inspiración", "Find Your Inspiration"),
    ("JARDINERÍA", "GARDENING"),
    ("PLANTAS", "PLANTS"),
    ("ORGANIZACIÓN", "ORGANIZATION"),
    ("DECORACIÓN", "DECOR"),
    ("LIMPIEZA Y MANTENIMIENTO", "CLEANING & MAINTENANCE"),
    ("Plantas de interior", "Indoor Plants"),
    ("Jardinería", "Gardening"),
    ("Organización", "Organization"),
    ("Limpieza y mantenimiento", "Cleaning & Maintenance"),
    ("DIY y manualidades", "DIY & Crafts"),
    ("DIY & Manualidades", "DIY & Crafts"),

    # Populares
    ("MÁS LEÍDOS", "MOST READ"),
    (
        "Lo que nuestros lectores están descubriendo",
        "What Our Readers Are Discovering"
    ),

    # Newsletter
    ("INSPIRACIÓN EN TU CORREO", "INSPIRATION IN YOUR INBOX"),
    (
        "Ideas para tu hogar,\n                directamente en tu bandeja.",
        "Ideas for your home,\n                delivered straight to your inbox."
    ),
    (
        "Recibe nuevos consejos, ideas y contenidos\n                sobre casa y jardín.",
        "Get new tips, ideas and content\n                about home and garden."
    ),
    ("Tu correo electrónico", "Your email address"),
    ("Suscribirme", "Subscribe"),

    # About
    ("SOBRE CASA & JARDÍN", "ABOUT HOME & GARDEN"),
    (
        "Ideas útiles para disfrutar más de tus espacios.",
        "Useful ideas to help you enjoy your spaces even more."
    ),
    ("Conoce nuestra historia →", "Discover Our Story →"),

    # Footer
    ("Explorar", "Explore"),
    ("Información", "Information"),
    ("Política de privacidad", "Privacy Policy"),
    ("Política de cookies", "Cookie Policy"),
    ("Términos de uso", "Terms of Use"),
    ("Publicidad", "Advertising"),
    ("Afiliados", "Affiliates"),
    (
        "© 2026 Casa & Jardín. Todos los derechos reservados.",
        "© 2026 Home & Garden. All rights reserved."
    ),
]

# ============================================================
# APLICAR NOS HTMLs
# ============================================================

changed_files = 0

for file in html_files:

    try:
        text = file.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        text = file.read_text(
            encoding="utf-8",
            errors="replace"
        )

    original = text

    for old, new in replacements:
        text = text.replace(old, new)

    # lang espanhol -> inglês
    text = re.sub(
        r'<html\s+lang=["\']es["\']',
        '<html lang="en"',
        text,
        flags=re.IGNORECASE
    )

    # Marca simples que pode estar dividida por span
    text = text.replace(
        'Casa <span>&</span> Jardín',
        'Home <span>&</span> Garden'
    )

    text = text.replace(
        'Casa <span>&amp;</span> Jardín',
        'Home <span>&amp;</span> Garden'
    )

    if text != original:
        file.write_text(text, encoding="utf-8")
        changed_files += 1
        print(f"OK - {file.relative_to(ROOT)}")

# ============================================================
# TIPOGRAFIA MAIS FORTE
# ============================================================

style_css = ROOT / "css" / "style.css"

css_block = r"""

/* ==========================================================
   ENGLISH VERSION - STRONG TYPOGRAPHY
   Added automatically by Block 01
========================================================== */

body {
    font-family: Arial, Helvetica, sans-serif;
    font-weight: 500;
}

.logo {
    font-weight: 900;
}

.main-nav a,
.nav-dropdown-menu a,
.submenu a {
    font-weight: 700;
}

.hero h1,
.section-heading h2,
.article-header h1,
.article-content-full h2,
.article-content-full h3,
.article-card h3,
.category-card h3,
.popular-item h3,
.newsletter h2,
.about-grid h2 {
    font-weight: 800;
}

.eyebrow,
.article-category {
    font-weight: 900;
}

.button,
.text-link,
.article-content a,
.related-articles a,
.search-form button,
.newsletter-form button {
    font-weight: 800;
}

/* Preserve readability on mobile */
@media (max-width: 600px) {

    body {
        font-weight: 500;
    }

    .hero h1,
    .section-heading h2,
    .article-header h1 {
        font-weight: 800;
    }
}

"""

css_changed = False

if style_css.exists():

    css = style_css.read_text(
        encoding="utf-8",
        errors="replace"
    )

    marker = "ENGLISH VERSION - STRONG TYPOGRAPHY"

    if marker not in css:

        with style_css.open(
            "a",
            encoding="utf-8"
        ) as f:
            f.write(css_block)

        css_changed = True
        print()
        print("OK - Strong typography added to css/style.css")

    else:
        print()
        print("Typography block already exists.")

else:
    print()
    print("WARNING - css/style.css was not found.")

# ============================================================
# VALIDAÇÃO
# ============================================================

spanish_terms = [
    "Inicio",
    "Categorías",
    "Sobre nosotros",
    "Leer artículo",
    "Ver todos",
    "Suscribirme",
]

remaining = []

for file in html_files:

    text = file.read_text(
        encoding="utf-8",
        errors="replace"
    )

    found = []

    for term in spanish_terms:
        if term.lower() in text.lower():
            found.append(term)

    if found:
        remaining.append(
            (
                str(file.relative_to(ROOT)),
                found
            )
        )

print()
print("=" * 55)
print("BLOCK 01 RESULT")
print("=" * 55)
print()
print(f"HTML files processed: {len(html_files)}")
print(f"HTML files changed:   {changed_files}")
print(f"CSS changed:          {'YES' if css_changed else 'NO'}")
print(f"Articles modified:    0")
print(f"Backup:               {BACKUP.name}")
print()

if remaining:

    print("ATTENTION - Spanish interface terms still found:")
    print()

    for filename, terms in remaining:
        print(
            filename +
            " -> " +
            ", ".join(terms)
        )

else:

    print("Main interface terms: OK")

print()
print("=" * 55)
print("BLOCK 01 FINISHED")
print("=" * 55)
print()