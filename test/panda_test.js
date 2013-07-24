(function(){
  "use strict";
  var grunt, jsy, path, postProcess;
  grunt = require("grunt");
  jsy = require('js-yaml');
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
    },
    test7: function(test){
      var actual, expected;
      test.expect(1);
      grunt.log.debug("*** test7 ***");
      actual = grunt.file.read(path.normalize("test/actual/test7/meta.yaml"));
      expected = grunt.file.read(path.normalize("test/expected/test7/meta.yaml"));
      test.equal(actual, expected, "yaml paths should be modified by metaReplace and metaReplacement");
      return test.done();
    },
    test8: function(test){
      var actual, expected, actual2, expected2, notThere1, notThere2, notThere3;
      test.expect(4);
      test.ok(grunt.config.get("test8Metadata"));
      actual = grunt.file.read(path.normalize("test/actual/test8/meta.yaml"));
      expected = grunt.file.read(path.normalize("test/expected/test8/meta.yaml"));
      test.equal(actual, expected, "correct metadata should be generated");
      actual2 = jsy.safeLoad(grunt.config.get("test8Metadata"));
      expected2 = grunt.file.readYAML(path.normalize("test/expected/test8/meta.yaml"));
      test.deepEqual(actual2, expected2, "correct metadata in metadataVar");
      notThere1 = !grunt.file.exists(path.normalize("test/actual/test8/test4input1.html"));
      notThere2 = !grunt.file.exists(path.normalize("test/actual/test8/test4input2.html"));
      notThere3 = !grunt.file.exists(path.normalize("test/actual/test8/test4input3.html"));
      test.ok(notThere1 && notThere2 && notThere3, "html should not be generated");
      return test.done();
    },
    test9: function(test){
      var notThere, there1, there2, there3;
      test.expect(2);
      notThere = !grunt.file.exists(path.normalize("test/actual/test9/meta.yaml"));
      test.ok(notThere, "metadata file should not exist");
      there1 = grunt.file.exists(path.normalize("test/actual/test9/test4input1.html"));
      there2 = grunt.file.exists(path.normalize("test/actual/test9/test4input2.html"));
      there3 = grunt.file.exists(path.normalize("test/actual/test9/test4input3.html"));
      test.ok(there1 && there2 && there3, "html should be generated");
      return test.done();
    }
  };
}).call(this);
