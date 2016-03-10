_ = require 'lodash'
applescript = require 'applescript'
async = require 'async'

module.exports.current = (cb) ->
  async.parallel
    artist: (pCb) ->
      command =  'tell application "Spotify" to artist of current track as string'
      applescript.execString command, pCb
    album: (pCb) ->
      command = 'tell application "Spotify" to album of current track as string'
      applescript.execString command, pCb
    track: (pCb) ->
      command = 'tell application "Spotify" to name of current track as string'
      applescript.execString command, pCb
    duration: (pCb) ->
      command = 'tell application "Spotify" to duration of current track as string'
      applescript.execString command, pCb
    position: (pCb) ->
      command = 'tell application "Spotify" to player position as string'
      applescript.execString command, pCb
    state: (pCb) ->
      command = 'tell application "Spotify" to player state as string'
      applescript.execString command, pCb
    repeating: (pCb) ->
      command = 'tell application "Spotify" to repeating'
      applescript.execString command, pCb
    shuffling: (pCb) ->
      command = 'tell application "Spotify" to shuffling'
      applescript.execString command, pCb
  , (err, results) ->
    return cb(err) if err
    return cb(null, _.mapValues(results, (result, key) -> _.first(result)))

module.exports.togglePlay = (cb) ->
  command = 'tell application "Spotify" to playpause'
  applescript.execString command, cb

module.exports.toggleRepeat = (cb) ->
  command = 'tell application "Spotify" to set repeating to not repeating'
  applescript.execString command, cb

module.exports.toggleShuffle = (cb) ->
  command = 'tell application "Spotify" to set shuffling to not shuffling'
  applescript.execString command, cb

#current (err, results) ->
  #console.log err
  #console.log results
