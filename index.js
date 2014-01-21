var coffee = require('coffee-script');
var fs = require('fs');
var join = require('path').join;
var fileFun = require('file-fun');

exports.globsToDirWithWatch = fileFun.sync_globsToDirWithWatch(coffee.compile, 'js');
exports.globsToDir = fileFun.sync_globsToDir(coffee.compile, 'js');
exports.fileToFile = fileFun.sync_fileToFile(coffee.compile);
exports.async = fileFun.sync_async(coffee.compile);
exports.sync = coffee.compile;