# =========================================================
# CASA & JARDÍN
# CORRIGIR HREF="#" DOS ARTIGOS
# =========================================================

$Pasta = ".\articles"

$arquivos = Get-ChildItem $Pasta -Filter "*.html" -File

Write-Host ""
Write-Host "Artigos encontrados: $($arquivos.Count)"
Write-Host ""

foreach ($arquivo in $arquivos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $original = $html

    # =====================================================
    # CATEGORIAS / BREADCRUMBS / SIDEBAR
    # =====================================================

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Jardinería\s*</a>',
        '<a href="../categorias/jardineria.html">Jardinería</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Home Decor\s*</a>',
        '<a href="../categorias/home-decor.html">Home Decor</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Plantas de interior\s*</a>',
        '<a href="../categorias/plantas-de-interior.html">Plantas de interior</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Plantas\s*</a>',
        '<a href="../categorias/plantas-de-interior.html">Plantas</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Organización\s*</a>',
        '<a href="../categorias/organizacion-del-hogar.html">Organización</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Hogar\s*</a>',
        '<a href="../categorias/home-decor.html">Hogar</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Decoración\s*</a>',
        '<a href="../categorias/home-decor.html">Decoración</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Exterior\s*</a>',
        '<a href="../categorias/vida-al-aire-libre.html">Exterior</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Cocina\s*</a>',
        '<a href="../categorias/cocina-y-hogar.html">Cocina</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    $html = [regex]::Replace(
        $html,
        '<a\s+href="#">\s*Muebles\s*</a>',
        '<a href="../categorias/home-decor.html">Muebles</a>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )

    # =====================================================
    # RELACIONADOS DO ARTIGO 25 TÉCNICAS
    # =====================================================

    if ($arquivo.Name -eq "25-tecnicas-cuidar-jardin.html") {

        $html = [regex]::Replace(
            $html,
            '(?s)(<h3>\s*Los errores más comunes al cuidar plantas\s*</h3>.*?<a)\s+href="#"',
            '$1 href="errores-comunes-cuidar-plantas.html"',
            1
        )

        $html = [regex]::Replace(
            $html,
            '(?s)(<h3>\s*Cómo crear un jardín bonito desde cero\s*</h3>.*?<a)\s+href="#"',
            '$1 href="como-crear-un-jardin-bonito-desde-cero.html"',
            1
        )

        $html = [regex]::Replace(
            $html,
            '(?s)(<h3>\s*Cómo aprovechar mejor tu espacio exterior\s*</h3>.*?<a)\s+href="#"',
            '$1 href="como-crear-un-patio-acogedor.html"',
            1
        )
    }

    # =====================================================
    # SALVAR SOMENTE SE ALTEROU
    # =====================================================

    if ($html -ne $original) {

        Set-Content `
            -Path $arquivo.FullName `
            -Value $html `
            -Encoding UTF8

        Write-Host "CORRIGIDO - $($arquivo.Name)"
    }
}

# =========================================================
# VERIFICAÇÃO FINAL
# =========================================================

Write-Host ""
Write-Host "=========================================="
Write-Host "VERIFICACAO FINAL"
Write-Host "=========================================="

$total = 0
$afetados = 0

foreach ($arquivo in $arquivos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $qtd = (
        [regex]::Matches(
            $html,
            'href\s*=\s*["'']#["'']',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
    ).Count

    if ($qtd -gt 0) {

        $afetados++
        $total += $qtd

        Write-Host "$($arquivo.Name) -> $qtd restante(s)"
    }
}

Write-Host ""
Write-Host "ARTIGOS COM HREF VAZIO: $afetados"
Write-Host "TOTAL DE HREF VAZIOS: $total"
Write-Host ""