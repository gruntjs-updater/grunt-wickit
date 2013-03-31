path = require("path")
fs = require("fs")
url = require("url")
colors = require("colors")
phantom = require("node-phantom")
path = require("path")
tmp = require("tmp")
_ = require("lodash")
async = require("async")
im = require("imagemagick")

module.exports = (grunt) ->
  "use strict"
  async = grunt.util.async

  grunt.registerMultiTask "thumbify", "Makes thumbnails out of html pages", -> 
    done = this.async()
    config = grunt.config()
    options = @options()
    grunt.thumbifyBase =  process.cwd()

    tmp.dir
      mode: 0o0750
      prefix: "thumbify_"
    , _tempDirCreated = (err, tempDir) ->
      throw err  if err

      phantom.create (err, ph) ->
        ph.createPage (err, page) ->
          page.viewportSize =
            width: 1024
            height: 960

          capturePage = (filepath, callback) ->
            if not grunt.file.isDir(filepath)
              filename = path.relative(path.dirname(options.src.replace('**/*', '')), filepath)          
              if options.urlTransform
                url = options.urlTransform.apply(this, [filepath])
              else
                url = 'file://' + path.resolve(grunt.thumbifyBase, filepath)
              page.open url, -> 
                output = path.resolve(tempDir, filename + ".png")
                thumb = path.resolve(options.dest, filename + ".thumb.png")
                grunt.file.mkdir path.dirname(path.resolve(options.dest,  filename))

                console.log thumb
                console.log "capturing:" + output
                page.render output, (err, results) ->
                  im.resize
                    srcPath: output
                    dstPath: thumb
                    width: 250
                  , (err, results) ->
                    if err
                      callback err
                    else
                      callback null, output
            else 
              callback()

          async.mapSeries grunt.file.expand(options.src), capturePage, (err, results) ->
            console.log err, results
            ph.exit()
            done()






