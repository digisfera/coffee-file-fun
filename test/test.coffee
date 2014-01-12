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

  ### Not being exported afterall
  describe 'stringToFile', ->
    it 'compiles a string to a file', (done) ->
      outFile = path.join(__dirname,'tmp', 'stringToFile.js')
      coffeeFun.stringToFile toCompile, outFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(outFile)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()
  ###

  describe 'fileToFile', ->
    it 'compiles a file to a file', (done) ->
      outFile = path.join(__dirname,'tmp', 'fileToFile.js')
      coffeeFun.fileToFile toCompileFile, outFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(outFile)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()

  describe 'fileToDir', ->
    it 'compiles a file to a directory', (done) ->
      outDir = path.join(__dirname,'tmp','fileToDir')
      expectedOutFile = path.join(outDir, 'toCompile.coffee.js')

      coffeeFun.fileToDir toCompileFile, outDir, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(expectedOutFile)
        expect(fs.readFileSync(expectedOutFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()


  ### Not being exported afterall
  describe 'fileToString', ->
    it 'compiles a file to a string', (done) ->
      coffeeFun.fileToString toCompileFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(compiled)
        done()
  ###

  ### Not being exported afterall
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
  ###

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

    it 'compiles a glob to a folder and append extension', (done) ->
      globIn = path.join(__dirname, 'tmp', '*.coffee')
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir')
      
      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFun.globsToDir globIn, outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()

    it 'compiles globs to a folder', (done) ->
      globIn = path.join(__dirname, 'tmp', '*Compile.coffee')
      globIn2 = path.join(__dirname, 'tmp', '*2.coffee')
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir2')

      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFun.globsToDir [ globIn, globIn2 ], outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    


    it 'compiles a list of files to a folder', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir3')

      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFun.globsToDir [ toCompileFile, toCompileFile2 ], outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()    