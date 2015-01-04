module.exports = (config) ->
  config.set

    frameworks: ["browserify", "jasmine"]

    reporters: ["dots"]

    files: [
      "test/**/*.coffee"
    ]

    preprocessors:
      "test/**/*.coffee": ["browserify"]

    browsers: ["PhantomJS"]

    browserify:
      extensions: [".coffee"]
      transform: ["coffeeify"]
