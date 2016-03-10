blessed = require 'blessed'
 
config = require './config'

screen = blessed.screen
  smartCSR: true
  fullUnicode: true

screen.title = 'my window title'

divider = blessed.line
  bottom: config.playerHeight
  orientation: 'horizontal'

browser = require('./components/browser')(screen)
player = require('./components/player')(screen)

#screen.append(browser)
screen.append(divider)
screen.append(player)

screen.key ['escape', 'C-c'], (ch, key) ->
  process.exit(0)

screen.render()

#browser._focusSearch()

screen.key ['f'], ->
  browser._focusSearch()
