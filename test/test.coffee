expect = require('chai').expect
path = require('path')
mkdirp = require('mkdirp')
rimraf = require('rimraf')
coffee = require('coffee-script')
fs = require('fs')
coffeeFiles = require("../index")

describe 'coffee-files', ->

  toCompile = "0 < x < 1"
  toCompile2 = "0 < x < 2"
  toCompile3 = "0 < x < 3"
  compiled = coffee.compile(toCompile)
  compiled2 = coffee.compile(toCompile2)
  compiled3 = coffee.compile(toCompile3)
  basePath = path.join(__dirname,'tmp')
  toCompileFile = path.join(basePath,'toCompile.coffee')
  toCompileFile2 = path.join(basePath,'toCompile2.coffee')
  toCompileFile3 = path.join(basePath,'subdir','toCompile3.coffee')
  toCompileFileRelative = 'toCompile.coffee'
  toCompileFileRelative2 = 'toCompile2.coffee'
  toCompileFileRelative3 = path.join('subdir','toCompile3.coffee')

  before (done) ->
    rimraf path.join(__dirname,'tmp'), (err, success) ->
      mkdirp.sync(path.join(__dirname,'tmp'))
      mkdirp.sync(path.join(__dirname,'tmp','subdir'))
      fs.writeFileSync(toCompileFile, toCompile)
      fs.writeFileSync(toCompileFile2, toCompile2)
      fs.writeFileSync(toCompileFile3, toCompile3)
      done()


  describe 'fileToFile', ->
    it 'compiles a file to a file', (done) ->
      outFile = path.join(__dirname,'tmp', 'fileToFile.js')
      coffeeFiles.file toCompileFile, outFile, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.equal(outFile)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        done()

    it 'generates a source map', (done) ->
      outFile = path.join(__dirname,'tmp', 'fileToFile2.js')
      outSourceMap = path.join(__dirname,'tmp', 'fileToFile2.js.map')
      coffeeFiles.file toCompileFile, outFile, { sourceMap: true }, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ outFile, outSourceMap ])
        #expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})?.length).to.be.greaterThan(0)
        expect(fs.readFileSync(outSourceMap, { encoding: 'utf-8'})?.length).to.be.greaterThan(0)
        done()

    it 'generates source map with paths using "/"', (done) ->
      outFile = path.join(__dirname,'tmp', 'built', 'fileToFile2.js')
      outSourceMap = path.join(__dirname,'tmp', 'built', 'map', 'fileToFile2.js.map')
      coffeeFiles.file toCompileFile, outFile, { sourceMap: outSourceMap }, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ outFile, outSourceMap ])
        #expect(fs.readFileSync(outFile, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(outFile, { encoding: 'utf-8'})?.length).to.be.greaterThan(0)
        expect(fs.readFileSync(outSourceMap, { encoding: 'utf-8'})?.length).to.be.greaterThan(0)
        #TODO: check paths
        done()

    it 'should work without `options` argument'
    it 'should work without `callback` argument'


  describe 'globsToDir', ->

    it 'compiles a glob to a folder and append extension', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir')
      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFiles.glob '*.coffee', { cwd: basePath }, outputFolder, {  }, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()
    it 'compiles globs to a folder', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir2')
      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFiles.glob [ '*Compile.coffee', '*2.coffee' ], { cwd: basePath }, outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()

    it 'compiles a list of files to a folder', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir3')
      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')

      coffeeFiles.glob [ toCompileFileRelative, toCompileFileRelative2 ], { cwd: basePath }, outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        done()

    it 'should mirror directory structure', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir4')

      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')
      expectedOutFile3 = path.join(outputFolder, 'subdir', 'toCompile3.coffee.js')

      coffeeFiles.glob [ toCompileFileRelative, toCompileFileRelative2, toCompileFileRelative3 ], { cwd: basePath }, outputFolder, null, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ expectedOutFile1, expectedOutFile2, expectedOutFile3 ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'})).to.equal(compiled)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'})).to.equal(compiled2)
        expect(fs.readFileSync(expectedOutFile3, { encoding: 'utf-8'})).to.equal(compiled3)
        done()


    it 'generates source maps', (done) ->
      outputFolder = path.join(__dirname, 'tmp', 'globsToDir')
      expectedOutFile1 = path.join(outputFolder, 'toCompile.coffee.js')
      expectedOutSourceMap1 = path.join(outputFolder, 'maps', 'toCompile.coffee.map')
      expectedOutFile2 = path.join(outputFolder, 'toCompile2.coffee.js')
      expectedOutSourceMap2 = path.join(outputFolder, 'maps', 'toCompile2.coffee.map')

      coffeeFiles.glob '*.coffee', { cwd: basePath }, outputFolder, { sourceMapDir: path.join(outputFolder, 'maps') }, (err, result) ->
        expect(err).to.be.not.ok
        expect(result).to.eql([ [expectedOutFile1, expectedOutSourceMap1], [expectedOutFile2, expectedOutSourceMap2] ])
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'}).indexOf(compiled)).to.equal(0)
        expect(fs.readFileSync(expectedOutFile1, { encoding: 'utf-8'}).indexOf("sourceMappingURL")).to.not.equal(-1)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'}).indexOf(compiled2)).to.equal(0)
        expect(fs.readFileSync(expectedOutFile2, { encoding: 'utf-8'}).indexOf("sourceMappingURL")).to.not.equal(-1)
        done()



