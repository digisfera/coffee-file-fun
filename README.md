#.js extension is always added to output file
coffeeFun.stringToString(coffeeCode, options, callback)
coffeeFun.stringToFile(coffeeCode, outputFile|generateFun, options, callback)
coffeeFun.fileToFile(inputFile, outputFile|generateFun, options, callback)
coffeeFun.fileToString(inputFile, options, callback)
coffeeFun.globsToStrings([file]|glob|[glob], options, callback)
coffeeFun.globsToDir([file]|glob|[glob], outputDir, callback)
coffeeFun.globsToFiles([file]|glob|[glob], [file]|generateFun, callback)