(function(){
  "use strict";
  var slice$ = [].slice;
  module.exports = function(grunt){
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
          grunt.fatal("empty store path");
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
          grunt.fatal("data is not an object: " + data);
        }
        names = names.filter(function(name){
          return name && name.length > 0;
        });
        return accPaths(names, data, obj);
      };
      pathToObj(path.split('/'), data, root);
      return store;
    };
    return store;
  };
}).call(this);
