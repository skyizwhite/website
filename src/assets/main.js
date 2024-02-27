import './style.css'
import HTMX from 'htmx.org'
import Alpine from 'alpinejs'
import anchor from '@alpinejs/anchor'
import intersect from '@alpinejs/intersect'
import persist from '@alpinejs/persist'

window.htmx = HTMX
import("htmx.org/dist/ext/debug.js")
import("htmx.org/dist/ext/alpine-morph.js")
import("htmx.org/dist/ext/head-support.js")

window.Alpine = Alpine
Alpine.plugin(anchor)
Alpine.plugin(intersect)
Alpine.plugin(persist)
Alpine.start()
