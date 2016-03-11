blessed = require 'blessed'

_ = require 'lodash'
config = require '../config'
{search, album, artist} = require '../api'
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

  searchHeader = blessed.box
    parent: searchBrowser
    height: 1
    width: '100%'
    top: 3
    left: 0
    tags: true

  searchHeader.updateContent = (content) ->
    searchHeader.setContent "{center}#{content}{/}"
    screen.render()

  searchResult = blessed.list
    parent: searchBrowser
    height: "100%-6"
    width: "100%"
    top: 4
    right: 0
    vi: true
    keys: true
    items: []
    interactive: true
    style:
      selected:
        bg: config.primary
        fg: 'white'

  searchResult.on 'select', (item, index) ->
    {type, uri, id, name} = searchResult._results[index]
    if type == 'track' || name == 'Play all'
      play uri, (err, result) ->
        searchResult.pick () -> searchResult.show()
        return if err
    else if type == 'album'
      searchHeader.updateContent 'Loading...'
      album id, (err, result) ->
        return if err
        searchHeader.updateContent "#{result.album.name} - #{_.map(result.album.artists, 'name').join(', ')}"
        searchInput.clearValue()
        searchResult.setItems(_.map(result.items, resultToString))
        searchResult._results = result.items
        searchResult.pick () -> searchResult.show()
    else if type == 'artist'
      searchHeader.updateContent 'Loading...'
      artist id, (err, result) ->
        return if err
        searchHeader.updateContent "#{result.artist.name}"
        searchInput.clearValue()
        searchResult.setItems(_.map(result.items, resultToString))
        searchResult._results = result.items
        searchResult.pick () -> searchResult.show()



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
    tags: true
    border:
      type: 'line'

  searchInput.on 'submit', (keyword) ->
    searchHeader.updateContent 'Loading...'
    search keyword, (err, results) ->
      return if err
      searchHeader.updateContent "Search result of '#{keyword}'"
      searchInput.clearValue()
      searchResult.setItems(_.map(results, resultToString))
      searchResult._results = results
      searchResult.pick () -> searchResult.show()
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
