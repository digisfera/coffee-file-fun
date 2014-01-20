coffee = require('coffee-script')
fs = require('fs')
join = require('path').join
fileFun = require('file-fun')

# coffee.compile(jsString, options, callback)
exports.globsToDirWithWatch = fileFun.sync_globsToDirWithWatch(coffee.compile, 'js')
exports.globsToDir = fileFun.sync_globsToDir(coffee.compile, 'js')
exports.fileToFile = fileFun.sync_fileToFile(coffee.compile)
exports.async = fileFun.sync_async(coffee.compile)
exports.sync = coffee.compile