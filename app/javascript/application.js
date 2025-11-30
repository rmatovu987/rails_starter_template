// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "preline/preline"

document.addEventListener("turbo:load", () => {
    if (window.HSStaticMethods) {
        window.HSStaticMethods.autoInit();
    }
});

document.addEventListener("turbo:frame-render", (event) => {
    if (window.HSStaticMethods) {
        window.HSStaticMethods.autoInit();
    }
});