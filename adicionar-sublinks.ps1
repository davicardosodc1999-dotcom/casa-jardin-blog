# ============================================================
# CASA & JARDIN
# INSTALAR SUBLINKS NO MENU
# VERSAO ROBUSTA
# ============================================================

Write-Host ""
Write-Host "=========================================="
Write-Host "INSTALANDO SUBLINKS"
Write-Host "=========================================="
Write-Host ""

$raiz = (Get-Location).Path.TrimEnd("\")

# ------------------------------------------------------------
# HTMLs REAIS DO SITE
# ------------------------------------------------------------

$arquivos = @()

$arquivos += Get-ChildItem "." -Filter "*.html" -File
$arquivos += Get-ChildItem ".\articles" -Filter "*.html" -File
$arquivos += Get-ChildItem ".\categorias" -Filter "*.html" -File
$arquivos += Get-ChildItem ".\pages" -Filter "*.html" -File

$arquivos = $arquivos |
    Sort-Object FullName -Unique

Write-Host "HTMLs encontrados: $($arquivos.Count)"
Write-Host ""

# ------------------------------------------------------------
# PREFIXO
# ------------------------------------------------------------

function Get-Prefixo($arquivo) {

    if ($arquivo.DirectoryName.TrimEnd("\") -eq $raiz) {
        return ""
    }

    return "../"
}

# ------------------------------------------------------------
# PROCESSAR
# ------------------------------------------------------------

$alterados = 0
$jaTinham = 0
$semMenu = 0
$semCategorias = 0

foreach ($arquivo in $arquivos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($html)) {
        continue
    }

    # já possui submenu
    if ($html -match 'class=["''][^"'']*nav-dropdown') {

        $jaTinham++
        continue
    }

    # localizar main-nav
    $navMatch = [regex]::Match(
        $html,
        '(?is)<nav\b[^>]*class=["''][^"'']*main-nav[^"'']*["''][^>]*>.*?</nav>'
    )

    if (!$navMatch.Success) {

        $semMenu++
        continue
    }

    $navOriginal = $navMatch.Value

    # localizar link Categorias dentro do nav
    # aceita Categorias, Categorías e texto corrompido
    $categoriaMatch = [regex]::Match(
        $navOriginal,
        '(?is)<a\b[^>]*>\s*Categor.*?</a>'
    )

    if (!$categoriaMatch.Success) {

        $semCategorias++
        continue
    }

    $prefixo = Get-Prefixo $arquivo

    # Usamos entidades HTML para evitar problemas de codificacao
    $submenu = @"

<div class="nav-dropdown">

    <a
        href="${prefixo}index.html#categorias"
        class="nav-dropdown-trigger"
        aria-haspopup="true"
        aria-expanded="false"
    >
        Categor&iacute;as
        <span class="nav-dropdown-arrow" aria-hidden="true">&#9662;</span>
    </a>

    <div class="nav-dropdown-menu">

        <a href="${prefixo}categorias/jardineria.html">
            Jardiner&iacute;a
        </a>

        <a href="${prefixo}categorias/home-decor.html">
            Home Decor
        </a>

        <a href="${prefixo}categorias/plantas-de-interior.html">
            Plantas de interior
        </a>

        <a href="${prefixo}categorias/bricolaje-y-manualidades.html">
            DIY &amp; Manualidades
        </a>

        <a href="${prefixo}categorias/organizacion-del-hogar.html">
            Organizaci&oacute;n
        </a>

        <a href="${prefixo}categorias/limpieza-y-mantenimiento.html">
            Limpieza y mantenimiento
        </a>

        <a href="${prefixo}categorias/vida-al-aire-libre.html">
            Vida al aire libre
        </a>

        <a
            href="${prefixo}articulos.html"
            class="nav-dropdown-all"
        >
            Todos los art&iacute;culos
        </a>

    </div>

</div>

"@

    # substituir somente aquele link
    $navNovo = $navOriginal.Substring(
        0,
        $categoriaMatch.Index
    ) +
    $submenu +
    $navOriginal.Substring(
        $categoriaMatch.Index + $categoriaMatch.Length
    )

    # devolver nav ao HTML
    $htmlNovo = $html.Substring(
        0,
        $navMatch.Index
    ) +
    $navNovo +
    $html.Substring(
        $navMatch.Index + $navMatch.Length
    )

    Set-Content `
        -Path $arquivo.FullName `
        -Value $htmlNovo `
        -Encoding UTF8

    Write-Host "OK - $($arquivo.FullName)"

    $alterados++
}

# ------------------------------------------------------------
# GARANTIR QUE CSS EXISTE
# ------------------------------------------------------------

$cssPath = ".\css\style.css"

$css = Get-Content `
    $cssPath `
    -Raw `
    -Encoding UTF8

if ($css -notmatch 'SUBLINKS CASA JARDIN') {

    Write-Host ""
    Write-Host "ATENCAO: CSS dos sublinks nao foi encontrado."
    Write-Host "O script anterior deveria ter instalado."
}
else {

    Write-Host ""
    Write-Host "CSS dos sublinks: OK"
}

# ------------------------------------------------------------
# GARANTIR JS
# ------------------------------------------------------------

$jsPath = ".\js\script.js"

$js = Get-Content `
    $jsPath `
    -Raw `
    -Encoding UTF8

if ($js -notmatch 'SUBLINKS MOBILE CASA JARDIN') {

    Write-Host "ATENCAO: JavaScript mobile nao encontrado."
}
else {

    Write-Host "JavaScript mobile: OK"
}

# ------------------------------------------------------------
# VALIDACAO REAL
# ------------------------------------------------------------

Write-Host ""
Write-Host "=========================================="
Write-Host "VALIDACAO FINAL"
Write-Host "=========================================="

$comDropdown = 0

foreach ($arquivo in $arquivos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    if ($html -match 'class=["''][^"'']*nav-dropdown') {
        $comDropdown++
    }
}

Write-Host ""
Write-Host "HTMLs analisados: $($arquivos.Count)"
Write-Host "Paginas alteradas: $alterados"
Write-Host "Paginas que ja tinham submenu: $jaTinham"
Write-Host "Paginas sem main-nav: $semMenu"
Write-Host "Menus sem Categorias: $semCategorias"
Write-Host ""
Write-Host "PAGINAS COM SUBLINKS: $comDropdown"
Write-Host ""

if ($comDropdown -gt 0) {

    Write-Host "=========================================="
    Write-Host "SUBLINKS INSTALADOS COM SUCESSO."
    Write-Host "=========================================="

}
else {

    Write-Host "ERRO: nenhum submenu foi instalado."
}