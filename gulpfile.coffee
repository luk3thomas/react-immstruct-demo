sys            = require "sys"
exec           = require("child_process").exec
spawn          = require("child_process").spawn
browserify     = require "browserify"
watchify       = require "watchify"
coffee_react   = require "coffee-reactify"
gulp           = require "gulp"
jade           = require "gulp-jade"
plumber        = require "gulp-plumber"
reload         = require "gulp-livereload"
source         = require "vinyl-source-stream"

sass           = require "gulp-sass"
concat         = require "gulp-concat"
cssmin         = require "gulp-minify-css"
autoprefixer   = require "gulp-autoprefixer"

PROD  = process.env.ENV is 'PROD'

files =
  html:
    src: "src/**/*.jade"
    dest: "dest/"

  javascripts:
    src:   "./src/app/app.coffee"
    watch: "src/**/*.coffee"
    name:  "app.js"
    dest:  "dest/javascripts/"

  stylesheets:
    src: [
      "src/stylesheets/_variables.scss"
      "src/stylesheets/_mixins.scss"
      "src/stylesheets/vendor/*"
      "src/stylesheets/**/*.*"
    ]
    name: "app.css"
    dest: "dest/stylesheets/"


# Browserify. We create the browserify instance outside the normal gulp tasks.
# We'll use gulp.watch to watch for any changes for files inside the
# app folder and trigger a rebundle.

args =
  extensions: [".coffee", ".js"]
args[k] = v for k,v of watchify.args

b = browserify args
b.add files.javascripts.src
b.transform coffee_react

bundler = b

bundle = (ids)->
  bundler.bundle()
    .on "error", (error) -> console.log error
    .pipe source(files.javascripts.name)
    .pipe gulp.dest(files.javascripts.dest)

gulp.task "javascripts", -> bundle

gulp.task "stylesheets", ->

  css = gulp.src files.stylesheets.src
    .pipe plumber()
    .pipe concat(files.stylesheets.name)
    .pipe sass()
    .pipe autoprefixer
      browsers: ["ios >= 5", "android >= 2"],
      cascade: true

  if PROD
    css = css.pipe cssmin()

  css.pipe gulp.dest(files.stylesheets.dest)


gulp.task "html", ->

  gulp.src files.html.src
    .pipe plumber()
    .pipe jade
      pretty: not PROD
    .pipe gulp.dest(files.html.dest)


gulp.task "watch", ->

  reload.listen()

  gulp.watch files.stylesheets.src,      ["stylesheets"]
  gulp.watch files.html.src,             ["html"]

  gulp.watch("dest/**/*").on "change", reload.changed

gulp.task "auto-reload", ->
  process = undefined
  bundler = watchify b
  bundler.on "update", bundle

  restart = ->
    process.kill() if process?
    process = spawn "./node_modules/gulp/bin/gulp.js", ["watch", "--require coffee-script"], stdio: "inherit"

  gulp.watch "gulpfile.coffee", restart
  bundle()
  restart()

gulp.task "test", ->

  gulp.watch files.javascripts.watch, ->
    exec "npm test", (err, stdout) ->
      sys.puts stdout


gulp.task "build",   ["javascripts", "stylesheets", "html"]
gulp.task "default", ["build", "auto-reload"]
