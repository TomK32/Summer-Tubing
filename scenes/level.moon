

storyboard = require('storyboard')
scene = storyboard.newScene('Level')
widget = require "widget"


scene.createScene = (event) =>
  background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  background\setFillColor(0,0,0,255)
  timer.performWithDelay(2000, gotoMainMenu)
  @view\insert(background)
  @view

scene.exitScene = (event) =>
  storyboard.purgeScene()

scene\addEventListener( "exitScene", scene )
scene\addEventListener( "createScene", scene )

return scene
