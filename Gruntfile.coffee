# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed under the MIT license.
#
"use strict"

postProcess = require "./lib/postProcess.js"

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
          'lib/postProcess.js': 'lib/postProcess.ls'
          'lib/store.js': 'lib/store.ls'
          'tasks/panda.js': 'tasks/panda.ls'
          'test/fixtures/test6/nodeModuletoRun.js': 'test/fixtures/test6/nodeModuletoRun.ls'
          'test/panda_test.js': 'test/panda_test.ls'
          'test/bad_test.js': 'test/bad_test.ls'

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
          postProcess: postProcess

        files: [
          expand: true
          cwd: "test/fixtures"
          src: ["**/test5.md","**/test4/*.md"]
          dest: "test/actual"
          ext: ".html"
        ]

      test7:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test7/meta.yaml"
          metaReplace: "test/fixtures"
          metaReplacement: "foo"

        files: [
          expand: true
          cwd: "test/fixtures"
          src: ["**/test5.md","**/test4/*.md"]
          dest: "test/actual"
          ext: ".html"
        ]

      test8:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test8/meta.yaml"
          metaReplace: "test/fixtures"
          metaReplacement: "foo"
          metaDataVar: "test8Metadata"
          metaOnly: true

        files: [
          expand: true
          cwd: "test/fixtures/test4"
          src: ["*.md"]
          dest: "test/actual/test8"
          ext: ".html"
        ]


      test9:
        options:
          stripMeta: '````'
          #metaDataPath: "test/actual/test9/meta.yaml"
          metaReplace: "test/fixtures"
          metaReplacement: "foo"
          #metaDataVar: "test9Metadata"
        files: [
          expand: true
          cwd: "test/fixtures/test4"
          src: ["*.md"]
          dest: "test/actual/test9"
          ext: ".html"
        ]

      test10:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test10/meta.yaml"
        files: [
          expand: true
          cwd: "test/fixtures/test10"
          src: ["*.md"]
          dest: "test/actual/test10"
          ext: ".html"
        ]        



    # Unit tests.
    nodeunit:
      tests: ["test/panda_test.js"]
      badtest: ["test/bad_test.js"]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-nodeunit"
  grunt.loadNpmTasks "grunt-livescript"

  # Actually load this plugin's task(s).
  grunt.loadTasks "tasks"

  # Whenever the "test" task is run, first clean the "actual" dir, then run this
  # plugin's task(s), then test the result.
  grunt.registerTask "test", [
    "clean"
    "livescript"
    "panda:test1"
    "panda:test2"
    "panda:test3"
    "panda:test4"
    "panda:test5"
    "panda:test6"
    "panda:test7"
    "panda:test8"
    "panda:test9"
    "nodeunit:tests"]

  # This test SHOULD fail with the error
  #   >> error parsing YAML in test/fixtures/test10/index.md
  #   Fatal error: JS-YAML: can not read a block mapping entry; a multiline key may not be an implicit key at line 3, column 7:
  #     layout: resource
  grunt.registerTask "badtest", ["clean", "livescript", "panda:test10", "nodeunit:badtest"]

  # By default, lint and run all tests.
  grunt.registerTask "default", ["livescript", "test"]
