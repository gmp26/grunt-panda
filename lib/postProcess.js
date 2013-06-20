(function(){
  "use strict";
  module.exports = function(grunt, metadata){
    grunt.log.debug("postProcess called");
    return {
      a: 1,
      b: 2
    };
  };
}).call(this);
