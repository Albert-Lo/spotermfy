blessed = require 'blessed'
config = require '../config'

module.exports = (screen) ->
  browser = blessed.box
    parent: screen
    top: 0
    left: 0
    width: '100%'
    height: "100%-#{config.playerHeight}"
    padding: 1

  bookmark = blessed.box
    parent: browser
    top: 0
    left: 0
    width: config.bookmarkWidth

  divider = blessed.line
    parent: browser
    left: config.bookmarkWidth
    orientation: 'vertical'


  search = blessed.box
    parent: browser
    top: 0
    right: 0
    width: "100%-#{config.bookmarkWidth + 4}"
    height: '100%'

  searchInput = blessed.textbox
    parent: search
    left: 0
    top: 0
    width: '100%'
    height: 3
    inputOnFocus: true
    border:
      type: 'line'

  searchInput.on 'submit', (event) ->
    bookmark.focus()
    #console.log event


  #search.append(searchInput)


  #browser.append(bookmark)
  #browser.append(search)
  #browser.append(divider)

  browser._focusSearch = ->
    searchInput.focus()

  return browser
