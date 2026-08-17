$arquivo = ".\index.html"

$html = Get-Content $arquivo -Raw -Encoding UTF8

# ============================================================
# REMOVER BUSCA INLINE ANTIGA, CASO EXISTA
# ============================================================

$html = [regex]::Replace(
    $html,
    '(?is)<!-- BUSCA-FINAL-INICIO -->.*?<!-- BUSCA-FINAL-FIM -->',
    ''
)

# ============================================================
# SCRIPT FINAL DA PESQUISA
# ============================================================

$busca = @'
<!-- BUSCA-FINAL-INICIO -->

<script>
(function () {

    function iniciarBusca() {

        const botao = document.querySelector(".search-button");

        if (!botao) {
            console.log("Botao de busca nao encontrado.");
            return;
        }

        /*
         * Remove comportamento antigo.
         * Clonamos o botao para eliminar listeners
         * anteriores que possam estar causando conflito.
         */

        const novoBotao = botao.cloneNode(true);

        botao.parentNode.replaceChild(
            novoBotao,
            botao
        );

        novoBotao.setAttribute("type", "button");


        /*
         * Criar painel da pesquisa.
         * Nao depende do search.js antigo.
         */

        let painel = document.getElementById(
            "busca-final-painel"
        );

        if (!painel) {

            painel = document.createElement("div");

            painel.id = "busca-final-painel";

            painel.innerHTML = `
                <div class="busca-final-container">

                    <form id="busca-final-form">

                        <input
                            id="busca-final-input"
                            type="search"
                            placeholder="&#191;Qu&#233; est&#225;s buscando?"
                            autocomplete="off"
                            aria-label="Buscar articulos"
                        >

                        <button type="submit">
                            Buscar
                        </button>

                        <button
                            type="button"
                            id="busca-final-fechar"
                            aria-label="Cerrar"
                        >
                            &#10005;
                        </button>

                    </form>

                </div>
            `;

            document.body.appendChild(painel);
        }


        /*
         * CSS isolado da pesquisa.
         * Nao altera nenhuma classe existente do blog.
         */

        if (!document.getElementById("busca-final-css")) {

            const style = document.createElement("style");

            style.id = "busca-final-css";

            style.textContent = `

                #busca-final-painel {
                    display: none;
                    position: fixed;
                    top: 78px;
                    left: 0;
                    width: 100%;
                    background: #f5f4ef;
                    border-bottom: 1px solid #ddd;
                    box-shadow: 0 8px 25px rgba(0,0,0,.08);
                    z-index: 9999;
                    padding: 20px 0;
                }

                #busca-final-painel.ativo {
                    display: block;
                }

                .busca-final-container {
                    width: min(900px, 92%);
                    margin: 0 auto;
                }

                #busca-final-form {
                    display: flex;
                    align-items: stretch;
                    gap: 0;
                }

                #busca-final-input {
                    flex: 1;
                    min-width: 0;
                    border: 1px solid #ccc;
                    border-right: 0;
                    padding: 15px 16px;
                    outline: none;
                    background: white;
                    color: #252525;
                    font-size: 16px;
                }

                #busca-final-form button[type="submit"] {
                    border: 0;
                    background: #222;
                    color: white;
                    padding: 0 24px;
                    font-weight: 700;
                    cursor: pointer;
                }

                #busca-final-fechar {
                    border: 0;
                    background: white;
                    color: #222;
                    width: 50px;
                    cursor: pointer;
                    font-size: 18px;
                }

                #resultados-busca-final {
                    padding: 60px 0;
                    background: white;
                }

                #resultados-busca-final .busca-info {
                    margin: 0 0 30px;
                    color: #666;
                }

                @media (max-width: 600px) {

                    #busca-final-painel {
                        top: 68px;
                        padding: 15px 0;
                    }

                    .busca-final-container {
                        width: calc(100% - 24px);
                    }

                    #busca-final-form {
                        flex-wrap: wrap;
                    }

                    #busca-final-input {
                        width: calc(100% - 46px);
                        flex: none;
                        border-right: 1px solid #ccc;
                    }

                    #busca-final-fechar {
                        width: 46px;
                    }

                    #busca-final-form button[type="submit"] {
                        width: 100%;
                        height: 48px;
                        margin-top: 8px;
                    }
                }

            `;

            document.head.appendChild(style);
        }


        const formulario = document.getElementById(
            "busca-final-form"
        );

        const campo = document.getElementById(
            "busca-final-input"
        );

        const fechar = document.getElementById(
            "busca-final-fechar"
        );


        /*
         * Abrir pesquisa
         */

        novoBotao.addEventListener(
            "click",
            function () {

                painel.classList.toggle("ativo");

                if (
                    painel.classList.contains("ativo")
                ) {

                    setTimeout(
                        function () {
                            campo.focus();
                        },
                        50
                    );
                }
            }
        );


        /*
         * Fechar pesquisa
         */

        fechar.addEventListener(
            "click",
            function () {

                painel.classList.remove("ativo");

            }
        );


        /*
         * Normalizar texto.
         *
         * jardin encontra jard\u00edn
         * organizacion encontra organizaci\u00f3n
         */

        function normalizar(texto) {

            return (texto || "")
                .toLowerCase()
                .normalize("NFD")
                .replace(/[\u0300-\u036f]/g, "")
                .replace(/\s+/g, " ")
                .trim();
        }


        /*
         * Executar pesquisa
         */

        formulario.addEventListener(
            "submit",
            function (evento) {

                evento.preventDefault();

                const digitado = campo.value.trim();
                const termo = normalizar(digitado);

                if (termo.length < 2) {

                    campo.focus();

                    return;
                }


                /*
                 * Usamos SOMENTE os cards da secao
                 * com os 100 artigos.
                 */

                const cards = document.querySelectorAll(
                    "#todos-articulos .article-card"
                );

                const resultados = [];

                cards.forEach(
                    function (card) {

                        const titulo =
                            card.querySelector("h3");

                        const categoria =
                            card.querySelector(
                                ".article-category"
                            );

                        const descricao =
                            card.querySelector("p");

                        const texto = normalizar(
                            (titulo
                                ? titulo.textContent
                                : ""
                            ) +
                            " " +
                            (categoria
                                ? categoria.textContent
                                : ""
                            ) +
                            " " +
                            (descricao
                                ? descricao.textContent
                                : ""
                            )
                        );

                        if (texto.includes(termo)) {

                            resultados.push(
                                card.cloneNode(true)
                            );
                        }
                    }
                );


                /*
                 * Apagar busca anterior
                 */

                const antigo =
                    document.getElementById(
                        "resultados-busca-final"
                    );

                if (antigo) {
                    antigo.remove();
                }


                /*
                 * Criar resultados
                 */

                const secao =
                    document.createElement("section");

                secao.id =
                    "resultados-busca-final";

                secao.className = "section";


                const container =
                    document.createElement("div");

                container.className = "container";


                const cabecalho =
                    document.createElement("div");

                cabecalho.className =
                    "section-heading";


                const blocoTitulo =
                    document.createElement("div");


                const etiqueta =
                    document.createElement("span");

                etiqueta.className = "eyebrow";

                etiqueta.textContent =
                    "RESULTADOS";


                const tituloResultado =
                    document.createElement("h2");

                tituloResultado.textContent =
                    "Resultados de b\u00fasqueda";


                blocoTitulo.appendChild(etiqueta);

                blocoTitulo.appendChild(
                    tituloResultado
                );

                cabecalho.appendChild(
                    blocoTitulo
                );

                container.appendChild(
                    cabecalho
                );


                const info =
                    document.createElement("p");

                info.className = "busca-info";


                if (resultados.length === 0) {

                    info.textContent =
                        'No encontramos art\u00edculos para "' +
                        digitado +
                        '".';

                    container.appendChild(info);

                }
                else {

                    info.textContent =
                        resultados.length +
                        (
                            resultados.length === 1
                                ? " art\u00edculo encontrado."
                                : " art\u00edculos encontrados."
                        );

                    container.appendChild(info);


                    const grid =
                        document.createElement("div");

                    grid.className =
                        "articles-grid";


                    resultados.forEach(
                        function (card) {

                            grid.appendChild(card);

                        }
                    );


                    container.appendChild(grid);
                }


                secao.appendChild(container);


                const main =
                    document.querySelector("main");


                if (main) {

                    main.insertBefore(
                        secao,
                        main.firstChild
                    );
                }


                /*
                 * Fechar painel
                 */

                painel.classList.remove("ativo");


                /*
                 * Levar aos resultados
                 */

                secao.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });

            }
        );

    }


    /*
     * Funciona independentemente da ordem
     * dos outros scripts.
     */

    if (
        document.readyState === "loading"
    ) {

        document.addEventListener(
            "DOMContentLoaded",
            iniciarBusca
        );

    }
    else {

        iniciarBusca();

    }

})();
</script>

<!-- BUSCA-FINAL-FIM -->
'@

# ============================================================
# INSERIR DIRETAMENTE ANTES DO BODY
# ============================================================

if ($html -match '</body>') {

    $html = $html.Replace(
        '</body>',
        $busca + "`r`n</body>"
    )

}
else {

    Write-Host "ERRO: fechamento body nao encontrado."
    exit
}

Set-Content `
    -Path $arquivo `
    -Value $html `
    -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host "BUSCA FINAL INSTALADA"
Write-Host "=========================================="
Write-Host ""
Write-Host "Arquivo alterado: index.html"
Write-Host "Artigos alterados: 0"
Write-Host "CSS externo alterado: 0"
Write-Host "Imagens alteradas: 0"
Write-Host "Links alterados: 0"
Write-Host ""