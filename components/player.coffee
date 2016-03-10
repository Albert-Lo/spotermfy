_ = require 'lodash'
blessed = require 'blessed'

config = require '../config'
{current, togglePlay, toggleRepeat, toggleShuffle} = require '../middleman'

PAUSE_ICON = ""
PLAY_ICON = ""
REPEAT_ICON = ""
SHUFFLE_ICON = ""

buildStautsString = (state) ->
  if state.state == 'playing'
    icon1 = "{#{config.primary}-fg}#{PLAY_ICON}{/}"
  else
    icon1 = PAUSE_ICON

  if state.repeating == 'true'
    icon2 = "{#{config.primary}-fg}#{REPEAT_ICON}{/}"
  else
    icon2 = REPEAT_ICON

  if state.shuffling == 'true'
    icon3 = "{#{config.primary}-fg}#{SHUFFLE_ICON}{/}"
  else
    icon3 = SHUFFLE_ICON

  return [icon1, icon2, icon3].join('  ')

module.exports = (screen) ->
  state =
    track: ''
    artist: ''
    album: ''
    position: ''
    duration: ''
    state: ''
    repeating: 'false'
    shuffling: 'false'

  progressBar = blessed.progressbar
    bottom: 0
    left: 0
    height: 1
    width: '100%'
    value: 0
    orientation: 'horizontal'
    style:
      bar:
        bg: config.primary

  controlStatus = blessed.box
    bottom: 0
    left: 0
    height: 1
    width: '10%'
    tags: true
    content: "#{PAUSE_ICON}  #{REPEAT_ICON}  #{SHUFFLE_ICON}"

  leftBox = blessed.box
    bottom: 0
    left: 0
    width: '100%'
    height: '100%-2'

  rightBox = blessed.box
    bottom: 0
    right: 0
    width: '90%'
    height: 2

  leftBox.append controlStatus
  rightBox.append progressBar

  player = blessed.box
    bottom: 0
    left: 0
    width: '100%'
    height: 100
    height: config.playerHeight
    padding: 1
  
  player.append leftBox
  player.append rightBox

  setInterval ->
    current (err, newState) ->
      return if err
      state = setState(state, newState)
      updateContent state
  , 250

  updateContent = (state) ->
    newContent = "#{state.track}\n#{state.artist}\n#{state.album}\n"
    leftBox.setContent newContent
    progress = (state.position / (state.duration / 1000)) * 100
    progressBar.setProgress progress
    controlStatus.setContent buildStautsString(state)
    
    screen.render()

  screen.key ['p'], ->
    togglePlay (err) ->
      return if err
      newState = {}
      if state.state == 'playing'
        newState.state = 'paused'
      else
        newState.state = 'playing'
      state = setState(state, newState)
      updateContent state

  screen.key ['s'], ->
    toggleShuffle (err) ->
      return if err
      newState = {}
      if state.shuffling == 'true'
        newState.shuffling = 'false'
      else
        newState.shuffling = 'true'
      state = setState(state, newState)
      updateContent state

  screen.key ['r'], ->
    toggleRepeat (err) ->
      return if err
      newState = {}
      if state.repeating == 'true'
        newState.repeating = 'false'
      else
        newState.repeating = 'true'
      state = setState(state, newState)
      updateContent state



  setState = (state, newState) ->
    _.assign state, _.pickBy(newState, (item) -> item)

  return player

