(function(){
  "use strict";
  var async, pathUtils, spawn, jsy;
  async = require('async');
  pathUtils = require('path');
  spawn = require('child_process').spawn;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var lf, lflf, yamlre;
    lf = grunt.util.linefeed;
    lflf = lf + lf;
    yamlre = /^````$\n^([^`]*)````/m;
    return grunt.registerMultiTask("panda", "Convert documents using pandoc", function(){
      var done, yamlObj, options;
      done = this.async();
      yamlObj = {};
      options = this.options({
        stripMeta: '````',
        separator: lflf,
        process: false,
        infile: "tmp/inputs.md",
        spawnLimit: 1,
        metaDataPath: "metadata.yaml"
      });
      grunt.verbose.writeln("spwanLimit = " + options.spawnLimit);
      if (options.spawnLimit === 1) {
        async.eachSeries(this.files, iterator, writeYAML);
      } else {
        async.eachLimit(this.files, options.spawnLimit, iterator, writeYAML);
      }
      function writeYAML(){
        grunt.file.write(options.metaDataPath, jsy.safeDump(yamlObj));
        return done();
      }
      function iterator(f, callback){
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
        if (options.pandocOptions == null) {
          pandocOptions = outfile.match(/.html$/) ? "-t html5 --section-divs --mathjax" : "-f markdown";
        } else {
          pandocOptions = options.pandocOptions;
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
          if (err) {
            grunt.verbose.writeln('pandoc exited with code ' + err);
          }
          return callback(err);
        });
      }
      function concatenate(fpaths, options){
        var metaDataPath;
        metaDataPath = options.metaDataPath;
        return fpaths.map(function(path){
          var src, ref$, yaml, p, basename, dirname, pathname;
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
            ref$ = stripMeta(path, src, options.stripMeta), yaml = ref$.yaml, src = ref$.md;
          }
          grunt.verbose.writeln("path=" + path + "; yaml = " + yaml);
          p = pathUtils.normalize(path);
          basename = pathUtils.basename(p, '.md');
          dirname = pathUtils.dirname(p);
          pathname = dirname + "/" + basename;
          debugger;
          yamlObj[path] = jsy.safeLoad(yaml);
          return src;
        }).join(options.separator);
      }
      function stripMeta(path, content, delim){
        var matches, yaml, md;
        matches = content.match(yamlre);
        if (matches) {
          yaml = matches[1];
          md = lf + content.substr(matches[0].length);
        } else {
          yaml = "";
          md = lflf + content;
        }
        return {
          yaml: yaml,
          md: md
        };
      }
      return stripMeta;
    });
  };
}).call(this);
