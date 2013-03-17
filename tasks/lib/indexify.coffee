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

  pullIndex = (src)->
    index = src
    for s in stopWords
      index = index.replace(s, " ")
    index.replace /\n/, " "


  module.exports = 

    build: (grunt, src, selector, callback)->
      index = []
      grunt.file.expand(src).forEach (filepath) ->
        if not grunt.file.isDir(filepath)
          filename = path.relative(path.dirname(src.replace('**/*', '')), filepath)
          fileContents = grunt.file.read(filepath)
          $ = cheerio.load(fileContents);
          corpus = $(selector).text()
          index.push 
            id: filename
            title: $('title').text()
            body: pullIndex(corpus)


      callback(null, index)