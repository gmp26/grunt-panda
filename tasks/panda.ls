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
        grunt.log.writeln "Multiple inputs will be concatenated into one."

        jandoc {
          input: concatenate f.src, options
          output: f.dest
        }

      else
        grunt.log.writeln "Not Array"
        jandoc {
          input: f.src
          output: f.dest
        }

  function concatenate (paths, options)

    /*  
    # Merge task-specific and/or target-specific options with these defaults.
    options = @options(
      separator: grunt.util.linefeed
      banner: ""
      footer: ""
      stripBanners: false
      process: false
    )
    
    # Normalize boolean options that accept options objects.
    options.stripBanners = {}  if options.stripBanners is true
    options.process = {}  if options.process is true
    
    # Process banner and footer.
    banner = grunt.template.process(options.banner)
    footer = grunt.template.process(options.footer)
    
    # Iterate over all src-dest file pairs.
    @files.forEach (f) ->
      
      # Concat banner + specified files + footer.
      
      # Warn on and remove invalid source files (if nonull was set).
      
      # Read file source.
      
      # Process files as templates if requested.
      
      # Strip banners if requested.
      src = banner + f.src.filter((filepath) ->
        unless grunt.file.exists(filepath)
          grunt.log.warn "Source file \"" + filepath + "\" not found."
          false
        else
          true
      ).map((filepath) ->
        src = grunt.file.read(filepath)
        if typeof options.process is "function"
          src = options.process(src, filepath)
        else src = grunt.template.process(src, options.process)  if options.process
        src = comment.stripBanner(src, options.stripBanners)  if options.stripBanners
        src
      ).join(options.separator) + footer
      
      # Write the destination file.
      grunt.file.write f.dest, src
      
      # Print a success message.
      grunt.log.writeln "File \"" + f.dest + "\" created."

    */
