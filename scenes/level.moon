

storyboard = require('storyboard')
scene = storyboard.newScene('Level')
widget = require "widget"

font_size = math.min(32, math.floor(display.contentWidth * 0.1)) - 2
debug_level = false

require 'entities.player'
require 'entities.river'

controls = {
  slide_width: math.max(10, display.contentWidth / 8)
  slide_height: math.max(100, display.contentHeight / 4)
  slides_y: display.contentHeight - 40
  slide_color: {200, 200, 200, 255}
  slide_start: {left: nil, right: nil}
}

controls.create = =>
  @group = display.newGroup()
  left = display.newRect( 8, @slides_y - @slide_height, @slide_width, @slide_height)
  left.side = 'left'
  left.touch = controls.touch
  left\setFillColor(255,255,255,255)
  right = display.newRect( display.contentWidth - @slide_width - 8, @slides_y - @slide_height, @slide_width, @slide_height)
  right.side = 'right'
  right.touch = controls.touch
  right\setFillColor(unpack(@slide_color))

  @group\insert(left)
  @group\insert(right)

  -- connect to player
  left\addEventListener('touch', left)
  right\addEventListener('touch', right)

controls.touch = (event) =>
  side = @side
  if not controls.slide_start[side]
    controls.slide_start[side] = event.y
  elseif event.phase == 'moved'
    1
    -- animate
  elseif event.phase == 'ended' or event.phase == 'cancelled'
    paddle = math.abs(controls.slide_start[side] - event.y)
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

scene.updateScore = =>
  if not @score_text
    -- create a score view, gets updated from enterFrame
    @score_text = display.newText('', display.contentWidth, 0, native.systemFontBold, font_size)
    @view\insert(@score_text)
    @score_text\setReferencePoint(display.TopRightReferencePoint)
  @score_text.text = math.floor(@player.score)
  if @score_text.width
    @score_text.x = display.contentWidth - @score_text.width / 2

scene.enterFrame = (event) =>
  if not game.running
    return
  dt = 0.02

  scene.player\update(dt)
  if scene.player.position.y >= @level.finish

    game.highscores\insert({score: @player.score, date: os.date('%F')})
    game.running = false

    background = display.newRect(display.contentWidth * 0.05, display.contentHeight * 0.1, display.contentWidth * 0.9, display.contentHeight * 0.8)
    background\setFillColor(0,0,0,200)
    @view\insert(background)
    menu_button = widget.newButton({
      label: "Go To Menu",
      labelColor: { default: {0}, over: {0} },
      onRelease: (event) ->
        storyboard.gotoScene("scenes.menu", "fade", 50)
        analytics.newEvent("design", {event_id: "game:end"})
        return true
    })
    @view\insert(menu_button)
    menu_button.y = display.contentHeight * 0.4
    menu_button.x = display.contentWidth / 2



  if scene.player.collided
    game.running = false
    game.highscores\insert({score: @player.score, date: os.date('%F')})
    storyboard.gotoScene('scenes.level')
    return
  @level\update(dt, scene.player.position)

  --scene\debug()

  @updateScore()

  true

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

  header = math.min(32, display.contentHeight * 0.1)

  @game_group = display.newGroup()
  @game_group.y = header
  @view\insert(@game_group)

  @level_group = display.newGroup()
  @level = River(@level_group, 1)
  @game_group\insert(@level_group)

  @player_group = display.newGroup()
  @player_group\scale(@level.scale, @level.scale)
  @player = Player(@player_group, @level)
  @player_group.x = display.contentWidth / 2 - (@player_group.contentWidth / 2)
  @player_group.y = 20
  @game_group\insert(@player_group)

  controls\create()
  @game_group\insert(controls.group)

  -- header
  background = display.newRect(0, 0, display.contentWidth, header)
  background\setFillColor(0,0,0,255)
  @view\insert(background)

  margin = 0
  restart_button = display.newImage('images/restart.png', margin, margin)
  restart_button\scale(header / restart_button.height, header / restart_button.height)
  restart_button.y = header / 2
  restart_button.x = header / 2
  @view\insert(restart_button)
  restart_button\addEventListener('tap', -> storyboard.gotoScene('scenes.menu'))

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
  @player_group\removeSelf()
  timer.performWithDelay 1, -> Runtime\removeEventListener("enterFrame", scene)
  storyboard.purgeScene()

scene\addEventListener( "exitScene", scene )
scene\addEventListener( "enterScene", scene )

return scene
