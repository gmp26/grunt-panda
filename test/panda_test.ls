"use strict"
grunt = require("grunt")

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

  default_options: (test) ->
    test.expect 1
    actual = grunt.file.read("tmp/output.html")
    expected = grunt.file.read("test/expected/output.html")
    test.equal actual, expected, "markdown should compile to html"
    test.done()

  multiples: (test) ->
    test.expect 1
    actual = grunt.file.read("tmp/mutliples.html")
    expected = grunt.file.read("test/expected/multiples.html")
    test.equal actual, expected, "multiple inputs should concatenate"
    test.done()
