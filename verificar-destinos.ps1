$raiz = (Get-Location).Path

$pastasIgnoradas = @(
    "novos-artigos",
    "articles-antes-imagens"
)

$arquivos = Get-ChildItem $raiz -Recurse -Filter "*.html" -File |
    Where-Object {

        $caminho = $_.FullName

        $ignorar = $false

        foreach ($pasta in $pastasIgnoradas) {

            if ($caminho -like "*\$pasta\*") {
                $ignorar = $true
                break
            }
        }

        -not $ignorar
    }

$problemas = 0

Write-Host ""
Write-Host "=========================================="
Write-Host "VERIFICANDO SITE FINAL"
Write-Host "=========================================="
Write-Host ""
Write-Host "Arquivos HTML analisados: $($arquivos.Count)"
Write-Host ""

foreach ($arquivo in $arquivos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    $links = [regex]::Matches(
        $html,
        '(?:href|src)="([^"]+)"'
    )

    foreach ($link in $links) {

        $href = $link.Groups[1].Value

        # Ignorar links externos e especiais
        if (
            $href -match '^(https?:|mailto:|tel:|javascript:|data:)'
        ) {
            continue
        }

        # Ignorar ancora pura
        if ($href.StartsWith("#")) {
            continue
        }

        # Remover ancora e query string
        $hrefLimpo = $href.Split("#")[0]
        $hrefLimpo = $hrefLimpo.Split("?")[0]

        if ([string]::IsNullOrWhiteSpace($hrefLimpo)) {
            continue
        }

        # Converter barras para Windows
        $hrefLimpo = $hrefLimpo.Replace("/", "\")

        $destino = Join-Path $arquivo.DirectoryName $hrefLimpo

        try {
            $destino = [System.IO.Path]::GetFullPath($destino)
        }
        catch {
            Write-Host "CAMINHO INVALIDO"
            Write-Host "Arquivo: $($arquivo.FullName)"
            Write-Host "Link: $href"
            Write-Host ""

            $problemas++
            continue
        }

        if (!(Test-Path $destino)) {

            Write-Host "LINK/ARQUIVO QUEBRADO"
            Write-Host "Arquivo: $($arquivo.FullName)"
            Write-Host "Destino: $href"
            Write-Host ""

            $problemas++
        }
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "RESULTADO FINAL"
Write-Host "=========================================="
Write-Host ""
Write-Host "TOTAL DE PROBLEMAS: $problemas"
Write-Host ""