var coffee = require('coffee-script');
var fs = require('fs');
var path = require('path');
var join = require('path').join;
var fileFun = require('file-fun');
var _ = require('lodash');

relativePath = function(origFilePath, filePathToCalculate) {
  var p = path.relative(path.dirname(origFilePath), filePathToCalculate);
  return p.split(path.sep).join('/');
}

exports.file = function(inputFile, outputFile, options, callback) {
  options = options || {};

  var sourceMapFile = null;
  if(options.sourceMap === true) {
    sourceMapFile = outputFile + '.map';
  }
  else if(options.sourceMap) {
    sourceMapFile = options.sourceMap;
  }


  fs.readFile(inputFile, { encoding: 'utf-8' }, function(err, data) {

    var compileOptions = _.clone(options);
    // We can receive a string for the output file, but coffee.compile is expecting just a boolean value
    if(compileOptions.sourceMap) { compileOptions.sourceMap = true; }

    //Allow overriding of sourceFiles option
    if(!compileOptions.sourceFiles) {
      compileOptions.sourceFiles = [ relativePath(sourceMapFile, inputFile) ];
    }

    try {
      res = coffee.compile(data, compileOptions);
    } catch(e) { callback(e); }

    if(!res) { return callback(new Error("No content after compiling coffee")); }

    var output = res.js ? res.js : res;
    var sourceMap = res.v3SourceMap;

    if(sourceMapFile && sourceMap) {
      output = output + '\n/*\n//@ sourceMappingURL=' + relativePath(outputFile, sourceMapFile) + '\n*/\n';
    }
    else if(sourceMapFile && !sourceMap) { return callback(new Error("sourceMapFile defined but no sourceMap content returned")); }



    if(sourceMapFile && sourceMap)  {
      fileFun.mkWriteFiles([[outputFile, output], [sourceMapFile, sourceMap]], callback)
    }
    else {
      fileFun.mkWriteFile(outputFile, output, callback)
    }

  });
}

exports.glob = function(patterns, globOptions, outputDir, options, callback, updateCallback, removeCallback) {
  options = options || {};

  fileFun.glob(patterns, globOptions, outputDir, { extension: 'js', sourceMapDir: options.sourceMapDir, watch: options.watch }, function(inputFile, outputFile, sourceMapFile, cb) {

    var fileFunOptions = _.omit(options, [ 'sourceMapDir', 'watch' ]);
    fileFunOptions.sourceMap = sourceMapFile;

    exports.file(inputFile, outputFile, fileFunOptions, cb);
  }, callback, updateCallback, removeCallback);
}
