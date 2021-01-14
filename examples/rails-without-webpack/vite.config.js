// import { path } from "path"
import process from "process"

const PREFIX = "VITE_RB"

// // All options are stored as process.env[`VITE_RB_${option}`]
// // Can be accessed via: options.OPTION_NAME
const options = {}

const envVars = [
  "ROOT",
  "OUT_DIR",
  "ENTRYPOINTS_DIR",
  "BASE",
  "ASSETS_DIR",
  "HOST",
  "HTTPS",
  "PORT",
  "MANIFEST"
]

envVars.forEach((option) => {
  options[option] = process.env[`${PREFIX}_${option}`]
})

console.warn(options)

/**
 * type {import('vite').UserConfig}
 */
export default {
  // Project root directory
  // https://vitejs.dev/config/#root
  root: options.ROOT,

  // https://vitejs.dev/config/#mode
  // mode: "",

  // import aliases https://vitejs.dev/config/#alias
  // alias: {},

  // Global variable replacements https://vitejs.dev/config/#define
  // define: {},

  // https://vitejs.dev/guide/api-plugin.html
  // plugins: [],

  // CSS options
  css: {
    // https://github.com/css-modules/postcss-modules#usage
    modules: {
      scopeBehaviour: 'local',
      localsConvention: "camelCaseOnly"
      // globalModulePaths?: string[],
      // generateScopedName?:, string | ((name: string, filename: string, css: string) => string)
      // hashPrefix?: string,
    },

    // https://vitejs.dev/config/#css-preprocessoroptions
    // preprocessorOptions: {},
  },


  // Esbuild transform options
  // https://vitejs.dev/config/#esbuild
  // esbuild: {},

  // https://vitejs.dev/config/#assetsinclude
  // assetsInclude: [],

  // Force Vite to always resolve listed dependencies to the same copy
  // https://vitejs.dev/config/#dedupe
  // dedupe: [],

  // https://vitejs.dev/config/#loglevel
  logLevel: "info",

  // Server related options
  // https://vitejs.dev/config/#server-options
  server: {
    host: options.HOST,
    port: parseInt(options.PORT, 10),
    strictPort: true,
    https: options.HTTPS,
    open: false,
    cors: true,
    force: false,
    hmr: true,
    // proxy: {},
    // watch: {}
  },

  // https://vitejs.dev/config/#build-options
  build: {
    base: options.BASE,
    outDir: options.OUT_DIR,
    manifest: Boolean(options.MANIFEST),
    sourceMap: "true",
    target: "modules",
    assetsInlineLimit: 4096,
    cssCodeSplit: true,
    rollupOptions: {
      input: './app/vite/application.js'
    },
    minify: "terser",
    write: true,
    emptyOutDir: true,

    // polyfillDynamicImport: true,
    // terserOptions: {},
    // cleanCssOptions: {},
    // commonjsOptions: {},
    // lib: "",
  },

  // https://vitejs.dev/config/#dep-optimization-options
  // optimizeDeps: {
  //   include: [],
  //   exclude: [],
  //   plugins: [],
  //   auto: true
 // }
}
