"use strict"

module.exports = (grunt) ->

  #
  # Wrap a simple object with some accessor functions so we
  # have somewhere to hang different storage and access mechanisms.
  #
  # example:
  #   meta = makeStore()
  #   meta.setPathData 'foo/bar/index', yamlData
  #
  root = {}
  store = -> # make it a function in case it's useful to call it ()
  store.root = (data) ->
    return root unless data?
    if typeof data != 'object'
      throw new Error 'store root must be object'
    root := data
    return store

  store.setPathData = (path, data) ->

    grunt.log.debug "path=#path"
    grunt.log.debug "data=#data"

    accPaths = (names, data, acc) ->

      grunt.log.debug "accPaths: names = #names"

      if names.length == 0
        throw new Error "empty list"

      if names.length == 1
        acc[names.0] = data
      else
        [head, ...tail] = names
        acc[head] = {} unless acc[head]? || typeof acc[head] == 'object'
        accPaths tail, data, acc[head]

    pathToObj = (names, data, obj) ->
      if typeof data != 'object'
        grunt.warn "data is not an object: #data"
      names = names.filter (name)->name && name.length > 0
      grunt.log.debug "names = #names"
      accPaths names, data, obj

    pathToObj (path.split '/'), data, root
    return store

  return store
