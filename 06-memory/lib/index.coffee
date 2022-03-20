fs = require 'fs'
readline =require 'readline'

#Using the readline module to read the file line by line
# and then using the split method to split the line by the space


exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode
  rl = readline.createInterface(fs.createReadStream("#{__dirname}/../data/geo.txt"))
  counter = 0
  rl.on 'line', (input) ->
    line = input.split '\t'
 
    if line[3] == countryCode then counter += +line[1] - +line[0]
    

  rl.on 'close', () ->
    #console.log "test: "+n
    cb null,counter