through2 = require 'through2'
util = require('util')


module.exports = (options) ->
  words = 0
  chars = 0
  bytes = 0
  lines = 1

  transform = (chunk, encoding, cb) ->
    chars += chunk.length
    bytes += new util.TextEncoder().encode(chunk).length

    chunk = chunk.split('\n')
    if chunk[chunk.length-1] == ""
      chunk.pop()

    lines = chunk.length

    for c in chunk
      
      if c[0] == '"' && c[c.length-1] == '"'
        words += 1
        continue

      if c != c.toUpperCase()
        c = camelToSentence(c)
      tokens = c.split(' ')
      words += tokens.length
    return cb()

  flush = (cb) ->
    obj = {words, lines}
    if options && options.charCount
      obj['chars'] = chars 
    if options && options.byteCount
      obj['bytes'] = bytes

    this.push obj
    this.push null
    return cb()

  return through2.obj transform, flush

camelToSentence = (word) ->
  return word.replace(/[A-Z]/g, (v, i) ->
    if i == 0
      return v
    return " " + v
  )