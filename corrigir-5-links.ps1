# ==========================================
# CORRIGIR 5 LINKS HTML QUEBRADOS
# ==========================================

# 1
$arquivo = ".\articles\como-crear-un-jardin-bonito-desde-cero.html"
$html = Get-Content $arquivo -Raw -Encoding UTF8

$html = $html.Replace(
    "./10-errores-comunes-cuidar-plantas.html",
    "errores-comunes-cuidar-plantas.html"
)

$html = $html.Replace(
    "./plantas-interior-cada-espacio-casa.html",
    "plantas-interior-faciles-cuidar.html"
)

Set-Content $arquivo -Value $html -Encoding UTF8


# 2
$arquivo = ".\articles\como-hacer-compost-en-casa.html"
$html = Get-Content $arquivo -Raw -Encoding UTF8

$html = $html.Replace(
    "como-ahorrar-agua-en-el-jardin.html",
    "como-ahorar-agua-en-el-jardin.html"
)

Set-Content $arquivo -Value $html -Encoding UTF8


# 3
$arquivo = ".\articles\errores-comunes-cuidar-plantas.html"
$html = Get-Content $arquivo -Raw -Encoding UTF8

$html = $html.Replace(
    "como-crear-jardin-desde-cero.html",
    "como-crear-un-jardin-bonito-desde-cero.html"
)

Set-Content $arquivo -Value $html -Encoding UTF8


# 4
$arquivo = ".\articles\plantas-interior-faciles-cuidar.html"
$html = Get-Content $arquivo -Raw -Encoding UTF8

$html = $html.Replace(
    "como-crear-jardin-desde-cero.html",
    "como-crear-un-jardin-bonito-desde-cero.html"
)

Set-Content $arquivo -Value $html -Encoding UTF8


Write-Host ""
Write-Host "=========================================="
Write-Host "5 LINKS CORRIGIDOS"
Write-Host "=========================================="