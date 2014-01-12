coffee = require('coffee-script')
haveFun = require('have-fun')

exports.stringToString = haveFun.syncToAsync(coffee.compile, 2)
#stringToString(js, options, (err, coffee) ->)

exports.stringToFile = haveFun.stringToWriteFile(exports.stringToString, 2, 1)
#stringToString(js, outFilePath, options, (err, outFilePath) ->)

exports.fileToFile = haveFun.stringToReadFile(exports.stringToFile, 0, 3)
#stringToString(inFilePath, outFilePath, options, (err, outFilePath) ->)

exports.fileToString = haveFun.stringToReadFile(exports.stringToString, 0, 2)
#stringToString(inFilePath, options, (err, coffee) ->)



exports.globsToStrings = haveFun.readFilesToGlobs(haveFun.singleToArray(exports.fileToString, 0, 2), 0, 2)
#stringToString(glob|[glob], options, (err, [coffee]) ->)

exports.globsToFiles = haveFun.readFilesToGlobs(haveFun.argToGeneratedOptional(haveFun.singleToArray(exports.fileToFile, [0, 1], 3), 1, 0, true), 0, 3)
#stringToString(glob|[glob], [filePath]|generatorFun, options, (err, [filePath]) ->)

exports.globsToDir = haveFun.readFilesToGlobs(haveFun.singleToArray(haveFun.filePathToDirPath(haveFun.appendExtension(exports.fileToFile, 'js', 1), 1, 0), 0, 3), 0, 3)
#stringToString(glob|[glob], outDirPath, options, (err, [filePath]) ->)
