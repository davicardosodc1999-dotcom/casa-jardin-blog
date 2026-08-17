$arquivo = ".\index.html"

$html = Get-Content -Path $arquivo -Raw -Encoding UTF8

# ---------------------------------------------------------
# Montar textos corretos por Unicode
# Isso evita qualquer problema de codificacao no .ps1
# ---------------------------------------------------------

$iAcento = [char]0x00ED
$seta = [char]0x2192

$tituloCorreto = "Explora todos nuestros art" + $iAcento + "culos"
$botaoCorreto  = "Leer art" + $iAcento + "culo " + $seta

# ---------------------------------------------------------
# Localizar somente a secao dos 100 artigos
# ---------------------------------------------------------

$inicio = $html.IndexOf("<!-- TODOS-ARTIGOS-INICIO -->")
$fim    = $html.IndexOf("<!-- TODOS-ARTIGOS-FIM -->")

if ($inicio -lt 0 -or $fim -lt 0) {
    Write-Host "ERRO: secao dos 100 artigos nao encontrada."
    exit
}

$fim = $fim + "<!-- TODOS-ARTIGOS-FIM -->".Length

$antes = $html.Substring(0, $inicio)
$bloco = $html.Substring($inicio, $fim - $inicio)
$depois = $html.Substring($fim)

# ---------------------------------------------------------
# Corrigir o titulo da secao
# ---------------------------------------------------------

$bloco = [regex]::Replace(
    $bloco,
    '(?s)(<h2>\s*)Explora todos nuestros.*?culos(\s*</h2>)',
    '$1' + $tituloCorreto + '$2',
    1
)

# ---------------------------------------------------------
# Corrigir TODOS os botoes dos 100 cards
# Preserva cada href original
# ---------------------------------------------------------

$bloco = [regex]::Replace(
    $bloco,
    '(?s)(<a\s+href="articles/[^"]+">\s*)Leer.*?(\s*</a>)',
    '$1' + $botaoCorreto + '$2'
)

# ---------------------------------------------------------
# Montar novamente o index
# ---------------------------------------------------------

$htmlFinal = $antes + $bloco + $depois

Set-Content `
    -Path $arquivo `
    -Value $htmlFinal `
    -Encoding UTF8

# ---------------------------------------------------------
# Conferencia
# ---------------------------------------------------------

$teste = Get-Content -Path $arquivo -Raw -Encoding UTF8

$qtdBotoes = (
    [regex]::Matches(
        $teste,
        [regex]::Escape($botaoCorreto)
    )
).Count

$tituloOK = $teste.Contains($tituloCorreto)

Write-Host ""
Write-Host "=========================================="
Write-Host "CORRECAO FINALIZADA"
Write-Host "=========================================="
Write-Host ""
Write-Host "Titulo correto: $tituloOK"
Write-Host "Botoes corretos encontrados: $qtdBotoes"
Write-Host ""

if ($tituloOK -and $qtdBotoes -eq 100) {
    Write-Host "SUCESSO: titulo e 100 botoes foram corrigidos."
}
else {
    Write-Host "ATENCAO: confira os numeros acima."
}