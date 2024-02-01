/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./src/routes/**/*.lisp",
        "./src/ui/**/*.lisp"
    ],
    plugins: [require("daisyui")],
};
