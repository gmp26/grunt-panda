(function(){
  "use strict";
  var async, pathUtils, spawn, jsy, makeStore;
  async = require('async');
  pathUtils = require('path');
  spawn = require('child_process').spawn;
  jsy = require('js-yaml');
  makeStore = require('../lib/store.js');
  module.exports = function(grunt){
    var lf, lflf, yamlre;
    lf = grunt.util.linefeed;
    lflf = lf + lf;
    yamlre = /^````$\n^([^`]*)````/m;
    return grunt.registerMultiTask("panda", "Convert documents using pandoc", function(){
      var done, meta, options;
      done = this.async();
      meta = makeStore(grunt);
      options = this.options({
        stripMeta: '````',
        separator: lflf,
        process: false,
        infile: "tmp/inputs.md",
        spawnLimit: 1,
        metaOnly: false
      });
      grunt.log.debug("options.process = " + options.process);
      if (options.spawnLimit === 1) {
        async.eachSeries(this.files, iterator, writeYAML);
      } else {
        async.eachLimit(this.files, options.spawnLimit, iterator, writeYAML);
      }
      function writeYAML(){
        var metaData, pipeTo, continuation;
        if (options.metaDataPath != null) {
          metaData = jsy.safeDump(options.postProcess != null
            ? options.postProcess(grunt, meta.root())
            : meta.root());
          grunt.file.write(options.metaDataPath, metaData);
        }
        if (options.metaDataVar != null) {
          grunt.config.set(options.metaDataVar, metaData);
        }
        if (options.pipeToModule != null) {
          pipeTo = require(options.pipeToModule);
          continuation = pipeTo(grunt);
          continuation(meta.root());
        }
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
        if (!options.metaOnly) {
          infile = options.infile;
          outfile = f.dest;
          grunt.verbose.writeln("making directory " + pathUtils.dirname(outfile));
          grunt.file.mkdir(pathUtils.dirname(outfile));
          cmd = "pandoc";
          args = "";
          if (options.pandocOptions == null) {
            pandocOptions = outfile.match(/.html$/) ? "-t html5 --smart --mathjax" : "-f markdown --smart";
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
        } else {
          return callback(0);
        }
      }
      function concatenate(fpaths, options){
        return fpaths.map(function(path){
          var src, ref$, yaml, p, basename, dirname, metadata, pathname, re;
          grunt.verbose.writeln("Processing " + path);
          src = grunt.file.read(path);
          debugger;
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
          if ((options.metaDataPath != null || options.pipeToModule != null) && yaml.length > 0) {
            p = pathUtils.normalize(path);
            basename = pathUtils.basename(p, '.md');
            dirname = pathUtils.dirname(p);
            metadata = {};
            metadata.meta = jsy.safeLoad(yaml);
            pathname = dirname + "/" + basename;
            if (options.metaReplace != null) {
              re = new RegExp("^" + options.metaReplace);
              pathname = pathname.replace(re, (ref$ = options.metaReplacement) != null ? ref$ : "");
            }
            meta.setPathData(pathname, metadata);
            if (options.metaOnly) {
              src = "";
            }
          }
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
