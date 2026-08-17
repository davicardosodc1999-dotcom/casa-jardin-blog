# ============================================================
# CASA & JARDIN
# ADICIONAR OS 100 ARTIGOS NA HOME
# SEM ALTERAR A INTERFACE EXISTENTE
# ============================================================

$PastaReferencia = ".\novos-artigos"
$PastaArtigos = ".\articles"
$Index = ".\index.html"

Write-Host ""
Write-Host "=========================================="
Write-Host "GERANDO 100 ARTIGOS NA HOME"
Write-Host "=========================================="
Write-Host ""

# ------------------------------------------------------------
# 1. PEGAR OS 100 NOMES CORRETOS
# ------------------------------------------------------------

$referencias = Get-ChildItem `
    $PastaReferencia `
    -Filter "*.html" `
    -File |
    Sort-Object Name

if ($referencias.Count -ne 100) {

    Write-Host "ERRO: novos-artigos nao possui exatamente 100 HTML."
    Write-Host "Encontrados: $($referencias.Count)"
    exit
}

# ------------------------------------------------------------
# 2. LER INDEX
# ------------------------------------------------------------

if (!(Test-Path $Index)) {

    Write-Host "ERRO: index.html nao encontrado."
    exit
}

$indexHtml = Get-Content `
    $Index `
    -Raw `
    -Encoding UTF8

# ------------------------------------------------------------
# 3. REMOVER BLOCO ANTIGO GERADO PELO SCRIPT
#    CASO ELE JA TENHA SIDO EXECUTADO
# ------------------------------------------------------------

$indexHtml = [regex]::Replace(
    $indexHtml,
    '(?is)<!-- TODOS-ARTIGOS-INICIO -->.*?<!-- TODOS-ARTIGOS-FIM -->',
    ''
)

# ------------------------------------------------------------
# 4. FUNCOES
# ------------------------------------------------------------

function Limpar-Texto($texto) {

    if ([string]::IsNullOrWhiteSpace($texto)) {
        return ""
    }

    $texto = [regex]::Replace(
        $texto,
        '<[^>]+>',
        ' '
    )

    $texto = [System.Net.WebUtility]::HtmlDecode($texto)

    return ($texto -replace '\s+', ' ').Trim()
}

function Escape-Html($texto) {

    if ([string]::IsNullOrWhiteSpace($texto)) {
        return ""
    }

    return [System.Net.WebUtility]::HtmlEncode($texto)
}

# ------------------------------------------------------------
# 5. GERAR CARDS
# ------------------------------------------------------------

$cards = ""

$contador = 0

foreach ($referencia in $referencias) {

    $arquivoFinal = Join-Path `
        $PastaArtigos `
        $referencia.Name

    if (!(Test-Path $arquivoFinal)) {

        Write-Host "ATENCAO: artigo final nao encontrado: $($referencia.Name)"
        continue
    }

    $html = Get-Content `
        $arquivoFinal `
        -Raw `
        -Encoding UTF8

    # --------------------------------------------------------
    # TITULO
    # --------------------------------------------------------

    $h1 = [regex]::Match(
        $html,
        '(?is)<h1[^>]*>(.*?)</h1>'
    )

    if ($h1.Success) {

        $titulo = Limpar-Texto $h1.Groups[1].Value

    }
    else {

        $titulo = $referencia.BaseName.Replace("-", " ")
    }

    # --------------------------------------------------------
    # CATEGORIA
    # --------------------------------------------------------

    $cat = [regex]::Match(
        $html,
        '(?is)<span[^>]*class="[^"]*article-category[^"]*"[^>]*>(.*?)</span>'
    )

    if ($cat.Success) {

        $categoria = Limpar-Texto $cat.Groups[1].Value

    }
    else {

        $categoria = "CASA & JARDIN"
    }

    # --------------------------------------------------------
    # DESCRICAO
    # Primeiro tenta article-intro.
    # --------------------------------------------------------

    $intro = [regex]::Match(
        $html,
        '(?is)<p[^>]*class="[^"]*article-intro[^"]*"[^>]*>(.*?)</p>'
    )

    if ($intro.Success) {

        $descricao = Limpar-Texto $intro.Groups[1].Value

    }
    else {

        # fallback: primeiro paragrafo do artigo

        $p = [regex]::Match(
            $html,
            '(?is)<article\b[^>]*class="[^"]*article-content-full[^"]*"[^>]*>.*?<p[^>]*>(.*?)</p>'
        )

        if ($p.Success) {

            $descricao = Limpar-Texto $p.Groups[1].Value

        }
        else {

            $descricao = "Ideas, consejos y soluciones practicas para mejorar tu hogar y jardin."
        }
    }

    # limitar descricao
    if ($descricao.Length -gt 165) {

        $descricao = $descricao.Substring(0, 162) + "..."
    }

    # --------------------------------------------------------
    # IMAGEM PRINCIPAL
    # --------------------------------------------------------

    $img = [regex]::Match(
        $html,
        '(?is)<figure\b[^>]*class="[^"]*article-main-image[^"]*"[^>]*>.*?<img\b[^>]*src="([^"]+)"'
    )

    if ($img.Success) {

        $srcImagem = $img.Groups[1].Value

        # artigo está dentro de /articles
        # home está na raiz
        # remove ../ inicial
        $srcImagem = $srcImagem -replace '^\.\./', ''

    }
    else {

        # fallback
        $srcImagem = "img/hero/hero-principal.webp"
    }

    # --------------------------------------------------------
    # ESCAPAR CONTEUDO
    # --------------------------------------------------------

    $tituloSeguro = Escape-Html $titulo
    $categoriaSegura = Escape-Html $categoria
    $descricaoSegura = Escape-Html $descricao

    $linkArtigo = "articles/$($referencia.Name)"

    # --------------------------------------------------------
    # CARD
    # --------------------------------------------------------

    $cards += @"

            <article class="article-card">

                <div class="article-image">

                    <img
                        src="$srcImagem"
                        alt="$tituloSeguro"
                        loading="lazy"
                    >

                </div>


                <div class="article-content">

                    <span class="article-category">
                        $categoriaSegura
                    </span>

                    <h3>
                        $tituloSeguro
                    </h3>

                    <p>
                        $descricaoSegura
                    </p>

                    <a href="$linkArtigo">
                        Leer artículo →
                    </a>

                </div>

            </article>

"@

    $contador++

    Write-Host "OK $contador/100 - $($referencia.Name)"
}

# ------------------------------------------------------------
# 6. CRIAR SECAO
# ------------------------------------------------------------

$secao = @"

<!-- TODOS-ARTIGOS-INICIO -->

<section
    class="section"
    id="todos-articulos"
>

    <div class="container">

        <div class="section-heading">

            <div>

                <span class="eyebrow">
                    TODOS LOS CONTENIDOS
                </span>

                <h2>
                    Explora todos nuestros artículos
                </h2>

            </div>

        </div>


        <div class="articles-grid">

$cards

        </div>

    </div>

</section>

<!-- TODOS-ARTIGOS-FIM -->

"@

# ------------------------------------------------------------
# 7. INSERIR ANTES DA NEWSLETTER
# ------------------------------------------------------------

if ($indexHtml -match '<section class="newsletter">') {

    $indexHtml = $indexHtml.Replace(
        '<section class="newsletter">',
        $secao + "`r`n<section class=`"newsletter`">"
    )

}
elseif ($indexHtml -match '</main>') {

    # fallback antes do fechamento do main

    $indexHtml = $indexHtml.Replace(
        '</main>',
        $secao + "`r`n</main>"
    )

}
else {

    Write-Host ""
    Write-Host "ERRO: nao encontrei ponto seguro para inserir a secao."
    exit
}

# ------------------------------------------------------------
# 8. BACKUP DO INDEX
# ------------------------------------------------------------

$backup = ".\index-antes-100-artigos.html"

if (!(Test-Path $backup)) {

    Copy-Item `
        $Index `
        $backup
}

# ------------------------------------------------------------
# 9. SALVAR INDEX
# ------------------------------------------------------------

Set-Content `
    -Path $Index `
    -Value $indexHtml `
    -Encoding UTF8

# ------------------------------------------------------------
# 10. VALIDACAO
# ------------------------------------------------------------

$indexFinal = Get-Content `
    $Index `
    -Raw `
    -Encoding UTF8

$blocoGerado = [regex]::Match(
    $indexFinal,
    '(?is)<!-- TODOS-ARTIGOS-INICIO -->(.*?)<!-- TODOS-ARTIGOS-FIM -->'
)

if (!$blocoGerado.Success) {

    Write-Host ""
    Write-Host "ERRO: bloco final nao encontrado."
    exit
}

$qtdCards = (
    [regex]::Matches(
        $blocoGerado.Groups[1].Value,
        'class="article-card"'
    )
).Count

Write-Host ""
Write-Host "=========================================="
Write-Host "RESULTADO"
Write-Host "=========================================="
Write-Host ""
Write-Host "Artigos esperados: 100"
Write-Host "Cards adicionados: $qtdCards"
Write-Host ""

if ($qtdCards -eq 100) {

    Write-Host "=========================================="
    Write-Host "HOME ATUALIZADA COM 100 ARTIGOS."
    Write-Host "INTERFACE ORIGINAL PRESERVADA."
    Write-Host "=========================================="

}
else {

    Write-Host "ATENCAO: quantidade diferente de 100."
}