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
            "Gracias por suscribirte a Casa & Jardín."
        );

    });

}