const tocToggle = document.querySelector('.toc-toggle');
const toc = document.getElementById("toc");

tocToggle.addEventListener('click', () =>{
    const isOpened = (tocToggle.getAttribute('aria-expanded') === 'true');

    if(isOpened) {
        tocToggle.setAttribute('aria-expanded', 'false');
    } else {
        tocToggle.setAttribute('aria-expanded', 'true');
    }
});

document.querySelector("#toc").addEventListener("click", (event) => {
    if (event.target.closest("a[href^='#']")) {
        event.currentTarget.hidePopover();
    }
});
