#
# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed under the MIT license.
#
"use strict"

async = require 'async'
pathUtils = require 'path'
#cmdLine   = require('child_process').exec
spawn     = require('child_process').spawn

module.exports = (grunt) ->
  lf = grunt.util.linefeed
  lflf = lf + lf


  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "panda", "Convert documents using pandoc", ->

    # tell grunt this is an asynchronous task
    done = @async!

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      stripMeta: '````'
      separator: lflf
      process: false
      infile: "tmp/inputs.md"
      spawnLimit: 1
    })

    grunt.verbose.writeln "spwanLimit = #{options.spawnLimit}"

    # Iterate over all specified file groups.
    if options.spawnLimit == 1
      async.eachSeries @files, iterator, done
    else
      async.eachLimit @files, options.spawnLimit, iterator, done

    function iterator(f, callback)

      debugger

      fpaths = f.src.filter (path) ->
        unless grunt.file.exists(path)
          grunt.verbose.warn "Input file \"" + path + "\" not found."
          false
        else
          true

      input = concatenate fpaths, options

      infile = options.infile
      outfile = f.dest

      grunt.verbose.writeln "making directory #{pathUtils.dirname(outfile)}"
      grunt.file.mkdir pathUtils.dirname(outfile)

      cmd = "pandoc"
      args = ""
      pandocOptions = "-f markdown"

      if outfile.match /.html$/
        if !options.pandocOptions?
          pandocOptions = "-t html5 --section-divs --mathjax"

      args = "-o #{outfile} #{pandocOptions}".split(" ")

      grunt.verbose.writeln "#cmd #{args.join ' '}"

      child = spawn cmd, args
      child.setEncoding = 'utf-8'

      grunt.verbose.writeln child.stdin.end input

      #grunt.verbose.writeln "write returns: #bufferStatus"


      child.stderr.on 'data', (data) ->
        grunt.verbose.writeln 'stderr: ' + data

      child.stdout.on 'data', (data) ->
        grunt.verbose.writeln 'stdout: ' + data

      child.on 'exit', (err) ->
        grunt.verbose.writeln 'pandoc exited with code ' + err
        callback err
      /*
      if args == ""

        # write the source file
        grunt.verbose.writeln "using intermediate #infile"

        grunt.file.write infile, input

        cmd = "pandoc -o #{outfile} #{pandocOptions} #{infile}"

        grunt.verbose.writeln "running: #cmd"
      */

      /*
      cmdLine cmd, (err, stdout) ->
        if err
          grunt.fatal err
        callback(err)
      */

  function concatenate (fpaths, options)

    fpaths.map((path) ->
      grunt.verbose.writeln "Processing #{path}"

      src = grunt.file.read(path)
      if typeof options.process is "function"
        src = options.process(src, path)
      else
        src = grunt.template.process(src, options.process)  if options.process

      src = stripMeta(path, src, options.stripMeta) if options.stripMeta and options.stripMeta != ""
    ).join(options.separator)

  function stripMeta (path, content, delim)
    # grunt.verbose.writeln("STRIP #{delim} from #{path}")

    eDelim = grunt.util.linefeed + delim + grunt.util.linefeed
    endMeta = content.indexOf eDelim
    if endMeta < 0
      return lflf + content
    else
      startContent = endMeta + eDelim.length
      return lflf + content.substr startContent

