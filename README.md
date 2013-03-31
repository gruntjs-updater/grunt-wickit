# grunt-wickit

A simple plugin to generate static html from a Github wiki repo, including an index for search capability.

## Getting Started

This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-wickit --save-dev
```

One the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-wickit');
```

## The "wickit" task

### Overview
In your project's Gruntfile, add a section named `wickit` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  wickit: {
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
})
```

### Options

#### options.gitUrl
Type: `String`

The url for the Github wiki.  For example, the value for the grunt-wickit wikit would be ```git@github.com:ICGGroup/grunt-wickit.wiki.git```.  **Note:** If not provided, No git repository will be pulled.  This may be helpfule if you want to generate a site based upon arbitrary content.

#### options.gitPath
Type: `String`

The target location for the git pull.  Also, the location used as the source for the conversion.  Even if ```gitUrl``` is not provided, files located in ```gitPath``` will still be converted. 


#### options.sitePath
Type: `String`

The location, relative to the Gruntfile, where the generate site content will be placed.  **Note:** If not provided, no HTML content will be generated.

#### options.sitePath
Type: `String`

The location, relative to the Gruntfile, where the generate site content will be placed

#### options.template
Type: `String`

The template file, relative to the Gruntfile, to be used as a template for the html generation.  The template supports ```<%=title%>```, ```<%=contents%>``` and ```<%=options%>``` placeholders.  ```options``` contains the options from your local Gruntfile, allowing you to pass arbitrary content into the template.

#### options.indexSelector
Type: `String`
Default value: `.content`

The selector to be used when pulling the HTML content that is the basic for the text index.  This allows you to limit the scope of the index to include only content from the markdown documents.

#### options.indexFiles
Type: `String`
Default value: `[sitePath]/**/*.html`

The file spec for the files to be included in the index

#### options.indexFiles
Type: `Boolean`
Default value: false

If true, and index.html file will be created that simply allows search access to the index.  This is nothing fancy, but in certain configurations (see below) can provide a top-level index page that provides search capability across multiple repositories.


### Usage Examples

#### Minimum Configruation

The minimum configuration is simple.   grunt-wickit is designed to provide reasonable defaults to most of the options above.  

```js
grunt.initConfig({
  wickit: {
      wickwiki: {
        options: {
          gitUrl: "git@github.com:ICGGroup/grunt-wickit.wiki.git",
          sitePath: "build/wickit"
        }
      }
  }
})
```

#### Consolidated Index Example

In this example, two repositories are included in the build and a consolidated index is built in the ```build``` directory that covered both repositories.

```js
grunt.initConfig({
  wickit: {
    wickwiki: {
      options: {
        gitUrl: "git@github.com:ICGGroup/grunt-wickit.wiki.git",
        sitePath: "build/wickit"
      }
    },
    other: {
      options: {
        gitUrl: "git@github.com:/other.wiki.git",
        sitePath: "build/other"
      }
    },
    consolidated: {
      options: {
        indexFiles: "build/**/*.html",
        indexPath: "build/index.js",
        createIndexHtml: true        
      }
    }
  }
})
```


## The "thumbify" task

### Overview
In your project's Gruntfile, add a section named `thumbify` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  thumbify: {
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
})
```

### Options

#### options.src
Type: `files`

The grunt file spec for the target files.

#### options.dest
Type: `string`

The destination folder


#### options.urlTransform
Type: `function`

A function that will be called with the file prior to rendering.  This gives you an opportunity to use a local server rather than file based rendering


### Usage Examples

#### Minimum Configruation

The minimum configuration is simple.   

```js
grunt.initConfig({
  thumbify: {
    test: {
      options: {
        src: 'tmp/**/*.html',
        dest: 'thumbs'
      }
    }
  }
})
```

#### Using Transform

In this example, a url transformation is used to direct the rendering to an http:// page rather than a file:// reference

```js
grunt.initConfig({
  thumbify: {
    test: {
      options: {
        src: 'tmp/**/*.html',
        dest: 'thumbs',
        urlTransform: function(f){
          return replace(/tmp/, "http://localhost");
        }
      }
    }
  }
})
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).


