

storyboard = require('storyboard')
scene = storyboard.newScene('Level')
widget = require "widget"

debug_level = false

require 'entities.player'
require 'entities.river'

controls = {
  slide_width: math.max(10, display.contentWidth / 16)
  slide_height: math.max(100, display.contentHeight / 4)
  slides_y: display.contentHeight - 40
  slide_color: {200, 200, 200, 255}
  slide_start: {left: nil, right: nil}
}

controls.create = =>
  @group = display.newGroup()
  left = display.newRect( @slide_width * 0.5, @slides_y - @slide_height, @slide_width, @slide_height)
  left.side = 'left'
  left.touch = controls.touch
  left\setFillColor(255,255,255,255)
  right = display.newRect( display.contentWidth - @slide_width * 1.5, @slides_y - @slide_height, @slide_width, @slide_height)
  right.side = 'right'
  right.touch = controls.touch
  right\setFillColor(unpack(@slide_color))

  @group\insert(left)
  @group\insert(right)

  -- connect to player
  left\addEventListener('tap', left)
  left\addEventListener('touch', left)
  right\addEventListener('tap', right)
  right\addEventListener('touch', right)

controls.touch = (event) =>
  side = @side
  if not controls.slide_start[side]
    controls.slide_start[side] = event.y
  elseif event.phase == 'moved'
    1
    -- animate
  elseif event.phase == 'ended' or event.phase == 'cancelled'
    paddle = math.max(controls.slide_height / 4, math.abs(controls.slide_start[side] - event.y))
    if paddle > 0
      scene.player\paddle(side, paddle / controls.slide_height)
      -- visual feedback about controls
      @\setFillColor(unpack(controls.slide_color))
      @transition = true
      @alpha = 1
      transition.from(@, {
        time: math.min(500, paddle * 5),
        alpha: 0
      })
    controls.slide_start[side] = nil

scene.updateClock = =>
  if not @clock_text
    -- create a clock view, gets updated from enterFrame
    @clock_text = display.newText('', display.contentWidth, game.font_size * 1.2, native.systemFontBold, game.font_size)
    @view\insert(@clock_text)
    @clock_text\setReferencePoint(display.TopRightReferencePoint)
  time = math.floor((game.time_remaining / 100))
  if time < 100 -- show a decimal if less than 10 seconds remain
    time = math.floor(time) / 10
  else
    time = math.floor(time / 10)
  progress = math.floor(((@player.position.y - @level.start.y) / (@level.finish - @level.start.y)) * 100)
  @clock_text.text = time .. ' | ' .. string.format('%4.f', progress) .. '%'
  if @clock_text.width
    @clock_text.x = display.contentWidth - @clock_text.width / 2

scene.updateScore = =>
  if not @score_text
    -- create a score view, gets updated from enterFrame
    @score_text = display.newText('', display.contentWidth, 0, native.systemFontBold, game.font_size)
    @view\insert(@score_text)
    @score_text\setReferencePoint(display.TopRightReferencePoint)
  @score_text.text = math.floor(@player.score)
  if @score_text.width
    @score_text.x = display.contentWidth - @score_text.width / 2

scene.enterFrame = (event) =>
  if not game.running
    return
  dt = 0.02

  -- update the remaining time
  if not game.last_event_time
    game.last_event_time = event.time
    game.time_remaining = @level.level.clock * 1000
  game.time_remaining -= (event.time - game.last_event_time)
  game.last_event_time = event.time

  if game.time_remaining < 0
    @endGame()
    return
  scene.player\update(dt)

  if scene.player.position.y >= @level.finish
    @endGame()

  if @player.collided
    @player.position.y += 1
    -- find a new position, move the player and subtract a few points for good measure
    best_x = @level\findBestX(@player.position.y)
    if best_x
      @player.collided = false
      @player.position.x = best_x
      @player\addScore( -10, 'Collsion')
    else
      @endGame()
      return
  else
    score = @level\hasBonusScore(@player.position.x, @player.position.y)
    if score
      bonus_text = display.newText(score, @player_group.x, @game_group.y, native.systemFontBold, game.font_size)
      transition.to(bonus_text, {
          x: display.contentWidth - game.font_size, y: game.font_size / 2,
          time: 1000, onComplete: => @removeSelf() })

      @player\addScore(score, 'Bonus')

  @level\update(dt, scene.player.position)


  @updateClock()
  @updateScore()

  true

scene.endGame = =>
  @end_game_group = display.newGroup()
  @player\addScore(math.floor(game.time_remaining/1000) * 10, 'Time left')
  game.highscores\insert({score: @player.score, date: os.date('%F')})
  game.running = false

  background = display.newRect(display.contentWidth * 0.05, display.contentHeight * 0.15, display.contentWidth * 0.9, display.contentHeight * 0.7)
  background\setFillColor(0,0,0,200)
  @end_game_group\insert(background)

  -- print out what the player did get a score for
  y = display.contentHeight * 0.2
  x = display.contentWidth * 0.2
  for i, score in ipairs(@player.scores)
    if y < display.contentHeight * 0.75
      score, for_what = unpack(score)
      display.newText(@end_game_group, score, x, y, native.systemFontBold, game.font_size)
      display.newText(@end_game_group, for_what, x * 2, y, native.systemFontBold, game.font_size)
      y += game.font_size * 1.2

  y = display.contentHeight * 0.4
  center = display.contentWidth * 0.75
  menu_button = widget.newButton({
    label: "Go To Menu",
    labelColor: { default: {0}, over: {0} },
    top: y,
    onRelease: (event) ->
      storyboard.gotoScene("scenes.menu", "fade", 50)
      analytics.newEvent("design", {event_id: "game:end"})
      return true
  })
  @end_game_group\insert(menu_button)
  menu_button.x = center
  y += menu_button.height * 1.2

  replay_button = widget.newButton({
    label: "Play again",
    top: y,
    labelColor: { default: {0}, over: {0} },
    onRelease: (event) ->
      storyboard.gotoScene('scenes.level', "fade", 100)
      analytics.newEvent("design", {event_id: "level:end"})
      return true
  })
  replay_button.x = center
  @end_game_group\insert(replay_button)
  @view\insert(@end_game_group)
  return true

scene.debug = =>
  if not @debug_group
    @debug_group = display.newGroup()

    @debug_group.player = display.newText(@player\toString(), 5, 0)
    @debug_group\setReferencePoint(display.TopLeftReferencePoint)
    @view\insert(@debug_group)
  else
    @debug_group.player.text = @player\toString()
    @debug_group.player.x = @debug_group.player.width / 2

scene.enterScene = (event) =>
  background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  background\setFillColor(0,0,0,255)
  @view\insert(background)
  if @end_game_group
    @end_game_group\removeSelf()

  header = game.font_size * 2

  @game_group = display.newGroup()
  @game_group.y = header + display.contentHeight / 3
  @view\insert(@game_group)

  @level_group = display.newGroup()
  @level = River(@level_group, 1)
  @game_group\insert(@level_group)
  @player_group = display.newGroup()
  @player_group\scale(@level.scale/2, @level.scale/2)
  @player = Player(@player_group, @level)
  @game_group\insert(@player_group)

  controls\create()
  @view\insert(controls.group)

  -- header
  margin = 2
  restart_button = display.newText('menu', margin, margin, native.systemFontBold, game.font_size)
  restart_button\scale(header / restart_button.height, header / restart_button.height)
  restart_button.y = header / 2
  restart_button.x = header / 2
  @view\insert(restart_button)
  restart_button\addEventListener('tap', -> storyboard.gotoScene('scenes.menu'))

  debug_switch = display.newText("debug", restart_button.width * 1.4, margin, native.systemFontBold, game.font_size*0.8)
  debug_switch\addEventListener('tap', -> scene.level\debug())
  @view\insert(debug_switch)
  debug_switch\toFront()

  timer.performWithDelay 1, -> Runtime\addEventListener("enterFrame", scene)
  if debug_level
    timer.performWithDelay 1, -> Runtime\addEventListener("touch", @level)
  game.running = true
  @

scene.exitScene = (event) =>
  game.running = false
  @level_group\removeSelf()
  if @debug_group
    @debug_group\removeSelf()
    @debug_group = nil
  if @score_text
    @score_text\removeSelf()
    @score_text = nil
  if @clock_text
    @clock_text\removeSelf()
    @clock_text = nil
  @player_group\removeSelf()
  timer.performWithDelay 1, -> Runtime\removeEventListener("enterFrame", scene)
  storyboard.purgeScene()

scene\addEventListener( "exitScene", scene )
scene\addEventListener( "enterScene", scene )

return scene
