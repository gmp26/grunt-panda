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

  test10: (test) ->
    test.expect 2
    notThere = !grunt.file.exists path.normalize "test/actual/test10/meta.yaml"
    test.ok notThere, "metadata file should not exist due to parsing error"
    test.throws()
    test.done!
   






