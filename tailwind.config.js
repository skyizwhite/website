/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./src/routes/**/*.lisp",
        "./src/components/**/*.lisp"
    ],
    plugins: [require("daisyui")],
    daisyui: {
        themes: ["retro"]
    },
};
