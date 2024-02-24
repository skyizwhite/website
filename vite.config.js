import { defineConfig } from 'vite'

export default defineConfig({
  build: {
    outDir: 'public',
    emptyOutDir: false,
    copyPublicDir: false,
    rollupOptions: {
      input: 'src/assets/main.js',
    },
  },
})
