$arquivos = Get-ChildItem ".\articles" -Filter "*.html" -File
$grupos = @{}

foreach ($arquivo in $arquivos) {

    $html = Get-Content $arquivo.FullName -Raw -Encoding UTF8

    $matches = [regex]::Matches(
        $html,
        '(?is)<a\b[^>]*href\s*=\s*"#"[^>]*>(.*?)</a>'
    )

    foreach ($m in $matches) {

        $texto = $m.Groups[1].Value
        $texto = [regex]::Replace($texto, '<[^>]+>', ' ')
        $texto = [System.Net.WebUtility]::HtmlDecode($texto)
        $texto = ($texto -replace '\s+', ' ').Trim()

        if ([string]::IsNullOrWhiteSpace($texto)) {
            $texto = "[SEM TEXTO]"
        }

        if (!$grupos.ContainsKey($texto)) {
            $grupos[$texto] = 0
        }

        $grupos[$texto]++
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "ULTIMOS HREF VAZIOS"
Write-Host "=========================================="
Write-Host ""

$grupos.GetEnumerator() |
    Sort-Object Value -Descending |
    ForEach-Object {
        Write-Host "$($_.Value)x -> $($_.Key)"
    }

Write-Host ""
Write-Host "TOTAL: $(($grupos.Values | Measure-Object -Sum).Sum)"