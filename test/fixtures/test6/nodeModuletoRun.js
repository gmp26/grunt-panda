(function(){
  "use strict";
  module.exports = function(grunt){
    var continueProcessing;
    continueProcessing = function(metadata){
      var result, message;
      grunt.log.debug("continuation is running");
      try {
        result = metadata.test.fixtures.test5.meta.id;
        grunt.file.write("test/actual/test6/continuation.txt", "test6: " + result);
      } catch (e$) {
        message = e$.message;
        grunt.log.error("test6 received bad metadata, " + message);
      }
      return 0;
    };
    return continueProcessing;
  };
}).call(this);
