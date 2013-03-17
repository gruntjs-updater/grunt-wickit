path = require("path")
fs = require("fs")
url = require("url")
git = require("./lib/git")
markdown = require("./lib/markdown")
indexify = require("./lib/indexify")
colors = require("colors")
_ = require("lodash")

module.exports = (grunt) ->
  "use strict"
  async = grunt.util.async

  grunt.registerMultiTask "wickit", "compiles markdown files into html", -> 
    done = this.async()
    config = grunt.config()
    options = @options()
    grunt.wickitBase =  process.cwd()


    async.waterfall [
      (callback)->
        # Sometimes you may not want to pull from git, so only do anything if a url is provided    
        if options.gitUrl
          # get the default git path if none is provided
          if options.gitPath
            gitTargetPath = options.gitPath
          else
            gp = url.parse(options.gitUrl).path
            gitTargetPath = path.join('.wikis', path.basename(path.basename(gp, path.extname(gp)), '.wiki'))

          git.pull grunt, options.gitUrl, gitTargetPath, (err)->
            callback(err, gitTargetPath)
        else
          callback(null, null)
    ,
      (gitTargetPath, callback)->
        if options.sitePath and gitTargetPath
          console.log "\nCreating site from markdown".underline
          # make the wikis directory if not there.
          if grunt.file.exists(options.sitePath) 
            grunt.file.delete(options.sitePath)
          grunt.file.mkdir(options.sitePath)

          siteTemplatePath = path.join(__dirname, 'site-dist')
          grunt.file.expand(path.join(siteTemplatePath, '**/*')).forEach (filepath) ->
            if not grunt.file.isDir(filepath)
              grunt.file.copy filepath, path.join(options.sitePath, path.relative(siteTemplatePath, filepath))

          if options.template
            template = grunt.file.read(path.join(grunt.wickitBase, options.template))
          else
            template = grunt.file.read(path.join(__dirname, "template.html"))

          grunt.file.expand(path.join(grunt.wickitBase, path.join(gitTargetPath, "**", "*"))).forEach (filepath) ->
            if not grunt.file.isDir(filepath)
              ext = path.extname(filepath).toLowerCase()
              if ext is '.md'
                console.log "converting >>  ".cyan + path.relative(grunt.wickitBase, filepath)
                file = grunt.file.read(filepath)
                html = markdown.convert(filepath, file, options, template)
                ext = path.extname(filepath)
                dest = path.join(options.sitePath, path.basename(filepath, ext) + ".html")
                grunt.file.write dest, html
              else
                console.log "copying >>  ".yellow + path.relative(grunt.wickitBase, filepath)
                grunt.file.copy(filepath, path.join(options.sitePath, path.basename(filepath)))

          callback()
        else
          callback()

    , (callback)->        

      console.log "\nBuilding site index".underline

      if not options.indexFiles
        options.indexFiles = path.join(options.sitePath, "**", "*.html")

      if not options.indexPath
        options.indexPath = path.join(options.sitePath, "index.js")

      if not options.indexSelector
        options.indexSelector = ".content"

      indexify.build grunt, options.indexFiles, options.indexSelector, (err, index)->
        indexDestPath = path.join(grunt.wickitBase, options.indexPath)

        if grunt.file.exists(indexDestPath) 
          grunt.file.delete(indexDestPath)

        grunt.file.write indexDestPath, "index = " + JSON.stringify(index, null, 2)

        htmlDestPath = path.join(path.dirname(indexDestPath), 'Index.html')
        if grunt.file.exists(htmlDestPath) 
          grunt.file.delete(htmlDestPath)

        if options.createIndexHtml

          siteTemplatePath = path.join(__dirname, 'site-dist')
          grunt.file.expand(path.join(siteTemplatePath, '**/*')).forEach (filepath) ->
            if not grunt.file.isDir(filepath)
              targetFile = path.join(path.dirname(indexDestPath), path.relative(siteTemplatePath, filepath))
              console.log "copying >>  ".cyan + "#{path.relative(grunt.wickitBase, targetFile)}"
              grunt.file.copy filepath, targetFile

          if options.template
            template = grunt.file.read(path.join(grunt.wickitBase, options.template))
          else
            template = grunt.file.read(path.join(__dirname, "template.html"))

            doc = _.template template,
              content: """
              <div class="hero-unit">This page was generated for you.  It provides cross repository search.  Once you navigate to any of the individual repositories, searches will be limited to that repository.  Return here search across repositories</div>
              """
              title: "Index"
            console.log "creating >>  ".yellow + path.relative(grunt.wickitBase, htmlDestPath)
            grunt.file.write htmlDestPath, doc
            

    ], (err)->
      if err
        grunt.fail.fatal err    

      done()
