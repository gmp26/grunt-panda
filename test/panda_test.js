(function(){
  "use strict";
  var grunt, path;
  grunt = require("grunt");
  path = require("path");
  exports.panda = {
    setUp: function(done){
      return done();
    },
    test1: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read(path.normalize("tmp/test1.html"));
      expected = grunt.file.read(path.normalize("test/expected/test1.html"));
      test.equal(actual, expected, "markdown should compile to html");
      return test.done();
    },
    test2: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read(path.normalize("tmp/test2.html"));
      expected = grunt.file.read(path.normalize("test/expected/test2.html"));
      test.equal(actual, expected, "multiple inputs should concatenate");
      return test.done();
    },
    test3: function(test){
      var exists, actual4, expected4;
      test.expect(3);
      exists = grunt.file.exists(path.normalize("tmp/test3.pdf"));
      test.ok(exists, "it should create a pdf");
      actual4 = grunt.file.read(path.normalize("tmp/test4.html"));
      expected4 = grunt.file.read(path.normalize("test/expected/test4.html"));
      test.equal(actual4, expected4, "it should create multiple outputs");
      exists = grunt.file.exists(path.normalize("tmp/test5.docx"));
      test.ok(exists, "it should create a docx");
      return test.done();
    },
    test4: function(test){
      var exists, actual, expected;
      test.expect(2);
      exists = grunt.file.isDir(path.normalize("tmp/fixtures"));
      test.ok(exists, "it should create an output directory");
      actual = grunt.file.read(path.normalize("tmp/fixtures/input.html"));
      expected = grunt.file.read(path.normalize("test/expected/fixtures/input.html"));
      test.equal(actual, expected, "it should create html for each input");
      return test.done();
    }
  };
}).call(this);
