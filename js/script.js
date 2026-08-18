/* =========================
   MOBILE MENU
========================= */

const menuToggle = document.querySelector(".menu-toggle");
const mainNav = document.querySelector(".main-nav");

if (menuToggle && mainNav) {

    menuToggle.addEventListener("click", () => {

        const active = mainNav.classList.toggle("active");

        menuToggle.setAttribute(
            "aria-expanded",
            active
        );

    });

}


/* =========================
   SEARCH PANEL
========================= */

const searchButton = document.querySelector(".search-button");
const searchPanel = document.querySelector(".search-panel");

if (searchButton && searchPanel) {

    searchButton.addEventListener("click", () => {

        searchPanel.classList.toggle("active");

    });

}


/* =========================
   NEWSLETTER
========================= */

const newsletterForm =
    document.querySelector(".newsletter-form");

if (newsletterForm) {

    newsletterForm.addEventListener("submit", (event) => {

        event.preventDefault();

        alert(
            "Thank you for subscribing to Home & Garden."
        );

    });

}
/* =========================================================
   SUBLINKS MOBILE CASA JARDIN
========================================================= */

document.addEventListener("DOMContentLoaded", function () {

    const dropdowns = document.querySelectorAll(".nav-dropdown");

    dropdowns.forEach(function (dropdown) {

        const trigger = dropdown.querySelector(".nav-dropdown-trigger");

        if (!trigger) {
            return;
        }

        trigger.addEventListener("click", function (event) {

            if (window.innerWidth <= 900) {

                event.preventDefault();

                const aberto = dropdown.classList.contains("open");

                /* Fecha outros dropdowns */
                dropdowns.forEach(function (item) {

                    item.classList.remove("open");

                    const outroTrigger =
                        item.querySelector(".nav-dropdown-trigger");

                    if (outroTrigger) {
                        outroTrigger.setAttribute(
                            "aria-expanded",
                            "false"
                        );
                    }
                });

                /* Abre o atual */
                if (!aberto) {

                    dropdown.classList.add("open");

                    trigger.setAttribute(
                        "aria-expanded",
                        "true"
                    );
                }
            }
        });
    });


    /* Fechar ao clicar fora */

    document.addEventListener("click", function (event) {

        if (window.innerWidth > 900) {
            return;
        }

        if (!event.target.closest(".nav-dropdown")) {

            dropdowns.forEach(function (dropdown) {

                dropdown.classList.remove("open");

                const trigger =
                    dropdown.querySelector(".nav-dropdown-trigger");

                if (trigger) {
                    trigger.setAttribute(
                        "aria-expanded",
                        "false"
                    );
                }
            });
        }
    });


    /* Corrigir estado ao mudar tamanho da tela */

    window.addEventListener("resize", function () {

        if (window.innerWidth > 900) {

            dropdowns.forEach(function (dropdown) {

                dropdown.classList.remove("open");

                const trigger =
                    dropdown.querySelector(".nav-dropdown-trigger");

                if (trigger) {
                    trigger.setAttribute(
                        "aria-expanded",
                        "false"
                    );
                }
            });
        }
    });
});

