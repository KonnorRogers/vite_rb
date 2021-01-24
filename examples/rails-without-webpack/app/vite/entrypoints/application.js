import 'vite/dynamic-import-polyfill'

import "@rails/ujs" // Autostarts
import Turbolinks from "turbolinks"
import ActiveStorage from "@rails/activestorage"
import "../stylesheets/index.css"

Turbolinks.start()
ActiveStorage.start()

console.log("Hello from Vite")

import "../images/check.svg"

