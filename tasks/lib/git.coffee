path = require("path")
fs = require("fs")

module.exports = 
  pull: (grunt, gitUrl, gitPath, callback)->
    
    grunt.file.mkdir(path.dirname(gitPath))

    if fs.existsSync(gitPath)
      grunt.log.writeln "Pulling repository in #{gitPath}"
      grunt.file.setBase(gitPath)
      gitOpts =
        cmd: 'git'
        args: ['pull']

      grunt.util.spawn gitOpts, (error, result, code)->
        if error
          grunt.warn error

        grunt.file.setBase(grunt.wickitBase)
        callback()      
    else
      grunt.log.writeln "Cloning repository into #{gitPath}"
      gitOpts =
        cmd: 'git'
        args: ['clone', gitUrl, gitPath]

      grunt.util.spawn gitOpts, (error, result, code)->
        if error
          grunt.warn error

        grunt.file.setBase(grunt.wickitBase)
        callback()
