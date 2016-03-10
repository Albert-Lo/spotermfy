blessed = require 'blessed'
config = require '../config'

module.exports = (screen) ->
  browser = blessed.box
    top: 0
    left: 0
    width: '100%'
    content: 'This is browser'
    height: "100%-#{config.playerHeight}"
    border:
      type: 'line'

  return browser
