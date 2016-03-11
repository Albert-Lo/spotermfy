blessed = require 'blessed'
config = require '../config'

module.exports = (screen) ->
  searchResult = blessed.list
    #height: '100%-5'
    height: "100%-#{config.playerHeight + 6}"
    width: "100%-#{config.bookmarkWidth + 4}"
    top: 5
    right: 0
    vi: true
    keys: true
    #mouse: true
    items: []
    #alwaysScroll: true
    #baseLimit: 5

    interactive: true
    style:
      selected:
        bg: config.primary
        fg: 'white'

  #searchResult.on 'select', (a, b) ->
    #console.log a
    #console.log b

  #searchResult.key ['o'], ->
    #console.log 'play'

