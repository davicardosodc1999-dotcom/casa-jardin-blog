from pathlib import Path

ROOT = Path.cwd()
PAGES = ROOT / "pages"

print()
print("=" * 65)
print("BLOCK 02D - FINAL INSTITUTIONAL CLEANUP")
print("=" * 65)
print()

files = {
    "sobre-nosotros.html": [
        ("Nuestro objetivo es ofrecer contenidos claros,", "Our goal is to provide clear,"),
        ("prácticos y fáciles de aplicar, ayudando a nuestros", "practical and easy-to-follow content that helps our"),
        ("Buscamos crear contenidos útiles y cuidadosamente", "We aim to create useful and carefully"),
        ("la claridad de la información y la utilidad práctica.", "clear information and practical value."),
        ("Los artículos pueden ser revisados y actualizados", "Articles may be reviewed and updated"),
        ("cuando sea necesario para mantener la información", "whenever necessary to keep the information"),
        ("relevante y útil para nuestros lectores.", "relevant and useful to our readers."),
        ("Si deseas comunicarte con nuestro equipo, puedes", "If you would like to contact our team, you can"),
        ("visitar nuestra página de contacto.", "visit our contact page."),
    ],

    "contacto.html": [
        ("CONTACTO", "CONTACT"),
        ("¿Tienes una pregunta, sugerencia o quieres", "Do you have a question, suggestion or would you like"),
        ("comunicarte con nosotros? Puedes utilizar", "to get in touch with us? You can use"),
        ("el formulario de esta página.", "the form on this page."),
        ("Correo electrónico", "Email Address"),
    ],

    "politica-de-privacidad.html": [
        ("INFORMACIÓN LEGAL", "LEGAL INFORMATION"),
        ("En Home & Garden respetamos la privacidad de nuestros", "At Home & Garden, we respect the privacy of our"),
        ("visitantes y nos comprometemos a tratar la información", "visitors and are committed to handling information"),
        ("Dependiendo de las funciones utilizadas en el sitio,", "Depending on the features used on the website,"),
        ("podemos recopilar información proporcionada voluntariamente", "we may collect information voluntarily provided"),
        ("por el usuario, como su nombre o dirección de correo", "by visitors, such as their name or email"),
        ("electrónico cuando utiliza formularios de contacto", "address when using contact forms"),
        ("La información recopilada puede utilizarse para responder", "The information collected may be used to respond"),
        ("consultas, mejorar nuestros contenidos y proporcionar", "to inquiries, improve our content and provide"),
        ("Este sitio puede utilizar cookies y tecnologías similares", "This website may use cookies and similar technologies"),
        ("para mejorar la experiencia del usuario, analizar el tráfico", "to improve the user experience, analyze traffic"),
        ("Home & Garden puede utilizar servicios publicitarios de", "Home & Garden may use advertising services from"),
        ("terceros. Estos servicios pueden utilizar cookies u otras", "third parties. These services may use cookies or other"),
        ("Podemos utilizar herramientas de análisis, publicidad,", "We may use analytics, advertising,"),
        ("puede aplicar sus propias políticas de privacidad.", "may apply its own privacy policies."),
        ("Para cualquier consulta relacionada con esta política,", "For any questions related to this policy,"),
        ("puedes utilizar nuestra página de contacto.", "you can use our contact page."),
    ],

    "politica-de-cookies.html": [
        ("INFORMACIÓN LEGAL", "LEGAL INFORMATION"),
        ("Home & Garden puede utilizar cookies y tecnologías", "Home & Garden may use cookies and technologies"),
        ("cómo los visitantes utilizan nuestro sitio.", "how visitors use our website."),
        ("Las cookies son pequeños archivos que pueden almacenarse", "Cookies are small files that may be stored"),
        ("en el dispositivo del visitante cuando navega por un sitio web.", "on a visitor's device when browsing a website."),
        ("Las cookies pueden utilizarse para recordar determinadas", "Cookies may be used to remember certain"),
        ("del sitio y proporcionar contenido o publicidad relevante.", "website functions and provide relevant content or advertising."),
        ("Algunos servicios utilizados en el sitio pueden establecer", "Some services used on the website may set"),
        ("sus propias cookies. Esto puede incluir herramientas de", "their own cookies. This may include"),
        ("El usuario puede administrar o eliminar cookies desde", "Visitors can manage or delete cookies from"),
        ("determinadas cookies puede afectar algunas funciones", "certain cookies may affect some features"),
        ("del sitio.", "of the website."),
        ("Esta política puede actualizarse cuando se incorporen", "This policy may be updated when new"),
        ("nuevas herramientas o servicios al sitio.", "tools or services are added to the website."),
    ],

    "terminos-de-uso.html": [
        ("INFORMACIÓN LEGAL", "LEGAL INFORMATION"),
        ("de los presentes términos.", "of these terms."),
        ("Los contenidos publicados en este sitio tienen carácter", "The content published on this website is"),
        ("El usuario se compromete a utilizar el sitio de forma", "Visitors agree to use the website in a"),
        ("Los textos, elementos gráficos, logotipos y demás contenidos", "Texts, graphic elements, logos and other content"),
        ("pertenecientes al sitio están protegidos por las normas", "belonging to the website are protected by applicable"),
        ("El sitio puede incluir enlaces hacia páginas externas.", "The website may include links to external pages."),
        ("Home & Garden no controla necesariamente el contenido,", "Home & Garden does not necessarily control the content,"),
        ("El sitio puede mostrar publicidad o incluir enlaces de", "The website may display advertising or include"),
        ("Estos términos pueden modificarse cuando sea necesario", "These terms may be modified when necessary"),
        ("para reflejar cambios en el sitio o en sus servicios.", "to reflect changes to the website or its services."),
    ],
}

changed = 0
total_replacements = 0

for filename, replacements in files.items():
    path = PAGES / filename

    if not path.exists():
        print(f"NOT FOUND - {filename}")
        continue

    text = path.read_text(
        encoding="utf-8",
        errors="replace"
    )

    original = text
    count = 0

    for old, new in replacements:
        occurrences = text.count(old)

        if occurrences:
            text = text.replace(old, new)
            count += occurrences

    if text != original:
        path.write_text(
            text,
            encoding="utf-8"
        )

        changed += 1
        total_replacements += count

        print(f"OK - {filename} -> {count} replacement(s)")
    else:
        print(f"NO CHANGE - {filename}")


# ============================================================
# FINAL VALIDATION
# ============================================================

spanish_markers = [
    "Nuestro ",
    "nuestro ",
    "Nuestros ",
    "nuestros ",
    "puede utilizar",
    "pueden utilizar",
    "puede incluir",
    "puede mostrar",
    "puede actualizar",
    "pueden ser",
    "El usuario",
    "Los contenidos",
    "El sitio",
    "Esta política",
    "estos términos",
    "dirección de correo",
    "página de contacto",
    "Correo electrónico",
    "INFORMACIÓN LEGAL",
    "CONTACTO",
    "¿",
    "¡",
]

remaining = []

for filename in files:

    path = PAGES / filename

    if not path.exists():
        continue

    text = path.read_text(
        encoding="utf-8",
        errors="replace"
    )

    found = []

    for marker in spanish_markers:
        if marker.lower() in text.lower():
            found.append(marker)

    if found:
        remaining.append(
            (filename, found)
        )

print()
print("=" * 65)
print("BLOCK 02 FINAL RESULT")
print("=" * 65)
print()
print(f"Pages changed:       {changed}")
print(f"Replacements made:   {total_replacements}")
print()

if remaining:
    print("ATTENTION - TEXT STILL TO REVIEW:")
    print()

    for filename, markers in remaining:
        print(
            filename +
            " -> " +
            ", ".join(markers)
        )
else:
    print("Remaining Spanish institutional markers: 0")
    print()
    print("BLOCK 02: APPROVED")

print()
print("=" * 65)
print()