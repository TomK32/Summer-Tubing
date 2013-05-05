

storyboard = require('storyboard')
scene = storyboard.newScene('Level')
widget = require "widget"

require 'entities.player'
require 'entities.river'

controls = {
  slide_width: math.max(10, display.contentWidth / 16)
  slide_height: math.max(100, display.contentHeight / 4)
  slides_y: display.contentHeight - 4
  slide_color: {200, 200, 200, 255}
  group: display.newGroup()
  slide_start: {left: nil, right: nil}
}

controls.create = =>
  left = display.newRect( 4, @slides_y - @slide_height, @slide_width, @slide_height)
  left\setFillColor(255,255,255,255)
  right = display.newRect( display.contentWidth - @slide_width - 4, @slides_y - @slide_height, @slide_width, @slide_height)
  right\setFillColor(unpack(@slide_color))

  @group\insert(left)
  @group\insert(right)

  -- connect to player
  left\addEventListener('touch', (event) -> @paddle('left', event))
  right\addEventListener('touch', (event) -> @paddle('right', event))

controls.paddle = (side, event) =>
  if not @slide_start[side]
    @slide_start[side] = event.y
  elseif event.phase == 'moved'
    1
    -- animate
  elseif event.phase == 'ended'
    paddle = math.abs(@slide_start[side] - event.y) * 5
    if paddle > 0
      scene.player\paddle(side, paddle / @slide_height)
    @slide_start[side] = nil

scene.gameLoop = (event) ->
  dt = 0.02
  if not game.running
    return
  scene.player\update(dt)
  scene.river\update(dt, scene.player.position)
  if scene.debug_group
    scene\debug()
  true

scene.debug = =>
  if not @debug_group
    @debug_group = display.newGroup()
  
    @debug_group.player = display.newText(@player\toString(), 5, 0)
    @view\insert(@debug_group)
  else
    @debug_group.player.text = @player\toString()

scene.createScene = (event) =>
  background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  background\setFillColor(0,0,0,255)
  @view\insert(background)

  @river_group = display.newGroup()
  @river = River(@river_group, 1)
  @view\insert(@river_group)

  @player_group = display.newGroup()
  @player = Player(@player_group, @river)
  @player_group.x = display.contentWidth / 2 - (@player_group.contentWidth / 2)
  @player_group.y = 20
  @view\insert(@player_group)

  controls\create()
  @view\insert(controls.group)
  @debug()
  timer.performWithDelay 1, -> Runtime\addEventListener("enterFrame", scene.gameLoop)
  game.running = true
  @

scene.exitScene = (event) =>
  game.running = false
  storyboard.purgeScene()

scene\addEventListener( "exitScene", scene )
scene\addEventListener( "createScene", scene )

return scene
