$raiz = (Get-Location).Path

$arquivos = Get-ChildItem "$raiz\articles" -Filter "*.html" -File

$problemas = 0

Write-Host ""
Write-Host "=========================================="
Write-Host "VERIFICANDO LINKS ENTRE ARTIGOS"
Write-Host "=========================================="
Write-Host ""

foreach ($arquivo in $arquivos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($html)) {
        continue
    }

    $links = [regex]::Matches(
        $html,
        'href\s*=\s*["'']([^"'']+\.html(?:#[^"'']*)?)["'']'
    )

    foreach ($link in $links) {

        $href = $link.Groups[1].Value

        # Remove ancora
        $hrefLimpo = $href.Split("#")[0]

        if ([string]::IsNullOrWhiteSpace($hrefLimpo)) {
            continue
        }

        $hrefLimpo = $hrefLimpo.Replace("/", "\")

        $destino = Join-Path $arquivo.DirectoryName $hrefLimpo

        try {
            $destino = [System.IO.Path]::GetFullPath($destino)
        }
        catch {
            continue
        }

        if (!(Test-Path $destino)) {

            Write-Host "LINK HTML QUEBRADO"
            Write-Host "Artigo: $($arquivo.Name)"
            Write-Host "Link:   $href"
            Write-Host ""

            $problemas++
        }
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "RESULTADO"
Write-Host "=========================================="
Write-Host ""
Write-Host "TOTAL DE LINKS HTML QUEBRADOS: $problemas"
Write-Host ""