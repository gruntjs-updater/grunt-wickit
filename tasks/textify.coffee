

module.exports = (grunt) ->
  "use strict"

  _ = require("lodash")
  cheerio = require('cheerio')
  path = require('path')

  stopWords = [
    /\ba\b/g
    /\bable\b/g
    /\babout\b/g
    /\bacross\b/g
    /\bafter\b/g
    /\ball\b/g
    /\balmost\b/g
    /\balso\b/g
    /\bam\b/g
    /\bamong\b/g
    /\ban\b/g
    /\band\b/g
    /\bany\b/g
    /\bare\b/g
    /\bas\b/g
    /\bat\b/g
    /\bbe\b/g
    /\bbecause\b/g
    /\bbeen\b/g
    /\bbut\b/g
    /\bby\b/g
    /\bcan\b/g
    /\bcannot\b/g
    /\bcould\b/g
    /\bdear\b/g
    /\bdid\b/g
    /\bdo\b/g
    /\bdoes\b/g
    /\beither\b/g
    /\belse\b/g
    /\bever\b/g
    /\bevery\b/g
    /\bfor\b/g
    /\bfrom\b/g
    /\bgot\b/g
    /\bhad\b/g
    /\bhas\b/g
    /\bhave\b/g
    /\bhe\b/g
    /\bher\b/g
    /\bhers\b/g
    /\bhim\b/g
    /\bhis\b/g
    /\bhow\b/g
    /\bhowever\b/g
    /\bi\b/g
    /\bif\b/g
    /\bin\b/g
    /\binto\b/g
    /\bis\b/g
    /\bit\b/g
    /\bits\b/g
    /\bjust\b/g
    /\bleast\b/g
    /\blet\b/g
    /\blike\b/g
    /\blikely\b/g
    /\bmay\b/g
    /\bme\b/g
    /\bmight\b/g
    /\bmost\b/g
    /\bmust\b/g
    /\bmy\b/g
    /\bneither\b/g
    /\bno\b/g
    /\bnor\b/g
    /\bnot\b/g
    /\bof\b/g
    /\boff\b/g
    /\boften\b/g
    /\bon\b/g
    /\bonly\b/g
    /\bor\b/g
    /\bother\b/g
    /\bour\b/g
    /\bown\b/g
    /\brather\b/g
    /\bsaid\b/g
    /\bsay\b/g
    /\bsays\b/g
    /\bshe\b/g
    /\bshould\b/g
    /\bsince\b/g
    /\bso\b/g
    /\bsome\b/g
    /\bthan\b/g
    /\bthat\b/g
    /\bthe\b/g
    /\btheir\b/g
    /\bthem\b/g
    /\bthen\b/g
    /\bthere\b/g
    /\bthese\b/g
    /\bthey\b/g
    /\bthis\b/g
    /\btis\b/g
    /\bto\b/g
    /\btoo\b/g
    /\btwas\b/g
    /\bus\b/g
    /\bwants\b/g
    /\bwas\b/g
    /\bwe\b/g
    /\bwere\b/g
    /\bwhat\b/g
    /\bwhen\b/g
    /\bwhere\b/g
    /\bwhich\b/g
    /\bwhile\b/g
    /\bwho\b/g
    /\bwhom\b/g
    /\bwhy\b/g
    /\bwill\b/g
    /\bwith\b/g
    /\bwould\b/g
    /\byet\b/g
    /\byou\b/g
    /\byou\b/g
    /#/g
    /\d\.\s*/g
    /\.\s/g
    /\,\s/g
    /\s\s*/g
  ]


  # markdownHelper = (src, options, template, index) ->

  #   pullIndex = (src)->
  #     index = src
  #     for s in stopWords
  #       index = index.replace(s, " ")
  #     index.replace /\n/, " "

  #   wrapLines = (code) ->
  #     out = []
  #     before = codeLines.before
  #     after = codeLines.after
  #     code = code.split("\n")
  #     code.forEach (line) ->
  #       out.push before + line + after

  #     out.join "\n"

  #   html = null
  #   codeLines = options.codeLines
  #   shouldWrap = codeLines and codeLines.before and codeLines.after
  #   if typeof options.highlight is "string"
  #     if options.highlight is "auto"
  #       options.highlight = (code) ->
  #         out = hljs.highlightAuto(code).value
  #         out = wrapLines(out)  if shouldWrap
  #         out
  #     else if options.highlight is "manual"
  #       options.highlight = (code, lang) ->
  #         out = code
  #         try
  #           out = hljs.highlight(lang, code).value
  #         catch e
  #           out = hljs.highlightAuto(code).value
  #         out = wrapLines(out)  if shouldWrap
  #         out
  #   markdown.setOptions options
  #   grunt.verbose.write "Marking down..."
  #   html = markdown(src)
  #   $ = cheerio.load(html);
  #   links = $('a')
  #   for l in links 
  #     linkUrl = url.parse(l.attribs?.href)
  #     if not linkUrl.protocol
  #       #rewrite only relative URLS
  #       linkBasePage = path.basename(linkUrl.path)
  #       # if _.contains options.noConvert, path.extname(linkBasePage)
  #       #   $(l).attr('href', linkBasePage)
  #       # else
  #       $(l).attr('href', linkBasePage + '.html')

  #   doc = _.template template,
  #     content: $.html()
  #   $ = cheerio.load(doc);
  #   console.log $('body').text()
  #   doc

  pullIndex = (src)->
    index = src
    for s in stopWords
      index = index.replace(s, " ")
    index.replace /\n/, " "


  grunt.registerMultiTask "textify", "compiles markdown files into html", ->
    done = this.async()
    config = grunt.config()
    options = @options
      createIndexHtml: false
      template: "template.html"
    options.selector or= 'body'

    index = []

    
    indexPath = options.indexPath
    basePath = path.dirname(options.files.replace('**/*', ''))
    console.log basePath
    grunt.file.expand(options.files).forEach (filepath) ->
      if not grunt.file.isDir(filepath)
        filename = path.relative(basePath, filepath)
        fileContents = grunt.file.read(filepath)
        $ = cheerio.load(fileContents);
        corpus = $(options.selector).text()
        index.push 
          id: filename
          title: $('title').text()
          body: pullIndex(corpus)

    indexDestPath = path.join(options.base, indexPath)
    if grunt.file.exists(indexDestPath) 
      grunt.file.delete(indexDestPath)

    grunt.file.write indexDestPath, "index = " + JSON.stringify(index, null, 2)



    htmlDestPath = path.join(path.dirname(indexDestPath), 'Index.html')
    if grunt.file.exists(htmlDestPath) 
      grunt.file.delete(htmlDestPath)

    if options.createIndexHtml

      siteTemplatePath = path.join(__dirname, 'site-dist')
      console.log siteTemplatePath
      grunt.file.expand(path.join(siteTemplatePath, '**/*')).forEach (filepath) ->
        if not grunt.file.isDir(filepath)
          console.log "copying: #{filepath} to: #{path.relative(siteTemplatePath, filepath)}"
          grunt.file.copy filepath, path.join(path.dirname(indexDestPath), path.relative(siteTemplatePath, filepath))



      template = grunt.file.read(path.join(__dirname, options.template))
      doc = _.template template,
        content: """
        <div class="hero-unit">This page was generated for you.  It provides cross repository search.  Once you navigate to any of the individual repositories, searches will be limited to that repository.  Return here search across repositories</div>
        """
        title: "Index"
      grunt.file.write htmlDestPath, doc

    done()
