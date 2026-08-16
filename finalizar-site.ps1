# ============================================================
# CASA & JARDIN - FINALIZACAO DO SITE
# Corrige a referencia contact.css sem mexer nos artigos
# ============================================================

$contato = ".\pages\contacto.html"
$cssContato = ".\css\contact.css"
$cssPrincipal = ".\css\style.css"

Write-Host ""
Write-Host "=========================================="
Write-Host "FINALIZANDO CASA & JARDIN"
Write-Host "=========================================="
Write-Host ""

# ------------------------------------------------------------
# 1. VERIFICAR PAGINA DE CONTATO
# ------------------------------------------------------------

if (!(Test-Path $contato)) {

    Write-Host "ERRO: pages\contacto.html nao encontrado."
    exit
}

$html = Get-Content $contato -Raw -Encoding UTF8

# ------------------------------------------------------------
# 2. CORRIGIR CONTACT.CSS AUSENTE
# ------------------------------------------------------------

if (!(Test-Path $cssContato)) {

    Write-Host "contact.css nao existe."
    Write-Host "Removendo somente essa referencia da pagina de contato..."

    # Remove somente a tag link que chama contact.css
    $html = [regex]::Replace(
        $html,
        '(?is)<link\b[^>]*href\s*=\s*["'']\.\./css/contact\.css["''][^>]*>',
        ''
    )

    Set-Content `
        -Path $contato `
        -Value $html `
        -Encoding UTF8

    Write-Host "OK - referencia contact.css removida."
}
else {

    Write-Host "OK - contact.css existe. Nenhuma alteracao necessaria."
}

# ------------------------------------------------------------
# 3. GARANTIR STYLE.CSS NA PAGINA DE CONTATO
# ------------------------------------------------------------

$html = Get-Content $contato -Raw -Encoding UTF8

if ($html -notmatch 'href\s*=\s*["'']\.\./css/style\.css["'']') {

    if (Test-Path $cssPrincipal) {

        $novoLink = @'

    <link rel="stylesheet" href="../css/style.css">
'@

        $html = $html -replace '(?i)</head>', "$novoLink`r`n</head>"

        Set-Content `
            -Path $contato `
            -Value $html `
            -Encoding UTF8

        Write-Host "OK - style.css adicionado ao contato."
    }
}
else {

    Write-Host "OK - contato ja utiliza style.css."
}

# ------------------------------------------------------------
# 4. VERIFICAR HREF="#" NOS ARTIGOS
# ------------------------------------------------------------

$artigos = Get-ChildItem ".\articles" -Filter "*.html" -File

$hrefVazios = 0

foreach ($arquivo in $artigos) {

    $conteudo = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $hrefVazios += (
        [regex]::Matches(
            $conteudo,
            'href\s*=\s*["'']#["'']',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
    ).Count
}

# ------------------------------------------------------------
# 5. VERIFICAR LINKS HTML QUEBRADOS NOS ARTIGOS
# ------------------------------------------------------------

$linksQuebrados = 0

foreach ($arquivo in $artigos) {

    $conteudo = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $links = [regex]::Matches(
        $conteudo,
        'href\s*=\s*["'']([^"'']+\.html(?:#[^"'']*)?)["'']'
    )

    foreach ($link in $links) {

        $href = $link.Groups[1].Value

        if ($href -match '^https?://') {
            continue
        }

        $hrefLimpo = $href.Split("#")[0]

        if ([string]::IsNullOrWhiteSpace($hrefLimpo)) {
            continue
        }

        $hrefLimpo = $hrefLimpo.Replace("/", "\")

        $destino = Join-Path `
            $arquivo.DirectoryName `
            $hrefLimpo

        try {

            $destino = [System.IO.Path]::GetFullPath($destino)

        }
        catch {

            $linksQuebrados++
            continue
        }

        if (!(Test-Path $destino)) {

            Write-Host ""
            Write-Host "LINK QUEBRADO:"
            Write-Host "$($arquivo.Name)"
            Write-Host "$href"

            $linksQuebrados++
        }
    }
}

# ------------------------------------------------------------
# 6. VERIFICAR CONTACT.CSS
# ------------------------------------------------------------

$htmlContato = Get-Content $contato -Raw -Encoding UTF8

$referenciaContact = (
    $htmlContato -match 'contact\.css'
)

# ------------------------------------------------------------
# RESULTADO
# ------------------------------------------------------------

Write-Host ""
Write-Host "=========================================="
Write-Host "RESULTADO FINAL"
Write-Host "=========================================="
Write-Host ""

Write-Host "Artigos encontrados: $($artigos.Count)"
Write-Host "HREF vazios: $hrefVazios"
Write-Host "Links HTML quebrados: $linksQuebrados"

if ($referenciaContact) {

    Write-Host "contact.css ausente/referenciado: ATENCAO"

}
else {

    Write-Host "contact.css ausente/referenciado: OK"
}

Write-Host ""
Write-Host "=========================================="

if (
    $hrefVazios -eq 0 -and
    $linksQuebrados -eq 0 -and
    !$referenciaContact
) {

    Write-Host "SITE APROVADO NESTAS VERIFICACOES."

}
else {

    Write-Host "AINDA EXISTEM PENDENCIAS LISTADAS ACIMA."
}

Write-Host "=========================================="
Write-Host ""