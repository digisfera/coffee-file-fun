coffee = require('coffee-script')
haveFun = require('have-fun')

exports.stringToString = haveFun.syncToAsync(coffee.compile)
exports.stringToFile = haveFun.stringToWriteFile(exports.stringToString)
exports.fileToFile = haveFun.stringToReadFile(exports.stringToFile)
exports.fileToString = haveFun.stringToReadFile(exports.stringToString)

exports.globsToStrings = haveFun.readFilesToGlobs(haveFun.singleToArray(exports.fileToString))
exports.globsToFiles = haveFun.readFilesToGlobs(haveFun.argToGeneratedOptional(haveFun.singleToArray(exports.fileToFile, [0, 1]), 1, 0, true))
