document.addEventListener("DOMContentLoaded", function () {

    const searchButton = document.querySelector(".search-button");
    const searchPanel = document.querySelector(".search-panel");
    const searchForm = document.querySelector(".search-form");
    const searchInput = document.querySelector(".search-form input");

    if (!searchButton || !searchPanel || !searchForm || !searchInput) {
        console.log("Busca: elementos nao encontrados.");
        return;
    }

    // ABRIR A BUSCA
    searchButton.addEventListener("click", function () {

        searchPanel.classList.toggle("active");

        if (searchPanel.classList.contains("active")) {
            searchInput.focus();
        }
    });


    // PESQUISAR
    searchForm.addEventListener("submit", function (event) {

        event.preventDefault();

        const termo = normalizar(searchInput.value);

        if (termo.length < 2) {
            alert("Escribe al menos 2 caracteres.");
            return;
        }

        const cards = document.querySelectorAll(
            "#todos-articulos .article-card"
        );

        let resultados = [];

        cards.forEach(function (card) {

            const texto = normalizar(card.textContent);

            if (texto.includes(termo)) {
                resultados.push(card);
            }
        });


        // REMOVER RESULTADOS ANTIGOS

        let secaoAntiga = document.querySelector(
            "#resultados-busqueda"
        );

        if (secaoAntiga) {
            secaoAntiga.remove();
        }


        // CRIAR RESULTADOS

        const secao = document.createElement("section");

        secao.id = "resultados-busqueda";
        secao.className = "section";

        const container = document.createElement("div");
        container.className = "container";

        const titulo = document.createElement("h2");

        if (resultados.length === 0) {

            titulo.textContent =
                "We could not find articles matching your search.";

            container.appendChild(titulo);

        } else {

            titulo.textContent =
                "Resultados de search (" +
                resultados.length +
                ")";

            container.appendChild(titulo);

            const grid = document.createElement("div");
            grid.className = "articles-grid";

            resultados.forEach(function (card) {

                grid.appendChild(
                    card.cloneNode(true)
                );

            });

            container.appendChild(grid);
        }

        secao.appendChild(container);

        const main = document.querySelector("main");

        main.insertBefore(
            secao,
            main.firstChild
        );

        searchPanel.classList.remove("active");

        secao.scrollIntoView({
            behavior: "smooth"
        });
    });


    function normalizar(texto) {

        return texto
            .toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .trim();
    }

});