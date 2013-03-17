

module.exports = (grunt) ->
  "use strict"

  path = require("path")
  fs = require("fs")
  url = require("url")
  markdown = require("marked")
  hljs = require("highlight.js")
  _ = require("lodash")
  cheerio = require('cheerio')

  markdownHelper = (filename, src, options, template, index) ->

    wrapLines = (code) ->
      out = []
      before = codeLines.before
      after = codeLines.after
      code = code.split("\n")
      code.forEach (line) ->
        out.push before + line + after

      out.join "\n"

    html = null
    codeLines = options.codeLines
    shouldWrap = codeLines and codeLines.before and codeLines.after
    if typeof options.highlight is "string"
      if options.highlight is "auto"
        options.highlight = (code) ->
          out = hljs.highlightAuto(code).value
          out = wrapLines(out)  if shouldWrap
          out
      else if options.highlight is "manual"
        options.highlight = (code, lang) ->
          out = code
          try
            out = hljs.highlight(lang, code).value
          catch e
            out = hljs.highlightAuto(code).value
          out = wrapLines(out)  if shouldWrap
          out
    markdown.setOptions 
      gfm:true
      tables:true
      smartLists: true
      highlight:options.highlight
    grunt.verbose.write "Marking down..."
    html = markdown(src)
    $ = cheerio.load(html);
    # rewrite links
    links = $('a')
    for l in links 
      linkUrl = url.parse(l.attribs?.href)
      if not linkUrl.protocol
        linkBasePage = path.basename(linkUrl.path)
        $(l).attr('href', linkBasePage + '.html')

    # rewrite img tags
    images = $('img')
    for i in images 
      src = url.parse(i.attribs?.src)
      if not src.protocol
        imagePath = path.basename(src.path)
        $(i).attr('src', imagePath)

    doc = _.template template,
      content: $.html()
      title: pullTitle(filename, src)
    $ = cheerio.load(doc);
    doc

  pullTitle = (filename,src)->
    base = path.basename(filename, '.md')
    base = base.replace(/\-(\S)/g, ' $1').replace(/\-\-\-/g, ' - ').replace('.html', '')


  grunt.registerMultiTask "markdown", "compiles markdown files into html", ->
    done = this.async()
    config = grunt.config()
    options = @options
      template: "template.html"


    destPath = options.dest
    # make the wikis directory if not there.
    if grunt.file.exists(destPath) 
      grunt.file.delete(destPath)
    grunt.file.mkdir(destPath)

    siteTemplatePath = path.join(__dirname, 'site-dist')
    console.log siteTemplatePath
    grunt.file.expand(path.join(siteTemplatePath, '**/*')).forEach (filepath) ->
      if not grunt.file.isDir(filepath)
        grunt.file.copy filepath, path.join(destPath, path.relative(siteTemplatePath, filepath))

    extension = options.extenstion or "html"
    template = grunt.file.read(path.join(__dirname, options.template))
    grunt.file.expand(options.files).forEach (filepath) ->
      if not grunt.file.isDir(filepath)
        ext = path.extname(filepath).toLowerCase()
        if ext is '.md'
          console.log "Converting #{filepath}"
          file = grunt.file.read(filepath)
          html = markdownHelper(filepath, file, options, template)
          ext = path.extname(filepath)
          dest = path.join(destPath, path.basename(filepath, ext) + "." + extension)
          grunt.file.write dest, html
        else
          console.log "Copying #{filepath}"
          grunt.file.copy(filepath, path.join(destPath, path.basename(filepath)))
    done()
