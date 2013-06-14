"use strict"

module.exports = (grunt) ->

  #
  # A dummy node module to be run after grunt panda finishes
  #
  continueProcessing = (metadata) ->

    grunt.log.debug "continuation is running"

    try
      result = metadata.test.fixtures.test5.meta.id # expect it to be 'test5'

      # write it to a file for test purposes
      grunt.file.write "test/actual/test6/continuation.txt", "test6: #result"

    catch {message}
      grunt.log.error "test6 received bad metadata, #message"

    # return success code to caller
    return 0

  return continueProcessing
