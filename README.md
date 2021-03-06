# grunt-panda

> Convert documents (often to/from markdown) using [pandoc](http://johnmacfarlane.net/pandoc/)

## Getting Started
This plugin requires Grunt `~0.4.1` and Pandoc.

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

Since this plugin uses LiveScript, run `grunt livescript` before other tasks. 
Alternatively, run grunt twice. The first time you run it you will probably get an error
that certain javascripts do not yet exist.


```shell
npm install grunt-panda --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of coffeescript:

```coffee
grunt.loadNpmTasks 'grunt-panda'
```

## The "panda" task

### Overview
Panda is a grunt multitask.

In your project's Gruntfile, add a section named `panda` to the data object passed into `grunt.initConfig()`.

```coffee
grunt.initConfig
  panda: 
    options:
      # see below
    files:
      # Specify src and dest files in the usual grunt manner.
      # Multiple input files (i.e. src files in an array) will be
      # concatenated with a blank line between each file before
      # offering them as a single stream to pandoc.
```

### Options

#### infile
Type: `String`

Default: "tmp/inputs.md"

The path of the temporary file used to accumulate multiple input files
that are being concatenated before sending them to pandoc. Relative paths
are relative to the GruntFile location.

#### metaReplace
Type: `String`

Default: null

If the string matches the root of the file path (which usually starts with whatever is
specified in the files cwd option), then this root will be replaced in the output metadata.
The file foo/bar/bat.md normally generates metadata in foo.bar.bat.meta, but if metaReplace
were "foo/", the metadata would appear in bar.bat.meta.

#### metaReplacement
Type: `String`

Default: null

If a valid metaReplace string is given (which can be ""), then that string will be replaced with the
given replacement in the output metadata.
e.g. The file foo/bar/bat.md normally generates metadata in foo.bar.bat.meta, but if metaReplace
were "foo/bar", and metaReplace were "baz", the metadata would appear in baz.bat.meta.

#### pandocOptions
Type: `String` or `Array`

Default: 

- for HTML: "-t html5 --smart --section-divs --mathjax"
- else: "-f markdown --smart"

Can be used to pass any command line options along to pandoc.

If a string, it will be split into arguments on space characters. If an array the arguments will be used as is.

#### separator 
Type: `String`

Default: set to two OS independent line feeds.

The separator to be inserted between input files that are concatenated before 
processing by pandoc.

#### spawnLimit
Type: `Integer > 0`

Default: 1

Limits the number of pandoc child processes that can be spawned at any one time. Increase the number
if you find this helps with performance and if you are not concatenating files into one destination. If you are concatenating markdown, the order is likely to matter and can only be guaranteed when the spawnLimit is 1.

#### stripMeta
Type: `String`

Default: "````"

  If the input files contain metadata in the header, 
  this can be removed by setting here the separator string. 
  This separates the meatadata from the markdown content. 
  The metadata and the separator will be ignored. 
  The separator must start at the beginning of the line. 
  If no separator is seen at all, the whole content will be processed.

#### metaDataPath
Type: `String` a pathname relative to the Gruntfile

Default: none

If `metaDataPath` is defined, any Yaml metadata stripped from file headers is merged and written to that path.

#### metaDataVar
Type: `String` a variable name

Default: 'metadata'

Writes the metadata to this key in the grunt configuration. Later tasks in the grunt chain can read the metadata
with grunt.config.get(options.metaDataVar).

#### metaOnly
Type: `Boolean`

Default: false

Don't run pandoc - only generate metadata.

#### pipeToModule (deprecated)
Type: `String` a node module path

Default: none

If a `pipeToModule` node module path is given, the task will `require` the module. It should return a 
function of one parameter. The task will call that function passing the metadata object as a parameter.
If the module if given as a javascript file name, then the path must be absolute or relative to grunt-panda's Gruntfile.

#### postProcess (deprecated)
Type: `Function` (grunt, metadata) -> metadata

* If a postProcess function is given, panda  passes any generated metadata object to it. The function acts as a filter, returning the metadata object transformed in some way. Typically useful for making future searches faster.

#### process
Type: `Boolean` `Object`

Default: `false`

Process source files as [templates][] before concatenating.

* `false` - No processing will occur.
* `true` - Process source files using [grunt.template.process][] defaults.
* `options` object - Process source files using [grunt.template.process][], using the specified options.
* `function(src, filepath)` - Process source files using the given function, called once for each file. The returned value will be used as source code.

_(Default processing options are explained in the `grunt.template.process` documentation)_

  [templates]: https://github.com/gruntjs/grunt/wiki/grunt.template
  [grunt.template.process]: https://github.com/gruntjs/grunt/wiki/grunt.template#wiki-grunt-template-process


### Usage Examples
```coffee
      test1:
        options:
          process: true
        files:
          "test/actual/test1.html": "test/fixtures/test1.md"

      test2:
        files:
          "test/actual/test2.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test3:
        files:

          "test/actual/test3.pdf": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "test/actual/test3.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "test/actual/test3.docx": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
```

Whole directories of markdown files may be processed using grunt's
multi-file capability.

```coffee
    panda
      test4:
        options:
          spawnLimit: 3
        files: [
          expand: true
          cwd: "test/fixtures/test4"
          src: "**/*.md"
          dest: "test/actual/test4"
          ext: ".html"
        ]
```

If `metaDataPath` is defined, any Yaml metadata stripped from file headers is merged and written to that path.

In addition, or alternatively, you can pipe the metadata to a function returned by a node module specified in `pipeToModule`.

```coffee
    panda
      test6:
        options:
          stripMeta: '````'
          metaDataPath: "test/actual/test6/meta.yaml"
          pipeToModule: '../test/fixtures/test6/nodeModuleToRun.js'

        files: [
          expand: true
          cwd: "test/fixtures"
          src: ["**/test5.md","**/test4/*.md"]
          dest: "test/actual"
          ext: ".html"
        ]
```

File foo/bar/baz metadata will be found in the output yaml as

```yaml
  foo:
    bar:
      baz:
        meta:
          <file metadata inserted here>
```
### Error handling

The task should fail reporting any errors encountered in pandoc.
Use grunt -v for more detailed reporting.

If you do not have Pandoc installed, test1 will fail with:

```
Running "panda:test1" (panda) task
Processing test/fixtures/input.md
format = -t html5
Fatal error: Command failed: /bin/sh: pandoc: command not found
```

You will need TeX to be installed to generate pdfs. See the [Pandoc notes](http://johnmacfarlane.net/pandoc/README.html#creating-a-pdf) on this.

If you do not have a recent unicode aware TeX or LaTeX installed you may need to update. Older installations are likely to generate when running test3:

```
Fatal error: Command failed: pandoc: Error producing PDF from TeX source.
! LaTeX Error: File `ifluatex.sty' not found.
```

### Code Style

NB. Source is in [LiveScript](http://livescript.net/).

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).


## Release History

_version-0.2.9_

* Metadata delimiters now allow trailing white-space

_version-0.2.8_

* Reduced grunt dependency to ~0.4.1 from ~0.4.2

_version-0.2.7_

* Aborts with an error message if there is a YAML error. See `grunt badtest`.

_version-0.2.6_

* Allows an array of pandocOptions.

_version-0.2.5_

* removed debugger leftovers. Yaml detection should now work on windows file too.

_version-0.2.4_

* added metaOnly option which creates only the metadata and does not run pandoc. Useful for 2 pass processing.

* added

_version-0.2.3_

* Metadata is now written to the grunt configuraion variable defined in the metaDataVar option.

_version-0.2.2_

* Added metaReplace and metaReplacement options. These are useful in order to adjust the paths inside metadata
to convenient values no matter where your source markdown lives.

_version-0.2.1_

* Revised behaviour so panda now always generates an aggregate yaml file, optionally passing the file
through a filter before writing it. The filter is typically used by an application to expand the data to speed up future searches - e.g. by making references bidirectional, or preparing contexts for page generation.

_version-0.1.13_

* Removed some debug logging. Revised Getting Started advice. 

_version-0.1.12_

* Fixed bug that meant a write to yaml metadata file had to be configured even though
pipeToModule option was used instead. 

_version-0.1.11_

* Added pipeToModule option to facilitate further processing without the need to write and then read in a metadata file.

_version-0.1.10_

* Removed --section-divs option as it does not play well with raw html. The html nesting ends up broken.

_version-0.1.9_

* Default pandoc options now include -S for typographically correct output.

_version-0.1.8_

* Added ability to extract and merge metadata to yaml file(s).

_version-0.1.7_ 

* Changed test1 so it tests lodash template processing 
* Improved test4 to catch issue 2
* Fixed silly asynchronous bug by piping data direct to pandoc rather than by using
a temporary file.
* Added spawnLimit option to control number of pandoc child processes.
* Changed default options for markdown to html
* Changed stripMeta default to 4 backticks. Backticks play better than dashes when source markdown is previewed without stripping. They are interpreted as a code block in both Github and Pandoc flavour markdown.
* Moved async dependency from developer to user dependencies in package.json

_version-0.1.6_ 

* Tests use normalised pathnmames for Windows compatibility

_version-0.1.5_ 

* Now works with file globbing

_version-0.1.4_ 

* Revised process option description

_version-0.1.3_ 

* Relaxed requirement for metadata heading to start with metadata delimiter.
* Documented missing Pandoc and TeX errors

_version-0.1.2_ 

* Corrected option docs and usage examples

_version-0.1.1_ 

* Clarify purpose in docs

_version-0.1.0_ 

* First release
