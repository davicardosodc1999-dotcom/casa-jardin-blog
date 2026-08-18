from pathlib import Path
import json, re, shutil, html

ROOT = Path.cwd()
ARTICLES = ROOT / "articles"
TRANSLATION = ROOT / "traducao-artigos" / "block-03-articles-01-02-english.json"
BACKUP = ROOT / "backup-bloco-03-artigos"

if not TRANSLATION.exists():
    print("ERROR: translation file not found:")
    print(TRANSLATION)
    raise SystemExit(1)

data = json.loads(TRANSLATION.read_text(encoding="utf-8"))

def wc(s):
    return len(re.findall(r"\b[\w'-]+\b", s or "", flags=re.UNICODE))

print("="*68)
print("BLOCK 03B - APPLY ARTICLES 01-02")
print("="*68)

for article in data:
    filename = article["filename"]
    path = ARTICLES / filename
    if not path.exists():
        print("ERROR - missing:", filename)
        raise SystemExit(1)

    # Validate all fields before touching HTML.
    required = ["title_en", "category_en", "meta_description_en", "intro_en"]
    blanks = [k for k in required if not str(article.get(k, "")).strip()]
    blanks += [f'element {e["id"]}' for e in article["elements"] if not str(e.get("english_text","")).strip()]
    words = sum(wc(e.get("english_text","")) for e in article["elements"])
    if blanks:
        print(f"ERROR - {filename}: blank translations -> {', '.join(blanks[:10])}")
        raise SystemExit(1)
    if not (2000 <= words <= 3000):
        print(f"ERROR - {filename}: {words} words (required 2000-3000)")
        raise SystemExit(1)

print("Validation: OK. No HTML changed yet.")

for article in data:
    filename = article["filename"]
    path = ARTICLES / filename
    text = path.read_text(encoding="utf-8", errors="replace")

    # Extra safety backup.
    BACKUP.mkdir(parents=True, exist_ok=True)
    b = BACKUP / filename
    if not b.exists():
        shutil.copy2(path, b)

    # Metadata/header text.
    replacements = [
        (article["title_es"], article["title_en"]),
        (article["category_es"], article["category_en"]),
        (article["meta_description_es"], article["meta_description_en"]),
        (article["intro_es"], article["intro_en"]),
    ]
    for old, new in replacements:
        if old:
            text = text.replace(old, new)

    # Translate only text inside the extracted structural elements.
    # This preserves tags, classes, links, ad containers and image markup.
    for e in article["elements"]:
        old = e["source_text"]
        new = e["english_text"]
        if old in text:
            text = text.replace(old, new, 1)
        else:
            # tolerate whitespace/newline formatting inside a tag
            parts = [re.escape(x) for x in old.split()]
            pat = r"\s+".join(parts)
            text, n = re.subn(pat, lambda m: new, text, count=1, flags=re.S)
            if n == 0:
                print(f"ERROR - text not found in {filename}, element {e['id']}")
                raise SystemExit(1)

    text = re.sub(r'<html\s+lang=["\']es["\']', '<html lang="en"', text, flags=re.I)
    text = text.replace("Casa & Jardín", "Home & Garden")
    text = text.replace("Casa &amp; Jardín", "Home &amp; Garden")

    path.write_text(text, encoding="utf-8")
    words = sum(wc(e["english_text"]) for e in article["elements"])
    print(f"OK - {filename} -> {words} English words")

print()
print("ARTICLES 01-02 APPLIED SUCCESSFULLY")
print("Original filenames preserved.")
print("Links/images/ad markup preserved.")
