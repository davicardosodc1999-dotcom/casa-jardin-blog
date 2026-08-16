$arquivos = Get-ChildItem ".\articles" -Filter "*.html" -File

foreach ($arquivo in $arquivos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    $original = $html

    # Corrige qualquer href="#" cujo texto comece com Jardiner
    # Funciona mesmo se o acento estiver com codificacao errada.
    $html = [regex]::Replace(
        $html,
        '(?is)<a\s+href="#">(\s*Jardiner.*?\s*)</a>',
        '<a href="../categorias/jardineria.html">$1</a>'
    )

    if ($html -ne $original) {

        Set-Content `
            -Path $arquivo.FullName `
            -Value $html `
            -Encoding UTF8

        Write-Host "CORRIGIDO - $($arquivo.Name)"
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "VERIFICACAO FINAL"
Write-Host "=========================================="

$total = 0
$afetados = 0

foreach ($arquivo in $arquivos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    $qtd = (
        [regex]::Matches(
            $html,
            'href\s*=\s*"#"',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        )
    ).Count

    if ($qtd -gt 0) {

        Write-Host "$($arquivo.Name) -> $qtd restante(s)"

        $total += $qtd
        $afetados++
    }
}

Write-Host ""
Write-Host "ARTIGOS COM HREF VAZIO: $afetados"
Write-Host "TOTAL DE HREF VAZIOS: $total"
Write-Host ""