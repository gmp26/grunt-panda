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

    # Compile livescript
    livescript:
      compile:
        options:
          bare: false
          prelude: true
        files:
          'lib/store.js': 'lib/store.ls'
          'tasks/panda.js': 'tasks/panda.ls'
          'test/fixtures/test6/nodeModuletoRun.js': 'test/fixtures/test6/nodeModuletoRun.ls'
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

      test5:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test5/meta.yaml"

        files: [
          expand: true
          cwd: "test/fixtures"
          src: "**/test5.md"
          dest: "test/actual"
          ext: ".html"
        ]

      test6:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test6/meta.yaml"
          pipeToModule: '../test/fixtures/test6/nodeModuleToRun.js'

        files: [
          expand: true
          cwd: "test/fixtures"
          src: ["**/test5.md","**/test4/*.md"]
          dest: "test/actual"
          ext: ".html"
        ]

    # Unit tests.
    nodeunit:
      tests: ["test/*_test.js"]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  grunt.loadNpmTasks "grunt-livescript"

  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"

  # Whenever the "test" task is run, first clean the "actual" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", ["clean", "livescript", "panda", "nodeunit"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["test"]
