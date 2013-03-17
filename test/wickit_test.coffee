"use strict"
grunt = require("grunt")
path = require("path")

#
#  ======== A Handy Little Nodeunit Reference ========
#  https://github.com/caolan/nodeunit
#
#  Test methods:
#    test.expect(numAssertions)
#    test.done()
#  Test assertions:
#    test.ok(value, [message])
#    test.equal(actual, expected, [message])
#    test.notEqual(actual, expected, [message])
#    test.deepEqual(actual, expected, [message])
#    test.notDeepEqual(actual, expected, [message])
#    test.strictEqual(actual, expected, [message])
#    test.notStrictEqual(actual, expected, [message])
#    test.throws(block, [error], [message])
#    test.doesNotThrow(block, [error], [message])
#    test.ifError(value)
#
exports.wickit =
  setUp: (done) ->
    
    # setup here if necessary
    done()

  tearDown: (done) ->
    # setup here if necessary
    console.log "test"
    done()

  default_options: (test) ->
    grunt.file.expand(path.join("test/expected/default/*/**")).forEach (filepath) ->
      rf = path.relative("test/expected/default", filepath)
      test.ok grunt.file.exists(path.join("tmp/default", rf)), "should generate #{rf}"
    
    test.done()

  custom_options: (test) ->
    grunt.file.expand(path.join("test/expected/custom/*/**")).forEach (filepath) ->
      rf = path.relative("test/expected/custom", filepath)
      test.ok grunt.file.exists(path.join("tmp/custom", rf)), "should generate #{rf}"
    test.done()