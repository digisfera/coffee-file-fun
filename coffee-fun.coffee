coffee = require('coffee-script')
haveFun = require('have-fun')

exports.globsToDir = haveFun.fromStringSync.globsToDir(coffee.compile, 'js', 0, 2)
exports.globsToFiles = haveFun.fromStringSync.globsToFiles(coffee.compile, 0, 2)
exports.fileToDir = haveFun.fromStringSync.fileToDir(coffee.compile, 'js', 0, 2)
exports.fileToFile = haveFun.fromStringSync.fileToFile(coffee.compile, 0, 2)
exports.stringToString = haveFun.primitives.syncToAsync(coffee.compile, 2)