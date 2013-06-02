#
# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed under the MIT license.
# 
"use strict"
module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    jshint:
      all: ["tasks/*.js", "<%= nodeunit.tests %>"]
      options:
        jshintrc: ".jshintrc"

    
    # Before generating any new files, remove any previously-created files.
    clean:
      tests: ["tmp/*"]

    # Compile coffee
    livescript:
      compile:
        options:
          bare: false
          prelude: true
        files:
          'tasks/panda.js': 'tasks/panda.ls'
          'test/panda_test.js': 'test/panda_test.ls'

    # Configuration to be run (and then tested).
    panda:

      default_options:
        options:
          stripMeta: true
          process: true
          mathjax: true
          read: "markdown"
        files:
          "tmp/output.html": "test/fixtures/input.md"

      multiples1:
        options:
          stripMeta: false
          process: false
          mathjax: false
        files:
          "tmp/m1.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
    
    # Unit tests.
    nodeunit:
      tests: ["test/*_test.js"]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  #grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-livescript"
  
  # Compile the panda task and tests
  grunt.task.run "livescript"

  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"
  
  # Whenever the "test" task is run, first clean the "tmp" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "panda", "nodeunit"]
  
  # By default, lint and run all tests.
  grunt.registerTask "default", ["jshint", "test"]
