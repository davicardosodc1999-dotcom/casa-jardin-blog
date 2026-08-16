# ============================================================
# CASA & JARDIN
# CORRIGIR TODAS AS IMAGENS PRINCIPAIS QUEBRADAS
# ============================================================

$PastaArtigos = ".\articles"
$PastaImagens = ".\img\artigos"

$artigos = Get-ChildItem $PastaArtigos -Filter "*.html" -File |
    Sort-Object Name

$imagens = Get-ChildItem $PastaImagens -File |
    Where-Object {
        $_.Extension -match '^\.(jpg|jpeg|png|webp)$'
    } |
    Sort-Object Name

Write-Host ""
Write-Host "=========================================="
Write-Host "CORRIGINDO CAPAS DOS ARTIGOS"
Write-Host "=========================================="
Write-Host ""
Write-Host "Artigos: $($artigos.Count)"
Write-Host "Imagens disponiveis: $($imagens.Count)"
Write-Host ""

if ($imagens.Count -eq 0) {
    Write-Host "ERRO: nenhuma imagem encontrada em img\artigos."
    exit
}

# ------------------------------------------------------------
# BACKUP AUTOMATICO
# ------------------------------------------------------------

$backup = ".\backup-antes-capas"

if (!(Test-Path $backup)) {

    New-Item `
        -ItemType Directory `
        -Path $backup |
        Out-Null

    Copy-Item `
        ".\articles\*" `
        $backup `
        -Recurse

    Write-Host "Backup criado em backup-antes-capas."
    Write-Host ""
}

$corrigidos = 0
$mantidos = 0
$erros = 0

# ------------------------------------------------------------
# PROCESSAR ARTIGOS
# ------------------------------------------------------------

for ($i = 0; $i -lt $artigos.Count; $i++) {

    $arquivo = $artigos[$i]

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($html)) {
        continue
    }

    # Localizar somente a imagem principal
    $principal = [regex]::Match(
        $html,
        '(?is)<figure\b[^>]*class="[^"]*article-main-image[^"]*"[^>]*>.*?<img\b[^>]*src="([^"]+)"[^>]*>'
    )

    if (!$principal.Success) {

        Write-Host "SEM CAPA IDENTIFICADA - $($arquivo.Name)"
        $erros++
        continue
    }

    $srcAtual = $principal.Groups[1].Value

    # Ignorar URL externa
    if ($srcAtual -match '^https?://') {
        $mantidos++
        continue
    }

    # Descobrir se o arquivo atual realmente existe
    $srcLimpo = $srcAtual.Split("?")[0].Split("#")[0]
    $srcWindows = $srcLimpo.Replace("/", "\")

    $caminhoAtual = Join-Path `
        $arquivo.DirectoryName `
        $srcWindows

    try {
        $caminhoAtual = [System.IO.Path]::GetFullPath($caminhoAtual)
    }
    catch {
        $caminhoAtual = ""
    }

    if (
        $caminhoAtual -ne "" -and
        (Test-Path $caminhoAtual)
    ) {

        Write-Host "OK - capa existente - $($arquivo.Name)"
        $mantidos++
        continue
    }

    # --------------------------------------------------------
    # CAPA ESTA QUEBRADA
    # Escolher imagem que nao esteja sendo usada internamente
    # --------------------------------------------------------

    $internas = [regex]::Matches(
        $html,
        '(?is)<figure\b[^>]*class="[^"]*article-image[^"]*"[^>]*>.*?<img\b[^>]*src="([^"]+)"'
    )

    $nomesUsados = @()

    foreach ($interna in $internas) {

        $srcInterna = $interna.Groups[1].Value

        $nomeInterno = [System.IO.Path]::GetFileName(
            $srcInterna.Split("?")[0].Split("#")[0]
        )

        $nomesUsados += $nomeInterno
    }

    $novaImagem = $null

    # Comecar em posicao diferente para espalhar as capas
    for ($tentativa = 0; $tentativa -lt $imagens.Count; $tentativa++) {

        $indice = ($i + ($tentativa * 7)) % $imagens.Count

        $candidata = $imagens[$indice]

        if ($nomesUsados -notcontains $candidata.Name) {

            $novaImagem = $candidata
            break
        }
    }

    if ($null -eq $novaImagem) {

        Write-Host "ERRO AO ESCOLHER CAPA - $($arquivo.Name)"
        $erros++
        continue
    }

    $novoSrc = "../img/artigos/$($novaImagem.Name)"

    # --------------------------------------------------------
    # TROCAR SOMENTE SRC DA IMAGEM PRINCIPAL
    # --------------------------------------------------------

    $padraoPrincipal = '(?is)(<figure\b[^>]*class="[^"]*article-main-image[^"]*"[^>]*>.*?<img\b[^>]*src=")[^"]+(")'

    $html = [regex]::Replace(
        $html,
        $padraoPrincipal,
        '${1}' + $novoSrc + '${2}',
        1
    )

    # --------------------------------------------------------
    # CORRIGIR OG:IMAGE LOCAL, SE EXISTIR
    # --------------------------------------------------------

    $html = [regex]::Replace(
        $html,
        '(?is)(<meta\b[^>]*property="og:image"[^>]*content=")[^"]+(")',
        '${1}' + $novoSrc + '${2}',
        1
    )

    # --------------------------------------------------------
    # CORRIGIR IMAGE DO ARTICLE SCHEMA
    # Somente caminhos locais quebrados
    # --------------------------------------------------------

    $html = [regex]::Replace(
        $html,
        '"image"\s*:\s*\[\s*"[^"]+"\s*\]',
        '"image": ["' + $novoSrc + '"]',
        1
    )

    Set-Content `
        -Path $arquivo.FullName `
        -Value $html `
        -Encoding UTF8

    Write-Host "CORRIGIDO - $($arquivo.Name) -> $($novaImagem.Name)"

    $corrigidos++
}

# ------------------------------------------------------------
# VERIFICACAO FINAL
# ------------------------------------------------------------

Write-Host ""
Write-Host "=========================================="
Write-Host "RESULTADO"
Write-Host "=========================================="
Write-Host ""
Write-Host "Capas corrigidas: $corrigidos"
Write-Host "Capas que ja estavam OK: $mantidos"
Write-Host "Erros: $erros"
Write-Host ""

$quebradas = 0

foreach ($arquivo in $artigos) {

    $html = Get-Content `
        $arquivo.FullName `
        -Raw `
        -Encoding UTF8

    $principal = [regex]::Match(
        $html,
        '(?is)<figure\b[^>]*class="[^"]*article-main-image[^"]*"[^>]*>.*?<img\b[^>]*src="([^"]+)"'
    )

    if (!$principal.Success) {
        continue
    }

    $src = $principal.Groups[1].Value

    if ($src -match '^https?://') {
        continue
    }

    $src = $src.Split("?")[0].Split("#")[0]
    $src = $src.Replace("/", "\")

    $destino = Join-Path `
        $arquivo.DirectoryName `
        $src

    try {
        $destino = [System.IO.Path]::GetFullPath($destino)
    }
    catch {
        $quebradas++
        continue
    }

    if (!(Test-Path $destino)) {

        Write-Host "AINDA QUEBRADA: $($arquivo.Name)"
        $quebradas++
    }
}

Write-Host ""
Write-Host "CAPAS AINDA QUEBRADAS: $quebradas"
Write-Host ""

if ($quebradas -eq 0) {

    Write-Host "=========================================="
    Write-Host "TODAS AS CAPAS ESTAO FUNCIONANDO."
    Write-Host "=========================================="
}