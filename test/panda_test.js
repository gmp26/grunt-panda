(function(){
  "use strict";
  var grunt;
  grunt = require("grunt");
  exports.panda = {
    setUp: function(done){
      return done();
    },
    test1: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read("tmp/test1.html");
      expected = grunt.file.read("test/expected/test1.html");
      test.equal(actual, expected, "markdown should compile to html");
      return test.done();
    },
    test2: function(test){
      var actual, expected;
      test.expect(1);
      actual = grunt.file.read("tmp/test2.html");
      expected = grunt.file.read("test/expected/test2.html");
      test.equal(actual, expected, "multiple inputs should concatenate");
      return test.done();
    },
    test3: function(test){
      var exists, actual4, expected4;
      test.expect(3);
      exists = grunt.file.exists("tmp/test3.pdf");
      test.ok(exists, "it should create a pdf");
      actual4 = grunt.file.read("tmp/test4.html");
      expected4 = grunt.file.read("test/expected/test4.html");
      test.equal(actual4, expected4, "it should create multiple outputs");
      exists = grunt.file.exists("tmp/test5.docx");
      test.ok(exists, "it should create a docx");
      return test.done();
    }
  };
}).call(this);
