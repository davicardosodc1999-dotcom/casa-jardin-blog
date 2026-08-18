from pathlib import Path
import shutil

ROOT = Path.cwd()
PAGES = ROOT / "pages"
BACKUP = ROOT / "backup-bloco-02"

print()
print("=" * 60)
print("BLOCK 02B - INSTITUTIONAL PAGES TO ENGLISH")
print("=" * 60)
print()

# ============================================================
# BACKUP
# ============================================================

BACKUP.mkdir(exist_ok=True)

arquivos = [
    "sobre-nosotros.html",
    "contacto.html",
    "politica-de-privacidad.html",
    "politica-de-cookies.html",
    "terminos-de-uso.html",
]

for nome in arquivos:
    origem = PAGES / nome

    if origem.exists():
        destino = BACKUP / nome

        if not destino.exists():
            shutil.copy2(origem, destino)

print("Backup: OK")
print()

# ============================================================
# SUBSTITUICOES
# Somente textos encontrados no mapeamento do Bloco 02A
# ============================================================

replacements = {

# ------------------------------------------------------------
# ABOUT US
# ------------------------------------------------------------

"Conoce Home & Garden, un portal dedicado a compartir ideas, consejos y contenidos útiles sobre el hogar, la decoración y la jardinería.":
"Discover Home & Garden, a website dedicated to sharing practical ideas, helpful advice and useful content about the home, decorating, plants and gardening.",

"Ideas para disfrutar más de tu hogar":
"Ideas to Help You Enjoy Your Home Even More",

"Nuestro compromiso":
"Our Commitment",

"Contenido y actualización":
"Content and Updates",

"Home & Garden es un espacio dedicado a compartir ideas, consejos y conocimientos relacionados con el hogar, la decoración, las plantas y la jardinería.":
"Home & Garden is a space dedicated to sharing ideas, practical advice and useful knowledge about the home, decorating, plants and gardening.",

"Nuestro objetivo es ofrecer contenidos claros, prácticos y fáciles de aplicar, ayudando a nuestros lectores a mejorar sus espacios y descubrir nuevas formas de disfrutar de ellos.":
"Our goal is to provide clear, practical and easy-to-follow content that helps our readers improve their spaces and discover new ways to enjoy their homes and gardens.",

"Buscamos crear contenidos útiles y cuidadosamente estructurados, priorizando la experiencia del lector, la claridad de la información y la utilidad práctica.":
"We aim to create useful, carefully structured content while prioritizing the reader experience, clear information and practical value.",

"Los artículos pueden ser revisados y actualizados cuando sea necesario para mantener la información relevante y útil para nuestros lectores.":
"Our articles may be reviewed and updated whenever necessary to keep the information relevant, accurate and useful to our readers.",

"Si deseas comunicarte con nuestro equipo, puedes visitar nuestra página de contacto.":
"If you would like to get in touch with our team, please visit our contact page.",

"Inspiración y consejos para crear espacios más bonitos, funcionales y acogedores.":
"Inspiration and practical advice for creating beautiful, functional and welcoming spaces.",


# ------------------------------------------------------------
# CONTACT
# ------------------------------------------------------------

"Ponte en contacto con el equipo de Home & Garden.":
"Get in touch with the Home & Garden team.",

"Estamos aquí para escucharte":
"We're Here to Hear From You",

"¿Tienes una pregunta, sugerencia o quieres comunicarte con nosotros? Puedes utilizar el formulario de esta página.":
"Have a question, suggestion or simply want to get in touch? You can use the form on this page to contact our team.",


# ------------------------------------------------------------
# PRIVACY POLICY
# ------------------------------------------------------------

"Política de Privacidad | Home & Garden":
"Privacy Policy | Home & Garden",

"Consulta la Política de Privacidad de Home & Garden.":
"Read the Home & Garden Privacy Policy and learn how information may be collected, used and protected on this website.",

"Política de Privacidad":
"Privacy Policy",

"Information que podemos recopilar":
"Information We May Collect",

"Uso de la información":
"How We Use Information",

"Servicios de terceros":
"Third-Party Services",

"En Home & Garden respetamos la privacidad de nuestros visitantes y nos comprometemos a tratar la información personal de forma responsable.":
"At Home & Garden, we respect the privacy of our visitors and are committed to handling personal information responsibly.",

"Dependiendo de las funciones utilizadas en el sitio, podemos recopilar información proporcionada voluntariamente por el usuario, como su nombre o dirección de correo electrónico cuando utiliza formularios de contacto o suscripción.":
"Depending on the features used on the website, we may collect information voluntarily provided by visitors, such as a name or email address when using contact or subscription forms.",

"La información recopilada puede utilizarse para responder consultas, mejorar nuestros contenidos y proporcionar los servicios solicitados por los usuarios.":
"Information collected may be used to respond to inquiries, improve our content and provide services requested by our visitors.",

"Este sitio puede utilizar cookies y tecnologías similares para mejorar la experiencia del usuario, analizar el tráfico y permitir determinadas funcionalidades.":
"This website may use cookies and similar technologies to improve the user experience, analyze website traffic and enable certain features.",

"Home & Garden puede utilizar servicios publicitarios de terceros. Estos servicios pueden utilizar cookies u otras tecnologías de acuerdo con sus propias políticas.":
"Home & Garden may use third-party advertising services. These providers may use cookies or similar technologies in accordance with their own policies.",

"Podemos utilizar herramientas de análisis, publicidad, alojamiento u otros servicios externos. Cada proveedor puede aplicar sus propias políticas de privacidad.":
"We may use analytics, advertising, hosting and other third-party services. Each provider may apply its own privacy practices and policies.",

"Para cualquier consulta relacionada con esta política, puedes utilizar nuestra página de contacto.":
"If you have any questions regarding this policy, please contact us through our contact page.",


# ------------------------------------------------------------
# COOKIE POLICY
# ------------------------------------------------------------

"Política de Cookies | Home & Garden":
"Cookie Policy | Home & Garden",

"Consulta cómo Home & Garden utiliza cookies y tecnologías similares.":
"Learn how Home & Garden may use cookies and similar technologies when you visit our website.",

"Política de Cookies":
"Cookie Policy",

"¿Qué son las cookies?":
"What Are Cookies?",

"¿Para qué utilizamos cookies?":
"How We Use Cookies",

"Cookies de terceros":
"Third-Party Cookies",

"Gestión de cookies":
"Managing Cookies",

"Actualizaciones":
"Updates",

"Home & Garden puede utilizar cookies y tecnologías similares para mejorar la navegación y comprender cómo los visitantes utilizan nuestro sitio.":
"Home & Garden may use cookies and similar technologies to improve browsing and better understand how visitors use our website.",

"Las cookies son pequeños archivos que pueden almacenarse en el dispositivo del visitante cuando navega por un sitio web.":
"Cookies are small files that may be stored on a visitor's device while browsing a website.",

"Las cookies pueden utilizarse para recordar determinadas preferencias, analizar el tráfico, mejorar el funcionamiento del sitio y proporcionar contenido o publicidad relevante.":
"Cookies may be used to remember certain preferences, analyze traffic, improve website functionality and provide relevant content or advertising.",

"Algunos servicios utilizados en el sitio pueden establecer sus propias cookies. Esto puede incluir herramientas de análisis y plataformas publicitarias.":
"Some third-party services used on this website may set their own cookies. These may include analytics tools and advertising platforms.",

"El usuario puede administrar o eliminar cookies desde la configuración de su navegador. La desactivación de determinadas cookies puede afectar algunas funciones del sitio.":
"Visitors can manage or delete cookies through their browser settings. Disabling certain cookies may affect some features of the website.",

"Esta política puede actualizarse cuando se incorporen nuevas herramientas o servicios al sitio.":
"This policy may be updated when new tools, technologies or services are introduced on the website.",


# ------------------------------------------------------------
# TERMS OF USE
# ------------------------------------------------------------

"Términos de Uso | Home & Garden":
"Terms of Use | Home & Garden",

"Consulta los Términos de Uso de Home & Garden.":
"Read the Terms of Use that apply when accessing and using Home & Garden.",

"Términos de Uso":
"Terms of Use",

"Uso del contenido":
"Use of Content",

"Responsabilidad del usuario":
"User Responsibilities",

"Propiedad intelectual":
"Intellectual Property",

"Enlaces externos":
"External Links",

"Advertising y afiliados":
"Advertising and Affiliate Links",

"Modificaciones":
"Changes to These Terms",

"El acceso y uso de Home & Garden implica la aceptación de los presentes términos.":
"By accessing and using Home & Garden, you agree to these Terms of Use.",

"Los contenidos publicados en este sitio tienen carácter informativo y están destinados al uso personal de los lectores.":
"Content published on this website is provided for informational purposes and is intended for the personal use of our readers.",

"El usuario se compromete a utilizar el sitio de forma responsable y conforme a la legislación aplicable.":
"Visitors agree to use this website responsibly and in accordance with applicable laws and regulations.",

"Los textos, elementos gráficos, logotipos y demás contenidos pertenecientes al sitio están protegidos por las normas aplicables de propiedad intelectual.":
"Texts, graphics, logos and other original materials belonging to this website may be protected by applicable intellectual property laws.",

"El sitio puede incluir enlaces hacia páginas externas. Home & Garden no controla necesariamente el contenido, disponibilidad o políticas de dichos sitios.":
"This website may contain links to external websites. Home & Garden does not necessarily control the content, availability or policies of those third-party websites.",

"El sitio puede mostrar publicidad o incluir enlaces de afiliados. Cuando corresponda, se informará de forma transparente sobre estas relaciones.":
"This website may display advertising or contain affiliate links. When applicable, these relationships will be disclosed transparently.",

"Estos términos pueden modificarse cuando sea necesario para reflejar cambios en el sitio o en sus servicios.":
"These terms may be updated when necessary to reflect changes to the website, its content or its services.",


# ------------------------------------------------------------
# COMMON
# ------------------------------------------------------------

"Todos los derechos reservados.":
"All rights reserved.",

}

# ============================================================
# PROCESS FILES
# ============================================================

alterados = 0
total_substituicoes = 0

for nome in arquivos:

    arquivo = PAGES / nome

    if not arquivo.exists():
        print(f"NOT FOUND - {nome}")
        continue

    texto = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    )

    original = texto
    contador = 0

    for espanhol, ingles in replacements.items():

        quantidade = texto.count(espanhol)

        if quantidade:
            texto = texto.replace(espanhol, ingles)
            contador += quantidade

    if texto != original:

        arquivo.write_text(
            texto,
            encoding="utf-8"
        )

        alterados += 1
        total_substituicoes += contador

        print(
            f"OK - {nome} -> "
            f"{contador} replacement(s)"
        )

    else:
        print(f"NO CHANGE - {nome}")


# ============================================================
# VALIDATION
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
    "Todos los derechos",
    "¿",
    "¡",
]

problemas = []

for nome in arquivos:

    arquivo = PAGES / nome

    if not arquivo.exists():
        continue

    texto = arquivo.read_text(
        encoding="utf-8",
        errors="replace"
    )

    encontrados = []

    for marcador in spanish_markers:
        if marcador.lower() in texto.lower():
            encontrados.append(marcador)

    if encontrados:
        problemas.append(
            (nome, encontrados)
        )


print()
print("=" * 60)
print("BLOCK 02 RESULT")
print("=" * 60)
print()
print(f"Pages expected:      {len(arquivos)}")
print(f"Pages changed:       {alterados}")
print(f"Replacements made:   {total_substituicoes}")
print(f"Backup:              {BACKUP.name}")
print()

if problemas:

    print("ATTENTION - POSSIBLE SPANISH TEXT REMAINING:")
    print()

    for nome, encontrados in problemas:
        print(
            nome + " -> " +
            ", ".join(encontrados)
        )

else:

    print("Spanish institutional text detected: 0")
    print()
    print("BLOCK 02: APPROVED")

print()
print("=" * 60)