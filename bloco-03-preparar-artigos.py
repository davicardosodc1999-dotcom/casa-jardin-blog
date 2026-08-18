from pathlib import Path
import re
import json
import shutil
import html as html_lib

# ============================================================
# HOME & GARDEN
# BLOCK 03 - PREPARE 100 ARTICLES FOR ENGLISH TRANSLATION
# ============================================================

ROOT = Path.cwd()
ARTICLES = ROOT / "articles"
REFERENCE = ROOT / "novos-artigos"

BACKUP = ROOT / "backup-bloco-03-artigos"
EXPORT = ROOT / "traducao-artigos"

print()
print("=" * 68)
print("BLOCK 03 - PREPARING ARTICLES FOR ENGLISH VERSION")
print("=" * 68)
print()

# ============================================================
# 1. DETERMINE WHICH 100 ARTICLES ARE THE OFFICIAL ONES
# ============================================================

if REFERENCE.exists():
    reference_files = sorted(
        REFERENCE.glob("*.html"),
        key=lambda p: p.name.lower()
    )

    if len(reference_files) == 100:
        official_names = [p.name for p in reference_files]

        print("Reference folder: novos-artigos")
        print("Official articles: 100")
    else:
        print(
            "WARNING: novos-artigos does not contain exactly 100 HTML files."
        )
        print(
            f"Found: {len(reference_files)}"
        )
        official_names = []
else:
    official_names = []

# Fallback
if not official_names:

    candidates = sorted(
        ARTICLES.glob("*.html"),
        key=lambda p: p.name.lower()
    )

    if len(candidates) < 100:
        print("ERROR: fewer than 100 articles found.")
        raise SystemExit(1)

    official_names = [p.name for p in candidates[:100]]

    print("Using first 100 HTML files from articles/")

# ============================================================
# 2. VALIDATE FILES
# ============================================================

article_paths = []

missing = []

for name in official_names:

    path = ARTICLES / name

    if path.exists():
        article_paths.append(path)
    else:
        missing.append(name)

if missing:

    print()
    print("ERROR - official articles missing from articles/:")
    for name in missing:
        print(" -", name)

    raise SystemExit(1)

print(f"Final articles selected: {len(article_paths)}")

# ============================================================
# 3. BACKUP
# ============================================================

BACKUP.mkdir(parents=True, exist_ok=True)

for path in article_paths:

    destination = BACKUP / path.name

    if not destination.exists():
        shutil.copy2(path, destination)

print("Backup: OK")

# ============================================================
# HELPERS
# ============================================================

def clean_text(value):

    if not value:
        return ""

    value = re.sub(
        r"<script\b.*?</script>",
        " ",
        value,
        flags=re.I | re.S
    )

    value = re.sub(
        r"<style\b.*?</style>",
        " ",
        value,
        flags=re.I | re.S
    )

    value = re.sub(
        r"<[^>]+>",
        " ",
        value
    )

    value = html_lib.unescape(value)

    value = re.sub(
        r"\s+",
        " ",
        value
    )

    return value.strip()


def word_count(value):

    return len(
        re.findall(
            r"\b[\wÀ-ÿ'-]+\b",
            value,
            flags=re.UNICODE
        )
    )


def extract_first(pattern, text):

    result = re.search(
        pattern,
        text,
        flags=re.I | re.S
    )

    if result:
        return clean_text(result.group(1))

    return ""


# ============================================================
# 4. EXPORT EACH ARTICLE
# ============================================================

EXPORT.mkdir(parents=True, exist_ok=True)

records = []

under_2000 = []
over_3000 = []
structure_warnings = []

for position, path in enumerate(article_paths, start=1):

    source = path.read_text(
        encoding="utf-8",
        errors="replace"
    )

    title = extract_first(
        r"<h1[^>]*>(.*?)</h1>",
        source
    )

    meta_description = extract_first(
        r'<meta[^>]+name=["\']description["\'][^>]+content=["\'](.*?)["\']',
        source
    )

    if not meta_description:
        meta_description = extract_first(
            r'<meta[^>]+content=["\'](.*?)["\'][^>]+name=["\']description["\']',
            source
        )

    category = extract_first(
        r'<span[^>]+class=["\'][^"\']*article-category[^"\']*["\'][^>]*>(.*?)</span>',
        source
    )

    intro = extract_first(
        r'<p[^>]+class=["\'][^"\']*article-intro[^"\']*["\'][^>]*>(.*?)</p>',
        source
    )

    # --------------------------------------------------------
    # MAIN ARTICLE AREA
    # --------------------------------------------------------

    article_match = re.search(
        r'<article\b[^>]*class=["\'][^"\']*article-content-full[^"\']*["\'][^>]*>(.*?)</article>',
        source,
        flags=re.I | re.S
    )

    if not article_match:

        structure_warnings.append(path.name)
        body_html = ""
    else:
        body_html = article_match.group(1)

    # --------------------------------------------------------
    # EXTRACT TRANSLATABLE ELEMENTS
    # --------------------------------------------------------

    elements = []

    tag_pattern = re.compile(
        r'<(h2|h3|p|li|figcaption)\b([^>]*)>(.*?)</\1>',
        flags=re.I | re.S
    )

    index = 0

    for match in tag_pattern.finditer(body_html):

        tag = match.group(1).lower()
        attributes = match.group(2)
        inner_html = match.group(3)

        text = clean_text(inner_html)

        if not text:
            continue

        # Ignore obvious ad placeholders
        normalized = text.lower().strip()

        if normalized in {
            "espacio publicitario",
            "advertisement",
            "ad"
        }:
            continue

        elements.append({
            "id": index,
            "tag": tag,
            "attributes": attributes,
            "source_text": text,
            "english_text": ""
        })

        index += 1

    visible_text = " ".join(
        item["source_text"]
        for item in elements
    )

    count = word_count(visible_text)

    if count < 2000:
        under_2000.append((path.name, count))

    if count > 3000:
        over_3000.append((path.name, count))

    record = {
        "position": position,
        "filename": path.name,
        "title_es": title,
        "title_en": "",
        "category_es": category,
        "category_en": "",
        "meta_description_es": meta_description,
        "meta_description_en": "",
        "intro_es": intro,
        "intro_en": "",
        "source_word_count": count,
        "target_word_count_min": 2000,
        "target_word_count_max": 3000,
        "elements": elements
    }

    records.append(record)

# ============================================================
# 5. DIVIDE INTO 10 PACKAGES OF 10 ARTICLES
# ============================================================

for package_index in range(10):

    start = package_index * 10
    end = start + 10

    batch = records[start:end]

    output = EXPORT / f"block-03-batch-{package_index + 1:02}.json"

    output.write_text(
        json.dumps(
            batch,
            ensure_ascii=False,
            indent=2
        ),
        encoding="utf-8"
    )

# ============================================================
# 6. CREATE MANIFEST
# ============================================================

manifest = []

for record in records:

    manifest.append({
        "position": record["position"],
        "filename": record["filename"],
        "title": record["title_es"],
        "words": record["source_word_count"]
    })

(ROOT / "traducao-artigos" / "manifest.json").write_text(
    json.dumps(
        manifest,
        ensure_ascii=False,
        indent=2
    ),
    encoding="utf-8"
)

# ============================================================
# 7. REPORT
# ============================================================

print()
print("=" * 68)
print("BLOCK 03 REPORT")
print("=" * 68)
print()

print(f"Articles prepared:       {len(records)}")
print("Translation packages:   10")
print("Articles per package:   10")
print(f"Backup folder:          {BACKUP.name}")
print(f"Export folder:          {EXPORT.name}")
print()

print(
    "Articles below 2000 source words:",
    len(under_2000)
)

for name, count in under_2000[:20]:
    print(f"  {name} -> {count} words")

if len(under_2000) > 20:
    print(
        f"  ... and {len(under_2000) - 20} more"
    )

print()

print(
    "Articles above 3000 source words:",
    len(over_3000)
)

for name, count in over_3000[:20]:
    print(f"  {name} -> {count} words")

print()

print(
    "Articles with structure warning:",
    len(structure_warnings)
)

for name in structure_warnings:
    print(" ", name)

print()
print("=" * 68)

if (
    len(records) == 100
    and len(structure_warnings) == 0
):

    print("BLOCK 03A: PREPARATION APPROVED")

else:

    print("BLOCK 03A: REVIEW REQUIRED")

print("=" * 68)
print()
print("NEXT FILE TO USE:")
print(
    "traducao-artigos/block-03-batch-01.json"
)
print()