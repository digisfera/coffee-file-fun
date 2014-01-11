expect = require('chai').expect
path = require('path')
mkdirp = require('mkdirp')
rimraf = require('rimraf')
coffee = require('coffee-script')
fs = require('fs')
coffeeFun = require("../coffee-fun")

describe 'coffee-fun', ->

  toCompile = "0 < x < 1"
  toCompile2 = "0 < x < 2"
  compiled = coffee.compile(toCompile)
  compiled2 = coffee.compile(toCompile2)
  toCompileFile = path.join(__dirname,'tmp','toCompile.coffee')
  toCompileFile2 = path.join(__dirname,'tmp','toCompile2.coffee')

  before (done) ->
    rimraf path.join(__dirname,'tmp'), (err, success) ->
      mkdirp.sync(path.join(__dirname,'tmp'))
      fs.writeFileSync(toCompileFile, toCompile)
      fs.writeFileSync(toCompileFile2, toCompile2)
      done()


  describe 'stringToString', ->
    it 'compiles a string to a string', (done) ->
      coffeeFun.stringToString toCompile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(compiled)
        done()

  describe 'stringToFile', ->
    it 'compiles a string to a file', (done) ->
      outFile = path.join(__dirname,'tmp', 'stringToFile.js')
      coffeeFun.stringToFile toCompile, outFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(outFile)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()      

  describe 'fileToFile', ->
    it 'compiles a file to a file', (done) ->
      outFile = path.join(__dirname,'tmp', 'fileToFile.js')
      coffeeFun.fileToFile toCompileFile, outFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(outFile)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()


  describe 'fileToString', ->
    it 'compiles a file to a string', (done) ->
      coffeeFun.fileToString toCompileFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(compiled)
        done()

  describe 'globsToStrings', ->
    it 'compiles a list of files to strings', (done) ->
      coffeeFun.globsToStrings [ toCompileFile, toCompileFile2 ], null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ compiled, compiled2 ])
        done()

    it 'compiles a glob to strings', (done) ->
      globIn = path.join(__dirname, 'tmp', '*.coffee')
      coffeeFun.globsToStrings globIn, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ compiled, compiled2 ])
        done()

    it 'compiles globs to strings', (done) ->
      globIn = path.join(__dirname, 'tmp', '*Compile.coffee')
      globIn2 = path.join(__dirname, 'tmp', '*2.coffee')
      coffeeFun.globsToStrings [ globIn, globIn2 ], null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ compiled, compiled2 ])
        done()

    it 'does not compile file twice if it is matched on two globs', (done) ->
      globIn = path.join(__dirname, 'tmp', '*Compile.coffee')
      globIn2 = path.join(__dirname, 'tmp', '*.coffee')
      coffeeFun.globsToStrings [ globIn, globIn2 ], null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ compiled, compiled2 ])
        done()

  describe 'globsToDir', ->
    it 'compiles a glob to a folder'
    it 'compiles globs to a folder'
    it 'compiles a list of files to a folder'

  describe 'globsToFiles', ->
    it 'compiles globs to a filelist'
    it 'compiles globs to a generated filelist'
    it 'compiles a glob to a generated filelist'
    it 'compiles a list of files to filelist'