document.addEventListener("DOMContentLoaded", () => {

    const searchButton = document.querySelector(".search-button");

    if (!searchButton) {
        return;
    }

    const searchOverlay = document.createElement("div");

    searchOverlay.className = "search-overlay";

    searchOverlay.innerHTML = `
        <div class="search-box">

            <button
                class="search-close"
                aria-label="Cerrar búsqueda"
            >
                ×
            </button>

            <span class="small-title">
                BUSCAR EN CASA & JARDÍN
            </span>

            <h2>
                ¿Qué estás buscando?
            </h2>

            <form class="search-form">

                <input
                    type="search"
                    placeholder="Buscar artículos..."
                    aria-label="Buscar artículos"
                >

                <button type="submit">
                    Buscar
                </button>

            </form>

            <div class="search-message"></div>

        </div>
    `;

    document.body.appendChild(searchOverlay);


    searchButton.addEventListener("click", () => {

        searchOverlay.classList.add("active");

        const input =
            searchOverlay.querySelector("input");

        input.focus();

    });


    const closeButton =
        searchOverlay.querySelector(".search-close");


    closeButton.addEventListener("click", () => {

        searchOverlay.classList.remove("active");

    });


    searchOverlay.addEventListener("click", (event) => {

        if (event.target === searchOverlay) {

            searchOverlay.classList.remove("active");

        }

    });


    const form =
        searchOverlay.querySelector(".search-form");


    form.addEventListener("submit", (event) => {

        event.preventDefault();

        const input =
            form.querySelector("input");

        const message =
            searchOverlay.querySelector(".search-message");

        const query =
            input.value.trim();


        if (!query) {

            message.textContent =
                "Escribe algo para realizar una búsqueda.";

            return;

        }


        message.textContent =
            `Buscando resultados para: "${query}"`;

    });

});document.addEventListener("DOMContentLoaded", () => {

    const searchButton = document.querySelector(".search-button");

    if (!searchButton) {
        return;
    }

    const searchOverlay = document.createElement("div");

    searchOverlay.className = "search-overlay";

    searchOverlay.innerHTML = `
        <div class="search-box">

            <button
                class="search-close"
                aria-label="Cerrar búsqueda"
            >
                ×
            </button>

            <span class="small-title">
                BUSCAR EN CASA & JARDÍN
            </span>

            <h2>
                ¿Qué estás buscando?
            </h2>

            <form class="search-form">

                <input
                    type="search"
                    placeholder="Buscar artículos..."
                    aria-label="Buscar artículos"
                >

                <button type="submit">
                    Buscar
                </button>

            </form>

            <div class="search-message"></div>

        </div>
    `;

    document.body.appendChild(searchOverlay);


    searchButton.addEventListener("click", () => {

        searchOverlay.classList.add("active");

        const input =
            searchOverlay.querySelector("input");

        input.focus();

    });


    const closeButton =
        searchOverlay.querySelector(".search-close");


    closeButton.addEventListener("click", () => {

        searchOverlay.classList.remove("active");

    });


    searchOverlay.addEventListener("click", (event) => {

        if (event.target === searchOverlay) {

            searchOverlay.classList.remove("active");

        }

    });


    const form =
        searchOverlay.querySelector(".search-form");


    form.addEventListener("submit", (event) => {

        event.preventDefault();

        const input =
            form.querySelector("input");

        const message =
            searchOverlay.querySelector(".search-message");

        const query =
            input.value.trim();


        if (!query) {

            message.textContent =
                "Escribe algo para realizar una búsqueda.";

            return;

        }


        message.textContent =
            `Buscando resultados para: "${query}"`;

    });

});
/* =========================
   SEARCH RESULTS
========================= */

const searchPageForm =
    document.querySelector("#search-page-form");

if (searchPageForm) {

    searchPageForm.addEventListener(
        "submit",
        function(event) {

            event.preventDefault();

            const input =
                document.querySelector("#search-page-input");

            const results =
                document.querySelector("#search-results");

            const query =
                input.value
                    .trim()
                    .toLowerCase();


            if (!query) {

                results.innerHTML = `
                    <p>
                        Escribe algo para realizar una búsqueda.
                    </p>
                `;

                return;

            }


            const matches =
                articles.filter(article => {

                    return (

                        article.title
                            .toLowerCase()
                            .includes(query)

                        ||

                        article.category
                            .toLowerCase()
                            .includes(query)

                        ||

                        article.description
                            .toLowerCase()
                            .includes(query)

                    );

                });


            if (!matches.length) {

                results.innerHTML = `
                    <p>
                        No encontramos artículos relacionados
                        con tu búsqueda.
                    </p>
                `;

                return;

            }


            results.innerHTML =
                matches.map(article => `

                    <article class="search-result">

                        <span class="article-category">
                            ${article.category}
                        </span>

                        <h2>
                            ${article.title}
                        </h2>

                        <p>
                            ${article.description}
                        </p>

                        <a href="${article.url}">
                            Leer artículo →
                        </a>

                    </article>

                `).join("");

        }
    );

}