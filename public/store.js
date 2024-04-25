document.addEventListener('alpine:init', () => {
  Alpine.store('darkMode', {
    on: Alpine.$persist(false).as('darkMode'),

    toggle() {
      this.on = ! this.on
    }
  })
})
