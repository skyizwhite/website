/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/renderer.lisp",
    "./src/routes/**/*.lisp",
    "./src/components/**/*.lisp",
  ],
  theme: {
    container: {
      center: true,
    },
  },
  plugins: [],
}
