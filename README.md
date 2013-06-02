# grunt-panda

> Compile markdown using pandoc via  the jandoc API

## Getting Started
This plugin requires Grunt `~0.4.1` and a unix shell in which to run [pandoc](http://johnmacfarlane.net/pandoc/README.html).

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

```js
grunt.initConfig({
  panda: {
    options: {
      // See jandoc documentation, and the full list 
      // in node_modules/jandoc/jandoc.js
    },
    files: {
      // Specify src and dest files in the usual grunt manner.
      // Multiple input files (i.e. src files in an array) will be
      // concatenated with a blank line between each file before
      // offering then as a single file to jandoc • pandoc.
    },
  },
})
```

### Options

These are from jandoc - they correspond to pandoc command line options
if you replace camel case option names with hyphenated lower case option names.

 * input: DIR/FILE PATH
 * output: DIR/FILE PATH
 * read: FILE TYPE STRING
 * write: FILE TYPE STRING
 * dataDir: DIR PATH
 * strict: BOOLEAN
 * parseRaw: BOOLEAN
 * smart: BOOLEAN  // refers to smart quotes
 * oldDashes: BOOLEAN
 * baseHeaderLevel: NUMBER
 * indentedCodeClasses: STRING
 * nomalize: BOOLEAN
 * preserveTabs: BOOLEAN
 * tabStop: NUMBER
 * standalone: BOOLEAN
 * template: FILE PATH
 * variable: OBJECT
 * printDefaultTemplate: FILE PATH
 * noWrap: BOOLEAN
 * columns: NUMBER
 * toc: BOOLEAN
 * noHighlight: BOOLEAN
 * highlightStyle: STRING
 * includeInHeader: FILE PATH
 * includeBeforeBody: FILE PATH
 * includeAfterBody: FILE PATH
 * selfContained: BOOLEAN
 * offline: BOOLEAN
 * html5: BOOLEAN
 * ascii: BOOLEAN
 * referenceLinks: BOOLEAN
 * atxHeaders: BOOLEAN
 * chapters: BOOLEAN
 * numberSections: BOOLEAN
 * noTexLigatures: BOOLEAN
 * listings: BOOLEAN
 * incremental: BOOLEAN
 * slideLevel: NUMBER
 * sectionDivs: BOOLEAN
 * emailObfuscation: STRING (none || javascript || references)
 * idPrefix: STRING
 * titlePrefix: STRING
 * css: URL PATH
 * referenceOdt: FILE PATH
 * referenceDocx: FILE PATH
 * epubStylesheet: FILE PATH
 * epubCoverImage: FILE PATH
 * epubMetadata: FILE PATH
 * epubEmbedFont: ARRAY
 * latexEngine: PROGRAM NAME
 * bibliography: FILE PATH
 * csl: FILE PATH
 * citationAbbreviations: FILE PATH
 * natbib: BOOLEAN
 * biblatex: BOOLEAN
 * latexmathml: URL PATH
 * asciimathml: URL PATH
 * mathml: URL PATH
 * mimetex: URL PATH
 * webtex: URL PATH
 * jsmath: URL PATH
 * mathjax: URL PATH
 * gladtex: BOOLEAN
 * dumpArgs: BOOLEAN
 * ignoreArgs: BOOLEAN
 * version: BOOLEAN
 * help: BOOLEAN
 
### Usage Examples

Not yet defined.

### Error handling

To be improved. At the moment the task is likely to terminate if jandoc or pandoc fail.
Use grunt -v for more detailed reporting.

### Code Style

NB. Source is in LiveScript.

In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
