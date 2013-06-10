"use strict"
grunt = require "grunt"
path = require "path"

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
