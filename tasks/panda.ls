#
# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed under the MIT license.
# 
"use strict"

async = require 'async'
cmdLine   = require('child_process').exec

module.exports = (grunt) ->
  
  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "panda", "Compile markdown using pandoc via jandoc.", ->
    
    done = @async!

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      stripMeta: "---"
      separator: grunt.util.linefeed + grunt.util.linefeed
      process: false
      infile: "tmp/inputs.md"
      format: ""
      pandocOptions: "--mathjax"
    })

    # Iterate over all specified file groups.
    # Spawn at most 3 child pandoc processes
    async.eachLimit @files, 3, iterator, done

    function iterator(f, callback)

      input = concatenate f.src, options

      infile = options.infile
      outfile = f.dest

      format = if outfile.match /.html$/ then "-t html5" else ""
      format = options.format unless options.format == ""

      grunt.log.writeln "format = #format"

      # write the source file
      grunt.file.write infile, input

      cmd = "pandoc -o #{outfile} #{format} #{options.pandocOptions} #{infile}"
      cmdLine cmd,  (err, stdout) ->
        if err
          grunt.fatal err
        callback(err)

  function concatenate (paths, options)
   
    fpaths = paths.filter (path) ->
      unless grunt.file.exists(path)
        grunt.log.warn "Input file \"" + path + "\" not found."
        false
      else
        true
    
    fpaths.map((path) ->
      grunt.log.writeln "Processing #{path}"

      src = grunt.file.read(path)
      if typeof options.process is "function"
        src = options.process(src, path)
      else 
        src = grunt.template.process(src, options.process)  if options.process
        src = stripMeta(path, src, options.stripMeta)  if options.stripMeta and options.stripMeta != ""
      src
    ).join(options.separator)

  function stripMeta (path, content, delim)
    # grunt.log.writeln("STRIP #{delim} from #{path}")
    return content unless content.indexOf(delim) == 0

    eDelim = grunt.util.linefeed + delim + grunt.util.linefeed
    endMeta = content.indexOf eDelim
    if endMeta < 0
      grunt.log.warn "No metadata end marker in #{path}"
      return content
    else
      startContent = endMeta + eDelim.length
      return content.substr startContent

