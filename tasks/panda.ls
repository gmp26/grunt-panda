#
# * grunt-panda
# * https://github.com/gmp26/grunt-panda
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed the MIT license.
#
"use strict"

async = require 'async'
pathUtils = require 'path'
spawn = require('child_process').spawn
jsy = require('js-yaml')
makeStore = require('../lib/store.js')

module.exports = (grunt) ->
  lf = grunt.util.linefeed
  lflf = lf + lf
  yamlre = /^````$\n^([^`]*)````/m

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "panda", "Convert documents using pandoc", ->

    # tell grunt this is an asynchronous task
    done = @async!

    meta = makeStore(grunt)

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      stripMeta: '````'
      separator: lflf
      process: false
      infile: "tmp/inputs.md"
      spawnLimit: 1
    })

    #grunt.log.debug "spawnLimit = #{options.spawnLimit}"

    # Iterate over all specified file groups.
    if options.spawnLimit == 1
      async.eachSeries @files, iterator, writeYAML
    else
      async.eachLimit @files, options.spawnLimit, iterator, writeYAML

    function writeYAML
      if options.metaDataPath?
        debugger
        metaData = jsy.safeDump if options.postProcess?
          options.postProcess grunt, meta.root!
        else
          meta.root!
        grunt.file.write options.metaDataPath, metaData

      # deprecated
      if options.pipeToModule?
        pipeTo = require options.pipeToModule
        continuation = pipeTo(grunt)
        continuation(meta.root!)

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
        pandocOptions = if outfile.match /.html$/ then "-t html5 --smart --mathjax" else "-f markdown --smart"
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

      fpaths.map((path) ->
        grunt.verbose.writeln "Processing #{path}"

        src = grunt.file.read(path)
        if typeof options.process is "function"
          src = options.process(src, path)
        else
          src = grunt.template.process(src, options.process)  if options.process

        {yaml:yaml, md:src} = stripMeta(path, src, options.stripMeta) if options.stripMeta and options.stripMeta != ""

        #if options.metaDataPath? && yaml.length > 0
        if (options.metaDataPath? || options.pipeToModule?) && yaml.length > 0
          #grunt.log.debug "path=#path; yaml = #yaml"

          #create object reference from the path
          p = pathUtils.normalize path
          basename = pathUtils.basename p, '.md'
          dirname = pathUtils.dirname p

          metadata = {}
          metadata.meta = jsy.safeLoad yaml
          pathname = (dirname + "/" + basename)

          # replace root of path if necessary
          if options.metaReplace?
            re = new RegExp "^#{options.metaReplace}"
            pathname = pathname.replace re, (options.metaReplacement ? "")

          meta.setPathData pathname, metadata

        return src
      ).join(options.separator)

    function stripMeta (path, content, delim)

      matches = content.match yamlre

      if(matches)
        #grunt.log.debug("#{path} has metadata")
        yaml = matches[1]
        md = lf + content.substr matches[0].length
      else
        #grunt.log.debug("#{path} has no metadata")
        yaml = ""
        md = lflf + content

      return {yaml:yaml, md:md}


