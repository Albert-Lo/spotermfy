blessed = require 'blessed'

screen = blessed.screen
  smartCSR: true
  fullUnicode: true

screen.title = 'my window title'

#box = blessed.box
  #top: 'center'
  #left: 'center'
  #width: '50%'
  #height: '50%'
  #content: 'Hello {bold}world{/bold}!'
  #tags: true


browser = require('./components/browser')(screen)
player = require('./components/player')(screen)

screen.append(browser)
screen.append(player)

screen.key ['escape', 'C-c'], (ch, key) ->
  process.exit(0)

screen.render()
