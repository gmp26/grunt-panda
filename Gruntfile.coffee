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

      test1:
        options:
          process: false
         files:
          "tmp/test1.html": "test/fixtures/input.md"

      test2:
        options:
          process: false
          pandocOptions: "--mathml"
        files:
          "tmp/test2.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test3:
        options:
          process: false
        files:
          "tmp/test3.pdf": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "tmp/test4.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "tmp/test5.docx": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test4:
        options:
          process: false

        files: [
          expand: true
          cwd: "test"
          src: "**/*.md"
          dest: "tmp/"
          ext: ".html"
        ]
    
    # Unit tests.
    nodeunit:
      tests: ["test/*_test.js"]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
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
  grunt.registerTask "default", ["test"]
  #grunt.registerTask "default", ["jshint", "test"]
