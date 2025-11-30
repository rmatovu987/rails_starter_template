import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tree"
export default class extends Controller {
    static targets = ["icon", "children"]

    connect() {
        if (this.hasChildrenTarget && this.hasIconTarget) {
            this.setCollapsedIcon();
        }
    }

    toggle(event) {
        event.preventDefault();
        if (this.hasChildrenTarget && this.hasIconTarget) {
            this.childrenTarget.classList.toggle("hidden");
            this.toggleIcon();
        }
    }

    setCollapsedIcon() {
        this.iconTarget.innerHTML = this.collapsedSvg();
    }

    setExpandedIcon() {
        this.iconTarget.innerHTML = this.expandedSvg();
    }

    toggleIcon() {
        if (this.childrenTarget.classList.contains("hidden")) {
            this.setCollapsedIcon();
        } else {
            this.setExpandedIcon();
        }
    }

    collapsedSvg() {
        // Define your collapsed SVG here
        return `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
              stroke-linejoin="round"
               class="lucide lucide-chevron-right-icon lucide-chevron-right shrink-0 size-4">
              <path d="m9 18 6-6-6-6"/>
            </svg>
        `;
    }

    expandedSvg() {
        // Define your expanded SVG here
        return `
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"
             fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
              stroke-linejoin="round"
               class="lucide lucide-chevron-down-icon lucide-chevron-down shrink-0 size-4">
               <path d="m6 9 6 6 6-6"/>
            </svg>
        `;
    }
}