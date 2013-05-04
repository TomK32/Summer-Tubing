

storyboard = require('storyboard')
scene = storyboard.newScene('Level')
widget = require "widget"

require 'entities.player'

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
    paddle = math.abs(@slide_start[side] - event.y)
    if paddle > 0
      scene.player\paddle(side, paddle / @slide_height)
    print(paddle, @slide_start['left'], @slide_start['right'])
    @slide_start[side] = nil

scene.debug = =>
  debug = display.newGroup()
  player = display.newText(@player\toString(), 5, 0)
  
  debug\insert(player)
  @view\insert(debug)

scene.createScene = (event) =>
  background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  background\setFillColor(0,0,0,255)
  @view\insert(background)

  @player_group = display.newGroup()
  @player = Player(@player_group)
  @player_group.xScale, @player_group.yScale = 0.3, 0.3
  @player_group.x = display.contentWidth / 2 - (@player_group.contentWidth / 2)
  @player_group.y = display.contentHeight - @player_group.contentHeight * 1.2
  @view\insert(@player_group)

  controls\create()
  @view\insert(controls.group)
  @debug()
  @view

scene.exitScene = (event) =>
  storyboard.purgeScene()

scene\addEventListener( "exitScene", scene )
scene\addEventListener( "createScene", scene )

return scene
