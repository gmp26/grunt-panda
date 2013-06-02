#
# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed under the MIT license.
# 
"use strict"

jandoc = require 'jandoc'
{isType} = require 'prelude-ls'

module.exports = (grunt) ->
  
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "panda", "Compile markdown using pandoc via jandoc.", ->
    
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options!

    grunt.log.writeln "options? = "+options?

    # Iterate over all specified file groups.
    @files.forEach (f) ->

      if is-type "Array" f.src
        grunt.log.writeln "Array"
        jandoc {
          input: f.src[0]
          output: f.dest
        }

      else
        grunt.log.writeln "Not Array"
        jandoc {
          input: f.src
          output: f.dest
        }
