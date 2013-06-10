(function(){
  "use strict";
  var async, pathUtils, spawn;
  async = require('async');
  pathUtils = require('path');
  spawn = require('child_process').spawn;
  module.exports = function(grunt){
    var lf, lflf;
    lf = grunt.util.linefeed;
    lflf = lf + lf;
    grunt.registerMultiTask("panda", "Convert documents using pandoc", function(){
      var done, options;
      done = this.async();
      options = this.options({
        stripMeta: '````',
        separator: lflf,
        process: false,
        infile: "tmp/inputs.md",
        spawnLimit: 1
      });
      grunt.verbose.writeln("spwanLimit = " + options.spawnLimit);
      if (options.spawnLimit === 1) {
        async.eachSeries(this.files, iterator, done);
      } else {
        async.eachLimit(this.files, options.spawnLimit, iterator, done);
      }
      function iterator(f, callback){
        debugger;
        var fpaths, input, infile, outfile, cmd, args, pandocOptions, child;
        fpaths = f.src.filter(function(path){
          if (!grunt.file.exists(path)) {
            grunt.verbose.warn("Input file \"" + path + "\" not found.");
            return false;
          } else {
            return true;
          }
        });
        input = concatenate(fpaths, options);
        infile = options.infile;
        outfile = f.dest;
        grunt.verbose.writeln("making directory " + pathUtils.dirname(outfile));
        grunt.file.mkdir(pathUtils.dirname(outfile));
        cmd = "pandoc";
        args = "";
        pandocOptions = "-f markdown";
        if (outfile.match(/.html$/)) {
          if (options.pandocOptions == null) {
            pandocOptions = "-t html5 --section-divs --mathjax";
          }
        }
        args = ("-o " + outfile + " " + pandocOptions).split(" ");
        grunt.verbose.writeln(cmd + " " + args.join(' '));
        child = spawn(cmd, args);
        child.setEncoding = 'utf-8';
        grunt.verbose.writeln(child.stdin.end(input));
        child.stderr.on('data', function(data){
          return grunt.verbose.writeln('stderr: ' + data);
        });
        child.stdout.on('data', function(data){
          return grunt.verbose.writeln('stdout: ' + data);
        });
        return child.on('exit', function(err){
          grunt.verbose.writeln('pandoc exited with code ' + err);
          return callback(err);
        });
      }
      return iterator;
    });
    function concatenate(fpaths, options){
      return fpaths.map(function(path){
        var src;
        grunt.verbose.writeln("Processing " + path);
        src = grunt.file.read(path);
        if (typeof options.process === "function") {
          src = options.process(src, path);
        } else {
          if (options.process) {
            src = grunt.template.process(src, options.process);
          }
        }
        if (options.stripMeta && options.stripMeta !== "") {
          return src = stripMeta(path, src, options.stripMeta);
        }
      }).join(options.separator);
    }
    function stripMeta(path, content, delim){
      var eDelim, endMeta, startContent;
      eDelim = grunt.util.linefeed + delim + grunt.util.linefeed;
      endMeta = content.indexOf(eDelim);
      if (endMeta < 0) {
        return lflf + content;
      } else {
        startContent = endMeta + eDelim.length;
        return lflf + content.substr(startContent);
      }
    }
    return stripMeta;
  };
}).call(this);
