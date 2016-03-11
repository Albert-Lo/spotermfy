blessed = require 'blessed'

_ = require 'lodash'
config = require '../config'
{search} = require '../api'
{play} = require '../middleman.coffee'

RESULT_ICONS =
  artist: ''
  album: ''
  track: ''

resultToString = (result) ->
  return "#{RESULT_ICONS[result.type]}  #{result.name}"

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


  searchBrowser = blessed.box
    parent: browser
    top: 0
    right: 0
    width: "100%-#{config.bookmarkWidth + 4}"
    height: '100%'

  searchResult = blessed.list
    parent: searchBrowser
    height: "100%-5"
    width: "100%"
    top: 3
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

  searchResult.on 'select', (a, index) ->
    #console.log index

  searchResult.key ['o'], ->
    #console.log searchResult.getScroll()
    #console.log 'play'
    uri = searchResult._results[searchResult.getScroll()].uri
    play uri, (err, result) ->
      return if err

    

  searchInput = blessed.textbox
    parent: searchBrowser
    left: 0
    top: 0
    width: '100%'
    height: 3
    inputOnFocus: true
    border:
      type: 'line'

  searchInput.on 'submit', (keyword) ->
    search keyword, (err, results) ->
      return if err
      searchInput.clearValue()
      searchResult.setItems(_.map(results, resultToString))
      searchResult._results = results
      searchResult.pick (n) -> n
    #bookmark.searchfocus()
    #searchResult
    #console.log event


  #search.append(searchInput)


  #browser.append(bookmark)
  #browser.append(search)
  #browser.append(divider)

  browser._focusSearch = ->
    searchInput.focus()

  return browser
