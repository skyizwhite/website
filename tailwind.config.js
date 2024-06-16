/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/response.lisp",
    "./src/routes/**/*.lisp",
    "./src/components/**/*.lisp",
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}
