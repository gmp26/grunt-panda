(function(){
  "use strict";
  var async, pathUtils, cmdLine;
  async = require('async');
  pathUtils = require('path');
  cmdLine = require('child_process').exec;
  module.exports = function(grunt){
    grunt.registerMultiTask("panda", "Convert documents using pandoc", function(){
      var done, options;
      done = this.async();
      options = this.options({
        stripMeta: "---",
        separator: grunt.util.linefeed + grunt.util.linefeed,
        process: false,
        infile: "tmp/inputs.md",
        format: "",
        pandocOptions: "--mathjax"
      });
      async.eachLimit(this.files, 3, iterator, done);
      function iterator(f, callback){
        var fpaths, input, infile, outfile, format, cmd;
        fpaths = f.src.filter(function(path){
          if (!grunt.file.exists(path)) {
            grunt.log.warn("Input file \"" + path + "\" not found.");
            return false;
          } else {
            return true;
          }
        });
        input = concatenate(fpaths, options);
        infile = options.infile;
        outfile = f.dest;
        grunt.log.writeln("making directory " + pathUtils.dirname(outfile));
        grunt.file.mkdir(pathUtils.dirname(outfile));
        format = outfile.match(/.html$/) ? "-t html5" : "";
        if (options.format !== "") {
          format = options.format;
        }
        if (fpaths.length === 1) {
          grunt.log.writeln("writing " + fpaths[0] + " to " + infile);
        }
        grunt.file.write(infile, input);
        cmd = "pandoc -o " + outfile + " " + format + " " + options.pandocOptions + " " + infile;
        grunt.log.writeln("running: " + cmd);
        return cmdLine(cmd, function(err, stdout){
          if (err) {
            grunt.fatal(err);
          }
          return callback(err);
        });
      }
      return iterator;
    });
    function concatenate(fpaths, options){
      return fpaths.map(function(path){
        var src;
        grunt.log.writeln("Processing " + path);
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
        return content;
      } else {
        startContent = endMeta + eDelim.length;
        return content.substr(startContent);
      }
    }
    return stripMeta;
  };
}).call(this);
