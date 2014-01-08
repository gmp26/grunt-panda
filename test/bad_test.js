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
    test10: function(test){
      var notThere;
      test.expect(2);
      notThere = !grunt.file.exists(path.normalize("test/actual/test10/meta.yaml"));
      test.ok(notThere, "metadata file should not exist due to parsing error");
      test.throws();
      return test.done();
    }
  };
}).call(this);
