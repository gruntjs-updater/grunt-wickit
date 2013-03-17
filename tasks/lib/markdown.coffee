path = require("path")
fs = require("fs")
url = require("url")
markdown = require("marked")
hljs = require("highlight.js")
_ = require("lodash")
cheerio = require('cheerio')




pullTitle = (filename,src)->
  base = path.basename(filename, '.md')
  base = base.replace(/\-(\S)/g, ' $1').replace(/\-\-\-/g, ' - ').replace('.html', '')

wrapLines = (code) ->
  out = []
  before = codeLines.before
  after = codeLines.after
  code = code.split("\n")
  code.forEach (line) ->
    out.push before + line + after

  out.join "\n"


module.exports = 

  convert: (filename, src, options, template, index) ->
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




