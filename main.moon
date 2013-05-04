--
-- Unstack2 main.lua




-- Commented out for contest
--require 'lib.game_analytics'
GameAnalytics = {}
-- GameAnalytics.newEventWithoutDelay = GameAnalytics.newEvent
GameAnalytics.newEvent = (category, ...) ->
  opts = ...
  timer.performWithDelay 1, ->
    --analytics.newEventWithoutDelay(category, opts)

export analytics = GameAnalytics
analytics.isDebug = false
analytics.submitSystemInfo = true
analytics.archiveEvents = true
--analytics.init(require('conf.analytics'))

-- log events
analytics.newEvent("design", {event_id: "loading"})

export game = {
  font_size: 16
  level: 0
  lvlString: ->
    string.format('%4.i', game.level)
  score: 0
  running_score: 0 -- to increase the score with some easing

  highscores: require('highscores')
  sounds: require('sounds')

  getTimeRemaining: (now) ->
    return now + 60000

  reset: ->
    game.running = true
    game.running_score = game.score
    game.score_level_start = game.score
    game.time_remaining = nil
}

display.setStatusBar( display.HiddenStatusBar )

export storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true
storyboard.gotoScene("scenes.intro")


