# coffee-file-fun

Wrapper functions for the Coffeescript compiler to work with files

## Usage

    result = coffeeFun.sync(coffeeCode, options)

    coffeeFun.async(coffeeCode, options, callback)

    coffeeFun.fileToFile(inputFile, outputFile, options, callback)

    coffeeFun.globsToDir(patterns, globOptions, outputDir, callback)

    coffeeFun.globsToDirWithWatch(patterns, globOptions, outputDir, compileCallback, updateCallback, removedCallback)