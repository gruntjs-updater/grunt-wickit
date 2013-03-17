

module.exports = (grunt) ->
  "use strict"

  path = require("path")
  fs = require("fs")

  grunt.registerMultiTask "github", "compiles markdown files into html", ->
    done = this.async()
    config = grunt.config()
    options = @options
      default: "test"
    gruntBase =  process.cwd()
    console.log gruntBase
    if not options.dest or not options.gitUrl
      grunt.warn "You must provide a gitUrl and dest"

    else
      targetFolder = path.join(options.base, options.dest)
      grunt.file.mkdir(path.dirname(targetFolder))

      if fs.existsSync(targetFolder)
        grunt.log.writeln "Pulling repository in #{targetFolder}"
        grunt.file.setBase(targetFolder)
        gitOpts =
          cmd: 'git'
          args: ['pull']

        grunt.util.spawn gitOpts, (error, result, code)->
          if error
            grunt.warn error

          grunt.file.setBase(gruntBase)
          done()      
      else
        grunt.log.writeln "Cloning repository into #{targetFolder}"
        gitOpts =
          cmd: 'git'
          args: ['clone', options.gitUrl, targetFolder]

        grunt.util.spawn gitOpts, (error, result, code)->
          if error
            grunt.warn error

          grunt.file.setBase(gruntBase)
          done()      

