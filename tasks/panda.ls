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
#cmdLine = require('child_process').exec
spawn = require('child_process').spawn
jsy = require('js-yaml')

module.exports = (grunt) ->
  lf = grunt.util.linefeed
  lflf = lf + lf
  yamlre = /^````$\n^([^`]*)````/m

  #
  # Wrap a simple object with some accessor functions so we
  # have somewhere to hang different storage and access mechanisms.
  #
  # examples:
  #   metadata = makeStore()
  #   metadata.setPathData 'foo/bar/index', yamlData
  #

  makeStore =  ->

    root = {}
    store = -> # make it a function in case it's useful to call it ()
    store.root = (data) ->
      return root unless data?
      if typeof data != 'object'
        throw new Error 'store root must be object'
      root := data
      return store

    store.setPathData = (path, data) ->

      accPaths = (names, data, acc) ->

        #console.log "names = #names, acc=#acc"

        if names.length == 0
          throw new Error "empty list"

        if names.length == 1
          acc[names.0] = data
        else
          [head, ...tail] = names
          acc[head] = {} unless acc[head]? || typeof acc[head] == 'object'
          accPaths tail, data, acc[head]

      pathToObj = (names, data, obj) ->
        if typeof data != 'object'
          console.log "data = "+data
          throw new Error 'data must be object'
        names = names.filter (name)->name && name.length > 0
        console.log "names = #names"
        accPaths names, data, obj

      pathToObj (path.split '/'), data, root
      return store

    return store

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "panda", "Convert documents using pandoc", ->

    # tell grunt this is an asynchronous task
    done = @async!

    metadata = makeStore()
    yamlObj = {}

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      stripMeta: '````'
      separator: lflf
      process: false
      infile: "tmp/inputs.md"
      spawnLimit: 1
      metaDataPath: "metadata.yaml"
    })

    grunt.verbose.writeln "spwanLimit = #{options.spawnLimit}"

    # Iterate over all specified file groups.
    if options.spawnLimit == 1
      async.eachSeries @files, iterator, writeYAML
    else
      async.eachLimit @files, options.spawnLimit, iterator, writeYAML

    function writeYAML
      grunt.file.write options.metaDataPath, jsy.safeDump metadata.root!
      done!

    function iterator(f, callback)

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

      if !options.pandocOptions?
        pandocOptions = if outfile.match /.html$/ then "-t html5 --section-divs --mathjax" else "-f markdown"
      else
        pandocOptions = options.pandocOptions

      args = "-o #{outfile} #{pandocOptions}".split(" ")

      grunt.verbose.writeln "#cmd #{args.join ' '}"

      child = spawn cmd, args
      child.setEncoding = 'utf-8'

      grunt.verbose.writeln child.stdin.end input

      child.stderr.on 'data', (data) ->
        grunt.verbose.writeln 'stderr: ' + data

      child.stdout.on 'data', (data) ->
        grunt.verbose.writeln 'stdout: ' + data

      child.on 'exit', (err) ->
        if err
          grunt.verbose.writeln 'pandoc exited with code ' + err
        callback err

    function concatenate (fpaths, options)

      metaDataPath = options.metaDataPath

      fpaths.map((path) ->
        grunt.verbose.writeln "Processing #{path}"

        src = grunt.file.read(path)
        if typeof options.process is "function"
          src = options.process(src, path)
        else
          src = grunt.template.process(src, options.process)  if options.process

        {yaml:yaml, md:src} = stripMeta(path, src, options.stripMeta) if options.stripMeta and options.stripMeta != ""

        grunt.verbose.writeln "path=#path; yaml = #yaml"
        #grunt.verbose.writeln "md = #src"

        #create object reference from the path
        p = pathUtils.normalize path
        basename = pathUtils.basename p, '.md'
        dirname = pathUtils.dirname p
        pathname = (dirname + "/" + basename)
        debugger

        metadata.setPathData path, {meta: yaml}

        yamlObj[path] = jsy.safeLoad yaml


        return src
      ).join(options.separator)

    function stripMeta (path, content, delim)
      #grunt.verbose.writeln("STRIP #{delim} from #{path}")
      #grunt.verbose.writeln("content =  #{content}")

      matches = content.match yamlre

      if(matches)
        yaml = matches[1]
        md = lf + content.substr matches[0].length
      else
        yaml = ""
        md = lflf + content

      return {yaml:yaml, md:md}


