(function(){
  "use strict";
  var grunt, path, postProcess;
  grunt = require("grunt");
  path = require("path");
  postProcess = require("../lib/postProcess.js");
  exports.panda = {
    setUp: function(done){
      return done();
    },
    test1: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read(path.normalize("test/actual/test1.html"));
      expected = grunt.file.read(path.normalize("test/expected/test1.html"));
      test.equal(actual, expected, "lodash templates should be interpolated, then markdown should compile to html");
      return test.done();
    },
    test2: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read(path.normalize("test/actual/test2.html"));
      expected = grunt.file.read(path.normalize("test/expected/test2.html"));
      test.equal(actual, expected, "multiple inputs should concatenate");
      return test.done();
    },
    test3: function(test){
      var exists, actual, expected;
      test.expect(3);
      exists = grunt.file.exists(path.normalize("test/actual/test3.pdf"));
      test.ok(exists, "it should create a pdf");
      actual = grunt.file.read(path.normalize("test/actual/test3.html"));
      expected = grunt.file.read(path.normalize("test/expected/test3.html"));
      test.equal(actual, expected, "it should create multiple outputs");
      exists = grunt.file.exists(path.normalize("test/actual/test3.docx"));
      test.ok(exists, "it should create a docx");
      return test.done();
    },
    test4: function(test){
      var exists, actual, expected;
      test.expect(4);
      exists = grunt.file.isDir(path.normalize("test/actual/test4"));
      test.ok(exists, "it should create an output directory");
      actual = grunt.file.read(path.normalize("test/actual/test4/test4input1.html"));
      expected = grunt.file.read(path.normalize("test/expected/test4/test4input1.html"));
      test.equal(actual, expected, "it should create correct html for each input");
      actual = grunt.file.read(path.normalize("test/actual/test4/test4input2.html"));
      expected = grunt.file.read(path.normalize("test/expected/test4/test4input2.html"));
      test.equal(actual, expected, "it should create correct html for each input");
      actual = grunt.file.read(path.normalize("test/actual/test4/test4input3.html"));
      expected = grunt.file.read(path.normalize("test/expected/test4/test4input3.html"));
      test.equal(actual, expected, "it should create correct html for each input");
      return test.done();
    },
    test5: function(test){
      var exists, actual, expected;
      test.expect(2);
      exists = grunt.file.exists(path.normalize("test/actual/test5/meta.yaml"));
      test.ok(exists, "it should create yaml output");
      actual = grunt.file.read(path.normalize("test/actual/test5/meta.yaml"));
      expected = grunt.file.read(path.normalize("test/expected/test5/meta.yaml"));
      test.equal(actual, expected, "yaml should match expectation");
      return test.done();
    },
    test6: function(test){
      var exists, actual, expected;
      test.expect(2);
      exists = grunt.file.exists(path.normalize("test/actual/test6/meta.yaml"));
      test.ok(exists, "metadata yaml should be merged");
      actual = grunt.file.read(path.normalize("test/actual/test6/meta.yaml"));
      expected = grunt.file.read(path.normalize("test/expected/test6/meta.yaml"));
      test.equal(actual, expected);
      return test.done();
    }
  };
}).call(this);
