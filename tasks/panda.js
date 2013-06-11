(function(){
  "use strict";
  var async, pathUtils, spawn, jsy, slice$ = [].slice;
  async = require('async');
  pathUtils = require('path');
  spawn = require('child_process').spawn;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var lf, lflf, yamlre, makeStore;
    lf = grunt.util.linefeed;
    lflf = lf + lf;
    yamlre = /^````$\n^([^`]*)````/m;
    makeStore = function(){
      var root, store;
      root = {};
      store = function(){};
      store.root = function(data){
        if (data == null) {
          return root;
        }
        if (typeof data !== 'object') {
          throw new Error('store root must be object');
        }
        root = data;
        return store;
      };
      store.setPathData = function(path, data){
        var accPaths, pathToObj;
        accPaths = function(names, data, acc){
          var head, tail;
          if (names.length === 0) {
            throw new Error("empty list");
          }
          if (names.length === 1) {
            return acc[names[0]] = data;
          } else {
            head = names[0], tail = slice$.call(names, 1);
            if (!(acc[head] != null || typeof acc[head] === 'object')) {
              acc[head] = {};
            }
            return accPaths(tail, data, acc[head]);
          }
        };
        pathToObj = function(names, data, obj){
          if (typeof data !== 'object') {
            console.log("data = " + data);
            throw new Error('data must be object');
          }
          names = names.filter(function(name){
            return name && name.length > 0;
          });
          console.log("names = " + names);
          return accPaths(names, data, obj);
        };
        pathToObj(path.split('/'), data, root);
        return store;
      };
      return store;
    };
    return grunt.registerMultiTask("panda", "Convert documents using pandoc", function(){
      var done, metadata, yamlObj, options;
      done = this.async();
      metadata = makeStore();
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
        grunt.file.write(options.metaDataPath, jsy.safeDump(metadata.root()));
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
          metadata.setPathData(path, {
            meta: yaml
          });
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
