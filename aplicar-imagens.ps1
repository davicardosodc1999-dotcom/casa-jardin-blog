# =========================================================
# CASA & JARDÍN - FINAL
# REPOSICIONAR AS 3 IMAGENS INTERNAS
# + CORRIGIR CAMINHOS
# + PATCH MOBILE
# =========================================================

$PastaArtigos = ".\articles"

$artigos = Get-ChildItem $PastaArtigos -Filter "*.html" -File |
    Sort-Object Name

Write-Host ""
Write-Host "Artigos encontrados: $($artigos.Count)"
Write-Host ""

$erros = 0

foreach ($arquivo in $artigos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    # =====================================================
    # CORRIGIR CAMINHOS DOS ARTIGOS
    # =====================================================

    $html = $html.Replace("../../css/", "../css/")
    $html = $html.Replace("../../img/", "../img/")
    $html = $html.Replace("../../pages/", "../pages/")
    $html = $html.Replace("../../js/", "../js/")
    $html = $html.Replace("../../categorias/", "../categorias/")
    $html = $html.Replace("../../index.html", "../index.html")
    $html = $html.Replace("../../articulos.html", "../articulos.html")
    $html = $html.Replace("../../buscar.html", "../buscar.html")

    # =====================================================
    # ENCONTRAR INÍCIO DO ARTIGO PRINCIPAL
    # =====================================================

    $inicioMatch = [regex]::Match(
        $html,
        '(?s)<article\b[^>]*class="[^"]*(article-content-full|articulo)[^"]*"[^>]*>'
    )

    if (!$inicioMatch.Success) {

        Write-Host "ERRO - artigo principal nao encontrado: $($arquivo.Name)"
        $erros++
        continue
    }

    $inicio = $inicioMatch.Index

    # Preferimos terminar antes da sidebar
    $asideIndex = $html.IndexOf(
        '<aside class="article-sidebar"',
        $inicio
    )

    if ($asideIndex -gt $inicio) {

        $fim = $asideIndex
    }
    else {

        $fimArticle = $html.IndexOf(
            '</article>',
            $inicio
        )

        if ($fimArticle -lt 0) {

            Write-Host "ERRO - fechamento do artigo nao encontrado: $($arquivo.Name)"
            $erros++
            continue
        }

        $fim = $fimArticle + 10
    }

    $bloco = $html.Substring(
        $inicio,
        $fim - $inicio
    )

    # =====================================================
    # PEGAR AS 3 IMAGENS INTERNAS DE QUALQUER POSIÇÃO
    # NÃO PEGA article-main-image
    # =====================================================

    $padraoImagem = '(?s)<figure\b[^>]*class="[^"]*article-image[^"]*"[^>]*>.*?</figure>'

    $imagens = [regex]::Matches(
        $bloco,
        $padraoImagem
    )

    if ($imagens.Count -ne 3) {

        Write-Host ""
        Write-Host "ATENCAO: $($arquivo.Name)"
        Write-Host "Imagens internas encontradas: $($imagens.Count)"

        $erros++
        continue
    }

    $figura1 = $imagens[0].Value
    $figura2 = $imagens[1].Value
    $figura3 = $imagens[2].Value

    # =====================================================
    # REMOVER AS 3 DAS POSIÇÕES ANTIGAS
    # =====================================================

    $blocoLimpo = [regex]::Replace(
        $bloco,
        $padraoImagem,
        ""
    )

    # =====================================================
    # LIMITAR ÁREA DE INSERÇÃO
    # Preferimos antes do FAQ
    # =====================================================

    $limite = $blocoLimpo.IndexOf(
        '<section id="faq"'
    )

    if ($limite -lt 0) {

        $limite = $blocoLimpo.IndexOf(
            '<section class="related-articles"'
        )
    }

    if ($limite -lt 0) {

        $limite = $blocoLimpo.Length
    }

    $areaTexto = $blocoLimpo.Substring(
        0,
        $limite
    )

    # =====================================================
    # LOCALIZAR PARÁGRAFOS
    # =====================================================

    $paragrafos = [regex]::Matches(
        $areaTexto,
        '(?s)<p\b[^>]*>.*?</p>'
    )

    if ($paragrafos.Count -lt 6) {

        Write-Host ""
        Write-Host "ATENCAO - poucos paragrafos: $($arquivo.Name)"
        Write-Host "Paragrafos: $($paragrafos.Count)"

        $erros++
        continue
    }

    # =====================================================
    # POSIÇÕES: 25%, 50%, 75%
    # =====================================================

    $p1Index = [Math]::Max(
        1,
        [Math]::Floor($paragrafos.Count * 0.25)
    )

    $p2Index = [Math]::Max(
        2,
        [Math]::Floor($paragrafos.Count * 0.50)
    )

    $p3Index = [Math]::Max(
        3,
        [Math]::Floor($paragrafos.Count * 0.75)
    )

    if ($p3Index -ge $paragrafos.Count) {
        $p3Index = $paragrafos.Count - 1
    }

    if ($p2Index -ge $p3Index) {
        $p2Index = $p3Index - 1
    }

    if ($p1Index -ge $p2Index) {
        $p1Index = $p2Index - 1
    }

    $p1 = $paragrafos[$p1Index]
    $p2 = $paragrafos[$p2Index]
    $p3 = $paragrafos[$p3Index]

    # =====================================================
    # INSERIR DE TRÁS PARA FRENTE
    # =====================================================

    $pos3 = $p3.Index + $p3.Length

    $blocoLimpo = $blocoLimpo.Insert(
        $pos3,
        "`r`n`r`n$figura3`r`n"
    )

    $pos2 = $p2.Index + $p2.Length

    $blocoLimpo = $blocoLimpo.Insert(
        $pos2,
        "`r`n`r`n$figura2`r`n"
    )

    $pos1 = $p1.Index + $p1.Length

    $blocoLimpo = $blocoLimpo.Insert(
        $pos1,
        "`r`n`r`n$figura1`r`n"
    )

    # =====================================================
    # DEVOLVER ARTIGO AO HTML
    # =====================================================

    $antes = $html.Substring(
        0,
        $inicio
    )

    $depois = $html.Substring(
        $fim
    )

    $html = $antes + $blocoLimpo + $depois

    # =====================================================
    # MENU MOBILE NOS ARTIGOS
    # =====================================================

    if (
        ($html -notmatch 'class="menu-toggle"') -and
        ($html -match '<nav class="main-nav">')
    ) {

        $botao = @'

<button
    class="menu-toggle"
    aria-label="Abrir menú"
    aria-expanded="false"
>
    ☰
</button>

'@

        $html = $html.Replace(
            '<nav class="main-nav">',
            $botao + '<nav class="main-nav">'
        )
    }

    # JS do menu

    if ($html -notmatch '\.\./js/script\.js') {

        $html = $html.Replace(
            '</body>',
            '<script src="../js/script.js"></script>' +
            "`r`n</body>"
        )
    }

    Set-Content `
        -Path $arquivo.FullName `
        -Value $html `
        -Encoding UTF8

    Write-Host "OK - $($arquivo.Name)"
}

# =========================================================
# PATCH AUTOMÁTICO DO STYLE.CSS
# =========================================================

$stylePath = ".\css\style.css"

$style = Get-Content `
    $stylePath `
    -Raw `
    -Encoding UTF8

if ($style -notmatch 'PATCH MOBILE FINAL CASA JARDIN') {

$patchStyle = @'

/* ========================================================
   PATCH MOBILE FINAL CASA JARDIN
======================================================== */

.section-heading > a {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    text-decoration: none;
}

@media (max-width: 600px) {

    html,
    body {
        width: 100%;
        max-width: 100%;
        overflow-x: hidden;
    }

    .container {
        width: calc(100% - 32px);
        max-width: 100%;
    }

    .header-inner {
        min-height: 68px;
        gap: 12px;
    }

    .logo {
        font-size: 22px;
        white-space: nowrap;
    }

    .menu-toggle {
        display: block;
        margin-left: auto;
        font-size: 24px;
    }

    .search-button {
        margin-left: 0;
    }

    .main-nav {
        top: 68px;
        width: 100%;
        padding: 15px 18px;
        background: #fff;
    }

    .main-nav a {
        width: 100%;
        padding: 12px 0;
        color: #252525;
        text-decoration: none;
        border-bottom: 1px solid #eee;
    }

    .section-heading {
        flex-direction: column;
        align-items: flex-start;
        gap: 18px;
    }

    .section-heading > a {
        display: inline-flex !important;
        visibility: visible !important;
        opacity: 1 !important;
        padding: 12px 18px;
        background: #222;
        color: #fff !important;
        border-radius: 4px;
    }

    .articles-grid,
    .categories-grid,
    .popular-grid {
        grid-template-columns: 1fr;
    }

    .article-card {
        width: 100%;
    }

    .article-card .article-image {
        height: auto;
    }

    .article-card .article-image img {
        width: 100%;
        height: auto;
        aspect-ratio: 16 / 10;
        object-fit: cover;
    }

    .hero-grid {
        grid-template-columns: 1fr;
    }

    .hero h1 {
        font-size: clamp(36px, 11vw, 46px);
        line-height: 1.04;
    }

    .hero-image,
    .hero-image img {
        height: auto;
        min-height: 0;
    }

    .hero-image img {
        aspect-ratio: 4 / 3;
        object-fit: cover;
    }

    .newsletter-form {
        width: 100%;
        min-width: 0;
    }
}

'@

    Add-Content `
        -Path $stylePath `
        -Value $patchStyle `
        -Encoding UTF8
}

# =========================================================
# PATCH AUTOMÁTICO DO ARTICLE.CSS
# =========================================================

$articleCssPath = ".\css\article.css"

$articleCss = Get-Content `
    $articleCssPath `
    -Raw `
    -Encoding UTF8

if ($articleCss -notmatch 'PATCH ARTICLE MOBILE FINAL') {

$patchArticle = @'

/* ========================================================
   PATCH ARTICLE MOBILE FINAL
======================================================== */

.article-content-full .article-image {
    width: 100%;
    height: auto;
    margin: 38px 0 45px;
    overflow: visible;
    background: transparent;
}

.article-content-full .article-image img {
    display: block;
    width: 100%;
    height: auto;
    max-height: 520px;
    aspect-ratio: 16 / 10;
    object-fit: cover;
    border-radius: 4px;
}

.article-page a {
    color: inherit;
    text-decoration: none;
}

.article-content-full a {
    color: #252525;
}

@media (max-width: 600px) {

    .article-page {
        padding: 25px 0 55px;
        overflow-x: hidden;
    }

    .article-container {
        width: calc(100% - 32px);
        max-width: 100%;
    }

    .breadcrumbs {
        font-size: 12px;
        line-height: 1.5;
    }

    .breadcrumbs a {
        color: #444;
        text-decoration: none;
    }

    .article-header h1 {
        font-size: clamp(32px, 9vw, 42px);
        line-height: 1.08;
        letter-spacing: -1px;
        overflow-wrap: break-word;
    }

    .article-intro {
        font-size: 17px;
        line-height: 1.65;
    }

    .article-meta {
        flex-direction: column;
        gap: 5px;
        font-size: 12px;
    }

    .article-main-image {
        width: 100%;
        margin-bottom: 30px;
    }

    .article-main-image img {
        width: 100%;
        height: auto;
        max-height: none;
        aspect-ratio: 16 / 10;
        object-fit: cover;
    }

    .article-layout {
        display: block;
    }

    .article-content-full {
        width: 100%;
        font-size: 17px;
        line-height: 1.75;
    }

    .article-content-full h2 {
        font-size: 27px;
        line-height: 1.2;
    }

    .article-content-full h3 {
        font-size: 21px;
    }

    .article-content-full .article-image {
        width: 100%;
        height: auto;
        margin: 30px 0 35px;
    }

    .article-content-full .article-image img {
        width: 100%;
        height: auto;
        max-height: none;
        aspect-ratio: 16 / 10;
        object-fit: cover;
    }

    .table-of-contents {
        padding: 20px;
        margin-bottom: 35px;
    }

    .article-sidebar {
        position: static;
        margin-top: 45px;
    }

    .related-grid,
    .related-articles .articles-grid {
        grid-template-columns: 1fr;
    }
}

'@

    Add-Content `
        -Path $articleCssPath `
        -Value $patchArticle `
        -Encoding UTF8
}

# =========================================================
# VALIDAÇÃO FINAL
# =========================================================

Write-Host ""
Write-Host "=========================================="
Write-Host "VALIDACAO FINAL"
Write-Host "=========================================="

$problemas = 0

foreach ($arquivo in $artigos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $qtd = (
        [regex]::Matches(
            $html,
            '<figure\b[^>]*class="[^"]*article-image'
        )
    ).Count

    if ($qtd -ne 3) {

        Write-Host "$($arquivo.Name) -> $qtd imagens internas"

        $problemas++
    }
}

Write-Host ""

if ($problemas -eq 0) {

    Write-Host "=========================================="
    Write-Host "TUDO CONCLUIDO COM SUCESSO"
    Write-Host "=========================================="
    Write-Host ""
    Write-Host "$($artigos.Count) artigos."
    Write-Host "3 imagens internas em cada artigo."
    Write-Host "Imagens distribuidas pelo texto."
    Write-Host "Imagem principal preservada."
    Write-Host "CSS corrigido."
    Write-Host "Mobile corrigido."
    Write-Host ""
}
else {

    Write-Host "$problemas artigos ainda precisam de revisao."
}