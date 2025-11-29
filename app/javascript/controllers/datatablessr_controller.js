import { Controller } from '@hotwired/stimulus';

import jszip from 'jszip';
import pdfmake from 'pdfmake';
import DataTable from 'datatables.net-dt';
import 'datatables.net-buttons/js/buttons.colVis.mjs';
import 'datatables.net-buttons/js/buttons.html5.mjs';
import 'datatables.net-buttons/js/buttons.print.mjs';
import pdfFonts from 'pdfmake/build/vfs_fonts';
import moment from "moment";

DataTable.Buttons.jszip(jszip);
DataTable.Buttons.pdfMake(pdfmake);

// Connects to data-controller="datatablessr"
export default class extends Controller {
    // Define expected Stimulus values
    static values = {
        url: String, // URL for AJAX data
        columns: Array,    // Column definitions (parsed from JSON)
        order: {           // Default order (parsed from JSON)
            type: Array,
            default: []    // Default to empty array if not provided
        }
    }

    static targets = ["table", "dateRangeInput", "dateRangeFilter"];

    connect() {
        if (!this.element.dataset.dataTableInitialized) {
            // Basic validation
            if (!this.hasUrlValue) {
                console.error('DataTables controller requires a sourceUrl value.');
                return;
            }

            if (!this.hasColumnsValue || this.columnsValue.length === 0) {
                console.error('DataTables controller requires a columns value.');
                return;
            }

            // Ensure the table has an ID for specific selectors later
            if (!this.element.id) {
                console.warn('DataTable element should have a unique ID for reliable styling.', this.element);
                // You could generate a unique ID here if needed, but it's better to set it in the HTML
            }

            // ⭐ Call both initialization methods
            this.initializeDataTable();

            // ⭐ Set the flag once after all initializations
            this.element.dataset.dataTableInitialized = true;
        }
    }

    initializeDataTable() {
        this.tableTarget.classList.add('table', 'stripe', 'hover', 'w-full'); // Ensure w-full

        this.dataTable = new DataTable(this.tableTarget, { // Store instance if needed
            lengthMenu: [10, 25, 50, 100, 200, { label: 'All', value: -1 }],
            // --- Core Server-Side Configuration ---
            serverSide: true,
            scrollX: true,
            ajax: {
                url: this.urlValue,
                type: 'GET',
                error: (xhr, error, thrown) => { // Use arrow function for correct `this`
                    console.error("DataTables AJAX error:", error, thrown, xhr);
                    // Optionally, display error to user within the table wrapper
                    this.displayError("Could not load data.");
                }
            },
            processing: true,

            // --- Dynamic Column Definitions ---
            columns: this.columnsValue, // Use columns from data attribute

            // --- Dynamic Default Order ---
            order: this.orderValue, // Use order from data attribute

            // --- Layout and Buttons ---
            layout: {
                topStart: null,
                topEnd: null,
                bottomStart: null,
                bottomEnd: null,
                top: ['search', 'buttons'],
                bottom: ['pageLength', 'info', 'paging'],
            },
            buttons: [
                {
                    extend: 'collection',
                    text: 'Export',
                    buttons: [
                        {
                            extend: 'copyHtml5',
                            text: '<span class="flex w-full items-center gap-x-2 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:hover:text-neutral-300 dark:focus:bg-neutral-700">' +
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-copy-icon lucide-copy shrink-0 size-4"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg> Copy</span>',
                            titleAttr: 'Copy',
                            exportOptions: {
                                columns: ':not(.no-export)'
                            }
                        },
                        {
                            extend: 'print',
                            text: '<span class="flex w-full items-center gap-x-2 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:hover:text-neutral-300 dark:focus:bg-neutral-700">' +
                                '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-printer-icon lucide-printer shrink-0 size-4"><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><path d="M6 9V3a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v6"/><rect x="6" y="14" width="12" height="8" rx="1"/></svg> Print</span>',
                            titleAttr: 'Print',
                            exportOptions: {
                                columns: ':not(.no-export)'
                            }
                        },
                        {
                            extend: 'excelHtml5',
                            text: '<span class="flex w-full items-center gap-x-2 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:hover:text-neutral-300 dark:focus:bg-neutral-700">' +
                                '<svg class="shrink-0 size-4" width="32" height="32" viewBox="0' +
                                ' 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">\n' +
                                '                                      <path d="M20.0324 1.91994H9.45071C9.09999 1.91994 8.76367 2.05926 8.51567 2.30725C8.26767 2.55523 8.12839 2.89158 8.12839 3.24228V8.86395L20.0324 15.8079L25.9844 18.3197L31.9364 15.8079V8.86395L20.0324 1.91994Z" fill="#21A366"></path>\n' +
                                '                                      <path d="M8.12839 8.86395H20.0324V15.8079H8.12839V8.86395Z" fill="#107C41"></path>\n' +
                                '                                      <path d="M30.614 1.91994H20.0324V8.86395H31.9364V3.24228C31.9364 2.89158 31.7971 2.55523 31.5491 2.30725C31.3011 2.05926 30.9647 1.91994 30.614 1.91994Z" fill="#33C481"></path>\n' +
                                '                                      <path d="M20.0324 15.8079H8.12839V28.3736C8.12839 28.7243 8.26767 29.0607 8.51567 29.3087C8.76367 29.5567 9.09999 29.6959 9.45071 29.6959H30.6141C30.9647 29.6959 31.3011 29.5567 31.549 29.3087C31.797 29.0607 31.9364 28.7243 31.9364 28.3736V22.7519L20.0324 15.8079Z" fill="#185C37"></path>\n' +
                                '                                      <path d="M20.0324 15.8079H31.9364V22.7519H20.0324V15.8079Z" fill="#107C41"></path>\n' +
                                '                                      <path opacity="0.1" d="M16.7261 6.87994H8.12839V25.7279H16.7261C17.0764 25.7269 17.4121 25.5872 17.6599 25.3395C17.9077 25.0917 18.0473 24.756 18.0484 24.4056V8.20226C18.0473 7.8519 17.9077 7.51616 17.6599 7.2684C17.4121 7.02064 17.0764 6.88099 16.7261 6.87994Z" class="fill-black dark:fill-neutral-200" fill="currentColor"></path>\n' +
                                '                                      <path opacity="0.2" d="M15.7341 7.87194H8.12839V26.7199H15.7341C16.0844 26.7189 16.4201 26.5792 16.6679 26.3315C16.9157 26.0837 17.0553 25.748 17.0564 25.3976V9.19426C17.0553 8.84386 16.9157 8.50818 16.6679 8.26042C16.4201 8.01266 16.0844 7.87299 15.7341 7.87194Z" class="fill-black dark:fill-neutral-200" fill="currentColor"></path>\n' +
                                '                                      <path opacity="0.2" d="M15.7341 7.87194H8.12839V24.7359H15.7341C16.0844 24.7349 16.4201 24.5952 16.6679 24.3475C16.9157 24.0997 17.0553 23.764 17.0564 23.4136V9.19426C17.0553 8.84386 16.9157 8.50818 16.6679 8.26042C16.4201 8.01266 16.0844 7.87299 15.7341 7.87194Z" class="fill-black dark:fill-neutral-200" fill="currentColor"></path>\n' +
                                '                                      <path opacity="0.2" d="M14.7421 7.87194H8.12839V24.7359H14.7421C15.0924 24.7349 15.4281 24.5952 15.6759 24.3475C15.9237 24.0997 16.0633 23.764 16.0644 23.4136V9.19426C16.0633 8.84386 15.9237 8.50818 15.6759 8.26042C15.4281 8.01266 15.0924 7.87299 14.7421 7.87194Z" class="fill-black dark:fill-neutral-200" fill="currentColor"></path>\n' +
                                '                                      <path d="M1.51472 7.87194H14.7421C15.0927 7.87194 15.4291 8.01122 15.6771 8.25922C15.925 8.50722 16.0644 8.84354 16.0644 9.19426V22.4216C16.0644 22.7723 15.925 23.1087 15.6771 23.3567C15.4291 23.6047 15.0927 23.7439 14.7421 23.7439H1.51472C1.16402 23.7439 0.827672 23.6047 0.579686 23.3567C0.3317 23.1087 0.192383 22.7723 0.192383 22.4216V9.19426C0.192383 8.84354 0.3317 8.50722 0.579686 8.25922C0.827672 8.01122 1.16402 7.87194 1.51472 7.87194Z" fill="#107C41"></path>\n' +
                                '                                      <path d="M3.69711 20.7679L6.90722 15.794L3.96694 10.8479H6.33286L7.93791 14.0095C8.08536 14.3091 8.18688 14.5326 8.24248 14.68H8.26328C8.36912 14.4407 8.47984 14.2079 8.5956 13.9817L10.3108 10.8479H12.4822L9.46656 15.7663L12.5586 20.7679H10.2473L8.3932 17.2959C8.30592 17.148 8.23184 16.9927 8.172 16.8317H8.14424C8.09016 16.9891 8.01824 17.1399 7.92998 17.2811L6.02236 20.7679H3.69711Z" fill="white"></path>\n' +
                                '                                    </svg> Excel</span>',
                            titleAttr: 'Excel',
                            exportOptions: {
                                columns: ':not(.no-export)'
                            }
                        },
                        {
                            extend: 'csvHtml5',
                            text: '<span class="flex w-full items-center gap-x-2 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:hover:text-neutral-300 dark:focus:bg-neutral-700">' +
                                '<svg class="shrink-0 size-4" width="400" height="461"' +
                                ' viewBox="0 0 400 461" fill="none" xmlns="http://www.w3.org/2000/svg">\n' +
                                '                                      <g clip-path="url(#clip1_0)">\n' +
                                '                                        <path d="M342.544 460.526H57.4563C39.2545 460.526 24.5615 445.833 24.5615 427.632V32.8947C24.5615 14.693 39.2545 0 57.4563 0H265.79L375.439 109.649V427.632C375.439 445.833 360.746 460.526 342.544 460.526Z" fill="#E7EAF3"></path>\n' +
                                '                                        <path d="M375.439 109.649H265.79V0L375.439 109.649Z" fill="#F8FAFD"></path>\n' +
                                '                                        <path d="M265.79 109.649L375.439 219.298V109.649H265.79Z" fill="#BDC5D1"></path>\n' +
                                '                                        <path d="M387.5 389.035H12.5C5.70175 389.035 0 383.553 0 376.535V272.807C0 266.009 5.48246 260.307 12.5 260.307H387.5C394.298 260.307 400 265.79 400 272.807V376.535C400 383.553 394.298 389.035 387.5 389.035Z" fill="#377DFF"></path>\n' +
                                '                                        <path d="M91.7529 306.759C91.7529 305.748 92.0236 304.984 92.565 304.467C93.1064 303.95 93.8944 303.691 94.929 303.691C95.9275 303.691 96.6975 303.956 97.2388 304.485C97.7922 305.015 98.0689 305.772 98.0689 306.759C98.0689 307.709 97.7922 308.461 97.2388 309.015C96.6854 309.556 95.9155 309.827 94.929 309.827C93.9184 309.827 93.1365 309.562 92.5831 309.033C92.0296 308.491 91.7529 307.733 91.7529 306.759ZM114.707 287.233C112.602 287.233 110.972 288.028 109.817 289.616C108.662 291.192 108.084 293.393 108.084 296.22C108.084 302.103 110.292 305.045 114.707 305.045C116.56 305.045 118.803 304.581 121.438 303.655V308.347C119.273 309.249 116.855 309.7 114.184 309.7C110.346 309.7 107.411 308.539 105.377 306.218C103.344 303.884 102.328 300.539 102.328 296.184C102.328 293.441 102.827 291.041 103.826 288.984C104.824 286.915 106.256 285.333 108.12 284.238C109.997 283.131 112.193 282.578 114.707 282.578C117.27 282.578 119.844 283.197 122.431 284.436L120.626 288.984C119.64 288.515 118.647 288.106 117.649 287.757C116.65 287.408 115.67 287.233 114.707 287.233ZM142.642 302.013C142.642 304.395 141.782 306.272 140.061 307.643C138.353 309.015 135.971 309.7 132.915 309.7C130.1 309.7 127.61 309.171 125.444 308.112V302.915C127.225 303.709 128.729 304.269 129.956 304.593C131.195 304.918 132.326 305.081 133.348 305.081C134.575 305.081 135.514 304.846 136.163 304.377C136.825 303.908 137.156 303.21 137.156 302.284C137.156 301.766 137.012 301.309 136.723 300.912C136.434 300.503 136.007 300.112 135.442 299.739C134.888 299.366 133.751 298.771 132.031 297.953C130.419 297.195 129.21 296.467 128.404 295.769C127.598 295.071 126.954 294.259 126.473 293.333C125.992 292.407 125.751 291.324 125.751 290.085C125.751 287.751 126.539 285.916 128.115 284.581C129.703 283.245 131.893 282.578 134.684 282.578C136.055 282.578 137.36 282.74 138.6 283.065C139.851 283.39 141.156 283.847 142.516 284.436L140.711 288.785C139.303 288.208 138.136 287.805 137.21 287.576C136.296 287.348 135.393 287.233 134.503 287.233C133.445 287.233 132.632 287.48 132.067 287.973C131.502 288.467 131.219 289.11 131.219 289.904C131.219 290.398 131.333 290.831 131.562 291.204C131.79 291.564 132.151 291.919 132.645 292.268C133.15 292.605 134.335 293.219 136.2 294.109C138.666 295.288 140.356 296.473 141.27 297.664C142.185 298.843 142.642 300.293 142.642 302.013ZM162.474 282.957H168.122L159.154 309.339H153.054L144.104 282.957H149.752L154.714 298.656C154.991 299.583 155.274 300.666 155.563 301.905C155.863 303.132 156.05 303.986 156.122 304.467C156.254 303.36 156.705 301.423 157.475 298.656L162.474 282.957Z" fill="white"></path>\n' +
                                '                                      </g>\n' +
                                '                                      <defs>\n' +
                                '                                        <clipPath id="clip1_0">\n' +
                                '                                          <rect width="400" height="460.526" fill="white"></rect>\n' +
                                '                                        </clipPath>\n' +
                                '                                      </defs>\n' +
                                '                                    </svg> CSV</span>',
                            titleAttr: 'CSV',
                            exportOptions: {
                                columns: ':not(.no-export)'
                            }
                        },
                        {
                            extend: 'pdfHtml5',
                            text: '<span class="flex w-full items-center gap-x-2 rounded-lg text-sm text-gray-800 hover:bg-gray-100 focus:outline-hidden focus:bg-gray-100 dark:text-neutral-400 dark:hover:bg-neutral-700 dark:hover:text-neutral-300 dark:focus:bg-neutral-700">' +
                                '<svg class="shrink-0 size-4" width="400" height="492"' +
                                ' viewBox="0 0 400 492" fill="none" xmlns="http://www.w3.org/2000/svg">\n' +
                                '                                      <g clip-path="url(#clip1_4)">\n' +
                                '                                        <path d="M50.7496 -0.174609C22.9188 -0.174609 -0.0878906 22.4611 -0.0878906 50.6629V440.664C-0.0878906 468.495 22.5478 491.502 50.7496 491.502H349.095C376.926 491.502 399.932 468.866 399.932 440.664V119.683C399.932 119.683 400.675 110.406 396.593 101.129C392.882 92.5945 386.574 86.6573 386.574 86.6573L312.729 13.9263C312.729 13.9263 306.421 7.98906 297.144 3.90722C286.012 -0.916768 274.88 -0.174609 274.88 -0.174609H50.7496Z" fill="currentColor" class="fill-red-500"></path>\n' +
                                '                                        <path d="M50.7494 16.5238H274.508C274.508 16.5238 283.414 16.5238 290.094 19.4924C296.402 22.09 300.855 26.1718 300.855 26.1718L374.699 98.5317C374.699 98.5317 379.152 103.356 381.378 108.18C383.234 112.262 383.234 119.312 383.234 119.312V119.683V441.035C383.234 459.96 368.02 475.174 349.095 475.174H50.7494C31.8245 475.174 16.6104 459.96 16.6104 441.035V50.6629C16.6104 31.738 31.8245 16.5238 50.7494 16.5238Z" fill="currentColor" class="fill-white dark:fill-neutral-800"></path>\n' +
                                '                                        <path d="M99.7314 292.976C88.2281 281.472 100.845 265.887 134.242 248.818L155.393 238.427L163.557 220.245C168.009 210.226 175.06 193.898 178.771 184.25L185.45 166.439L180.626 153.08C174.689 136.752 172.833 112.261 176.544 103.356C181.368 91.4812 197.696 92.5944 204.004 105.582C209.199 115.601 208.457 133.784 202.52 156.791L197.696 175.715L202.148 183.137C204.375 187.219 211.425 196.867 217.363 204.288L228.866 218.389L242.967 216.534C288.238 210.597 303.452 220.616 303.452 235.088C303.452 253.27 267.829 254.755 238.143 233.974C231.464 229.15 227.011 224.698 227.011 224.698C227.011 224.698 208.457 228.408 199.18 231.006C189.532 233.603 185.079 235.088 170.978 239.912C170.978 239.912 166.154 246.962 162.814 252.157C150.94 271.453 137.21 287.038 127.191 292.976C117.172 298.171 105.669 298.542 99.7314 292.976ZM117.914 286.296C124.222 282.214 137.581 267 146.487 252.528L150.198 246.591L133.499 255.126C107.895 268.113 96.0207 280.359 101.958 287.781C105.298 291.862 109.75 291.491 117.914 286.296ZM285.27 239.541C291.578 235.088 290.836 226.182 283.414 222.471C277.848 219.502 273.395 219.131 258.923 219.131C250.017 219.874 235.916 221.358 233.319 222.1C233.319 222.1 241.112 227.666 244.451 229.522C248.904 232.119 260.407 236.943 268.571 239.541C276.735 242.138 281.559 242.138 285.27 239.541ZM217.734 211.339C214.023 207.257 207.344 199.093 203.262 192.785C197.696 185.735 195.098 180.911 195.098 180.911C195.098 180.911 191.016 193.527 188.048 201.32L178.029 226.182L175.06 231.748C175.06 231.748 190.645 226.553 198.438 224.698C206.972 222.471 223.671 219.131 223.671 219.131L217.734 211.339ZM196.211 124.507C197.324 116.343 197.696 108.18 195.098 104.098C187.677 96.3051 179.142 102.613 180.626 121.538C180.997 127.847 182.853 138.979 184.708 145.658L188.419 157.904L191.016 148.627C192.501 143.803 194.727 132.671 196.211 124.507Z" fill="currentColor" class="fill-red-500"></path>\n' +
                                '                                        <path d="M119.398 346.04H137.952C143.889 346.04 148.713 346.782 152.424 347.895C156.135 349.008 159.104 351.606 161.701 355.316C164.299 359.027 165.412 363.851 165.412 369.046C165.412 373.87 164.299 378.323 162.443 381.663C160.217 385.374 157.619 387.971 154.28 389.455C150.94 390.94 145.374 391.682 138.323 391.682H132.015V420.997H119.398V346.04ZM132.015 355.688V382.034H138.323C143.889 382.034 147.6 380.921 149.827 379.065C152.053 376.839 153.166 373.499 153.166 369.046C153.166 365.707 152.424 362.738 150.94 360.512C149.456 358.285 147.971 357.172 146.487 356.43C145.003 356.059 142.034 355.688 138.694 355.688H132.015Z" fill="currentColor" class="fill-black dark:fill-white"></path>\n' +
                                '                                        <path d="M175.431 346.04H192.501C200.664 346.04 207.344 347.524 212.168 350.492C216.992 353.461 220.702 357.543 223.3 363.48C225.898 369.046 227.011 375.726 227.011 382.405C227.011 389.827 225.898 396.506 223.671 402.072C221.445 407.638 218.105 412.462 213.281 415.802C208.828 419.513 202.149 420.997 193.243 420.997H175.431V346.04ZM187.677 356.059V411.349H192.872C200.293 411.349 205.488 408.751 208.828 403.927C212.168 398.732 213.652 392.053 213.652 383.889C213.652 365.336 206.602 356.059 192.872 356.059H187.677Z" fill="currentColor" class="fill-black dark:fill-white"></path>\n' +
                                '                                        <path d="M238.885 346.04H280.816V356.059H251.501V378.694H274.879V388.713H251.501V421.368H238.885V346.04Z" fill="currentColor" class="fill-black dark:fill-white"></path>\n' +
                                '                                      </g>\n' +
                                '                                      <defs>\n' +
                                '                                        <clipPath id="clip1_4">\n' +
                                '                                          <rect width="400" height="491.75" fill="white"></rect>\n' +
                                '                                        </clipPath>\n' +
                                '                                      </defs>\n' +
                                '                                    </svg> PDF</span>',
                            titleAttr: 'PDF',
                            exportOptions: {
                                columns: ':not(.no-export)'
                            }
                        }
                    ],
                },
                {
                    extend: 'colvis',
                    columns: ':not(.no-export)'
                }
            ],
            language: {
                search: '', // Remove the "Search" label
                lengthMenu: 'Display _MENU_ _ENTRIES_'
            },

            // Style after each draw
            drawCallback: () => {
                // this.styleElements();
            },
            // Also style on initial load
            initComplete: (settings, json) => {
                this.styleElements();
                if (json && json.error) {
                    this.displayError(json.error);
                }
            },
        });

        this.element.dataset.dataTableInitialized = true;
    }

    // Helper function to apply styles
    styleElements() {
        const searchInput = document.querySelector('input.dt-input');
        if (searchInput) {
            searchInput.style.display = 'flex';
            searchInput.style.alignItems = 'center';
            searchInput.style.border = '1px solid #d1d1d1'; // Light gray border
            searchInput.style.borderRadius = '0.375rem'; // Rounded corners (6px)
            // searchInput.style.boxShadow = '0 1px 2px 0 rgba(0, 0, 0, 0.05)'; // Subtle shadow
            searchInput.style.fontWeight = '200'; // Medium font weight
            searchInput.style.color = '#374151'; // Dark gray text
            searchInput.style.backgroundColor = 'white'; // White background
            searchInput.style.background = 'white'; // White background

            // Create a wrapper div
            const wrapper = document.createElement('div');
            wrapper.style.position = 'relative';
            wrapper.classList.add('relative'); // Add relative class for tailwind.

            // Insert the wrapper before the input
            searchInput.parentNode.insertBefore(wrapper, searchInput);

            // Move the input inside the wrapper
            wrapper.appendChild(searchInput);

            // Insert the SVG inside the wrapper
            wrapper.insertAdjacentHTML('beforeend', `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-search-icon lucide-search absolute left-2 top-1/2 transform -translate-y-1/2 ps-1 shrink-0 size-5"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>`);

            searchInput.classList.add('border', 'rounded-md', 'focus:ring', 'focus:border-blue-300', 'ps-14'); // Add padding left for icon
            searchInput.style.paddingLeft = '30px';
            searchInput.placeholder = 'Search...';
        }

        const arrs = document.querySelectorAll('.dt-button-down-arrow');
        if (arrs) {
            arrs.forEach(arr => {
                arr.style.display = 'none';
            })
        }

        const btnComp = document.querySelector('.dt-buttons');
        if (btnComp) {
            btnComp.style.display = 'flex';
        }

        const exportBgs = document.querySelectorAll('.dt-button-background');
        if (exportBgs) {
            exportBgs.forEach(exportBg => {
                exportBg.style.display = 'none';
            })
        }

        const exportButton = document.querySelector('button.dt-button.buttons-collection');
        if (exportButton) {
            // Remove inline-block if it exists
            exportButton.style.display = 'flex';

            // Add the download icon
            exportButton.insertAdjacentHTML('afterbegin', `
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
                        </svg>
                    `);

            // Add the dropdown arrow icon
            exportButton.insertAdjacentHTML('beforeend', `
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    `);
        }


        const colvisButton = document.querySelector('button.dt-button.buttons-collection.buttons-colvis');
        if (colvisButton) {
            // Remove inline-block if it exists
            colvisButton.style.display = 'flex';

            // Add the dropdown arrow icon
            colvisButton.insertAdjacentHTML('beforeend', `
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                        </svg>
                    `);
        }

        const buttons = document.querySelectorAll('.dt-button');
        if (buttons) {
            buttons.forEach(button => {
                button.style.display = 'flex';
                button.style.alignItems = 'center';
                button.style.border = '1px solid #d1d1d1'; // Light gray border
                button.style.borderRadius = '0.375rem'; // Rounded corners (6px)
                button.style.padding = '0.5rem 0.75rem'; // Padding (8px 12px)
                // button.style.boxShadow = '0 1px 2px 0 rgba(0, 0, 0, 0.05)'; // Subtle shadow
                button.style.fontWeight = '500'; // Medium font weight
                button.style.color = '#374151'; // Dark gray text
                button.style.backgroundColor = 'white'; // White background
                button.style.background = 'white'; // White background
                button.style.marginLeft = '0.5rem'; // Margin left
            });
        }
    }

    // Helper to display errors within the table wrapper
    displayError(message) {
        try {
            const wrapper = this.element.closest('.dataTables_wrapper');
            if (wrapper) {
                // Remove existing error
                const existingError = wrapper.querySelector('.datatable-error-message');
                if (existingError) existingError.remove();

                // Add new error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'datatable-error-message text-red-600 dark:text-red-400 p-4 border border-red-300 dark:border-red-600 bg-red-50 dark:bg-red-900/20 rounded-md my-2';
                errorDiv.textContent = `Error: ${message}`;
                // Insert after the top controls (search/buttons) or at the top
                const topControls = wrapper.querySelector('.dt-layout-row:first-child');
                if (topControls) {
                    topControls.parentNode.insertBefore(errorDiv, topControls.nextSibling);
                } else {
                    wrapper.prepend(errorDiv);
                }
            } else {
                console.error("Could not find DataTables wrapper to display error:", message);
            }
        } catch(e) {
            console.error("Error displaying datatable error:", e);
        }
    }
}