import 'vite/dynamic-import-polyfill'

import "@rails/ujs" // Autostarts
import Turbolinks from "turbolinks"
import ActiveStorage from "@rails/activestorage"
import "../stylesheets/index.css"

Turbolinks.start()
ActiveStorage.start()

console.log("Hello from Vite")

// Import all javascript in a directory. IE: Stimulus
// import { Application } from "stimulus"
// const application = Application.start()
// const controllers = import.meta.glob("./controllers/**/*.js")
// for (const path in controllers) {
//   controllers[path]().then((mod) => {
//     application.register(controllerNameFromFile(path), mod)
//   })
// }
