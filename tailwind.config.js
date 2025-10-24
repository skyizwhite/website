/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/document.lisp",
    "./src/pages/**/*.lisp",
    "./src/components/**/*.lisp",
  ],
  theme: {
    container: {
      center: true,
    },
  },
  plugins: [],
}
