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
      tests: ["test/actual/*"]

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
          process: true
        files:
          "test/actual/test1.html": "test/fixtures/test1.md"

      test2:
        files:
          "test/actual/test2.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test3:
        files:

          "test/actual/test3.pdf": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "test/actual/test3.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "test/actual/test3.docx": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test4:
        options:
          spawnLimit: 3
        files: [
          expand: true
          cwd: "test/fixtures/test4"
          src: "**/*.md"
          dest: "test/actual/test4"
          ext: ".html"
        ]

      # test5:
      #   options:
      #     stripMeta: '````'

      #   files: [
      #     expand: true
      #     cwd: "test"
      #     src: "**/pi.md"
      #     dest: "actual/"
      #     ext: ".html"
      #   ]

      # test6:
      #   options:
      #     stripMeta: '````'
      #     metaDataFile: "meta.yaml"

      #   files: [
      #     expand: true
      #     cwd: "test"
      #     src: "**/*.md"
      #     dest: "actual/"
      #     ext: ".html"
      #   ]

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

  # Whenever the "test" task is run, first clean the "actual" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "panda", "nodeunit"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["test"]
  #grunt.registerTask "default", ["jshint", "test"]
