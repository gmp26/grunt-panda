"use strict"
grunt = require "grunt"
jsy = require 'js-yaml'
path = require "path"
postProcess = require "../lib/postProcess.js"

#
#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)
#
exports.panda =
  setUp: (done) ->
    # setup here if necessary
    done()

  test1: (test) ->
    test.expect 1
    actual = grunt.file.read path.normalize "test/actual/test1.html"
    expected = grunt.file.read path.normalize "test/expected/test1.html"
    test.equal actual, expected, "lodash templates should be interpolated, then markdown should compile to html"
    test.done()


  test2: (test) ->
    test.expect 1
    actual = grunt.file.read path.normalize "test/actual/test2.html"
    expected = grunt.file.read path.normalize "test/expected/test2.html"
    test.equal actual, expected, "multiple inputs should concatenate"
    test.done()

  test3: (test) ->
    test.expect 3
    exists = grunt.file.exists path.normalize "test/actual/test3.pdf"
    test.ok(exists, "it should create a pdf")

    actual = grunt.file.read path.normalize "test/actual/test3.html"
    expected = grunt.file.read path.normalize "test/expected/test3.html"
    test.equal actual, expected, "it should create multiple outputs"

    exists = grunt.file.exists path.normalize "test/actual/test3.docx"
    test.ok(exists, "it should create a docx")

    test.done()

  test4: (test) ->
    test.expect 4
    exists = grunt.file.isDir path.normalize "test/actual/test4"
    test.ok(exists, "it should create an output directory")

    actual = grunt.file.read path.normalize "test/actual/test4/test4input1.html"
    expected = grunt.file.read path.normalize "test/expected/test4/test4input1.html"
    test.equal actual, expected, "it should create correct html for each input"

    actual = grunt.file.read path.normalize "test/actual/test4/test4input2.html"
    expected = grunt.file.read path.normalize "test/expected/test4/test4input2.html"
    test.equal actual, expected, "it should create correct html for each input"

    actual = grunt.file.read path.normalize "test/actual/test4/test4input3.html"
    expected = grunt.file.read path.normalize "test/expected/test4/test4input3.html"
    test.equal actual, expected, "it should create correct html for each input"

    test.done()


  test5: (test) ->
    test.expect 2
    exists = grunt.file.exists path.normalize "test/actual/test5/meta.yaml"
    test.ok(exists, "it should create yaml output")

    actual = grunt.file.read path.normalize "test/actual/test5/meta.yaml"
    expected = grunt.file.read path.normalize "test/expected/test5/meta.yaml"
    test.equal actual, expected, "yaml should match expectation"

    test.done()

  test6: (test) ->
    test.expect 2

    exists = grunt.file.exists path.normalize "test/actual/test6/meta.yaml"
    test.ok(exists, "metadata yaml should be merged")

    actual = grunt.file.read path.normalize "test/actual/test6/meta.yaml"
    expected = grunt.file.read path.normalize "test/expected/test6/meta.yaml"
    test.equal actual, expected

    test.done()

  test7: (test) ->
    test.expect 1

    grunt.log.debug "*** test7 ***"

    actual = grunt.file.read path.normalize "test/actual/test7/meta.yaml"
    expected = grunt.file.read path.normalize "test/expected/test7/meta.yaml"
    test.equal actual, expected, "yaml paths should be modified by metaReplace and metaReplacement"

    test.done()

  test8: (test) ->
    test.expect 4

    # should write to grunt config metaDataVar by default
    test.ok grunt.config.get "test8Metadata"

    # metadata file should exist
    actual = grunt.file.read path.normalize "test/actual/test8/meta.yaml"
    expected = grunt.file.read path.normalize "test/expected/test8/meta.yaml"
    test.equal actual, expected, "correct metadata should be generated"

    # metadata file content should equal metadata
    actual2 = jsy.safeLoad grunt.config.get "test8Metadata"
    expected2 = grunt.file.readYAML path.normalize "test/expected/test8/meta.yaml"
    test.deepEqual actual2, expected2, "correct metadata in metadataVar"


    # html should not be generated
    notThere1 = !grunt.file.exists path.normalize "test/actual/test8/test4input1.html"
    notThere2 = !grunt.file.exists path.normalize "test/actual/test8/test4input2.html"
    notThere3 = !grunt.file.exists path.normalize "test/actual/test8/test4input3.html"
    test.ok notThere1 && notThere2 && notThere3, "html should not be generated"

    test.done()

  test9: (test) ->
    test.expect 2

    # metadata file should not exist
    notThere = !grunt.file.exists path.normalize "test/actual/test9/meta.yaml"
    test.ok notThere, "metadata file should not exist"


    # pandoc should have generated html
    there1 = grunt.file.exists path.normalize "test/actual/test9/test4input1.html"
    there2 = grunt.file.exists path.normalize "test/actual/test9/test4input2.html"
    there3 = grunt.file.exists path.normalize "test/actual/test9/test4input3.html"
    test.ok there1 && there2 && there3, "html should be generated"

    test.done()

  test10: (test) ->
    test.expect 1
    notThere = !grunt.file.exists path.normalize "test/actual/test10/meta.yaml"
    test.ok notThere, "metadata file should not exist due to parsing error"
    test.done!
   






