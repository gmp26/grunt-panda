# grunt-panda

> Convert documents (often to/from markdown) using [pandoc](http://johnmacfarlane.net/pandoc/)

## Getting Started
This plugin requires Grunt `~0.4.1` and Pandoc.

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-panda --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of coffeescript:

```coffee
grunt.loadNpmTasks 'grunt-panda'
```

## The "panda" task

### Overview
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
      # offering then as a single file to pandoc.

```

### Options

#### stripMeta
Type: `String`
Default: "---"

  If the input files contain metadata in the header, 
  this can be removed by setting here the separator string. 
  This separates the meatadata from the markdown content. 
  The metadata and the separator will be ignored. 
  The separator must start at the beginning of the line. 
  If no separator is seen at all, the whole content will be processed.

#### infile
Type: `String`
Default: "tmp/inputs.md"

The path of the temporary file used to accumulate multiple input files
that are being concatenated before sending them to pandoc. Relative paths
are relative to the GruntFile location.

#### pandocOptions
Type: `String`
Default: "--mathjax"

Can be used to pass any other command line options along to pandoc.

#### separator 
Type: `String`
Default: set to two OS independent line feeds.

The separator to be inserted between input files that are concatenated before 
processing by pandoc.

#### process
Type: `Boolean` `Object`
Default: `false`

Process source files as [templates](http://gruntjs.com/configuring-tasks#templates) before concatenating.

### Usage Examples
```coffee
    panda:

      test1:
        options:
          process: false
        files:
          "tmp/test1.html": "test/fixtures/input.md"

      test2:
        options:
          process: false
          pandocOptions: "--mathml"
        files:
          "tmp/test2.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

      test3:
        options:
          process: false
 
        files:
          # Try not to mix output formats in one task like this
          "tmp/test3.pdf": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "tmp/test4.html": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]
          "tmp/test5.docx": [
            "test/fixtures/input1.md"
            "test/fixtures/input2.md"
            "test/fixtures/input3.md"
          ]

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

NB. Source is in LiveScript.

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_version-0.1.3_  Relaxed requirement for metadata heading to start with metadata delimiter.
                 Documented missing Pandoc and TeX errors

_version-0.1.2_  Corrected option docs and usage examples

_version-0.1.1_  Clarify purpose in docs

_version-0.1.0_  First release
