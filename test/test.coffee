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

  describe 'globsToFiles', ->
    it 'compiles globs to a filelist', (done) ->
      globIn = path.join(__dirname, 'tmp', '*Compile.coffee')
      globIn2 = path.join(__dirname, 'tmp', '*2.coffee')
      outFile1 = path.join(__dirname,'tmp', 'globToFiles1.js')
      outFile2 = path.join(__dirname,'tmp', 'globToFiles2.js')

      coffeeFun.globsToFiles [ globIn, globIn2 ], [ outFile1, outFile2 ], null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ outFile1, outFile2 ])
        expect(fs.readFileSync(outFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(outFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    

    it 'compiles globs to a generated filelist', (done) ->
      globIn = path.join(__dirname, 'tmp', '*Compile.coffee')
      globIn2 = path.join(__dirname, 'tmp', '*2.coffee')
      generateOutfile = (inFile) -> "#{inFile}.globToFiles.js"
      expectedOutFile1 = path.join(__dirname,'tmp', 'toCompile.coffee.globToFiles.js')
      expectedOutFile2 = path.join(__dirname,'tmp', 'toCompile2.coffee.globToFiles.js')

      coffeeFun.globsToFiles [ globIn, globIn2 ], generateOutfile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    

    it 'compiles a glob to a generated filelist',  (done) ->
      globIn = path.join(__dirname, 'tmp', '*.coffee')
      generateOutfile = (inFile) -> "#{inFile}.globToFiles.js"
      expectedOutFile1 = path.join(__dirname,'tmp', 'toCompile.coffee.globToFiles.js')
      expectedOutFile2 = path.join(__dirname,'tmp', 'toCompile2.coffee.globToFiles.js')

      coffeeFun.globsToFiles globIn, generateOutfile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    

    it 'compiles a list of files to filelist',  (done) ->
      outFile1 = path.join(__dirname,'tmp', 'globToFiles5.js')
      outFile2 = path.join(__dirname,'tmp', 'globToFiles6.js')

      coffeeFun.globsToFiles [ toCompileFile, toCompileFile2 ], [ outFile1 , outFile2 ], null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ outFile1 , outFile2 ])
        expect(fs.readFileSync(outFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(outFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    

  describe 'globsToDir', ->
    it 'compiles a glob to a folder'
    it 'compiles globs to a folder'
    it 'compiles a list of files to a folder'
    it 'appends .js extension to files'
