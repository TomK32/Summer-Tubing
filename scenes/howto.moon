--  Unstack2 Field
--
--  Copyright 2011-2013 Ananasblau.com. All rights reserved.

scene = storyboard.newScene('HowTo')

gotoMainMenu = (event) ->
  storyboard.gotoScene("scenes.menu", "fade", 50)

  return true


scene.printLine = (text, x, y, width, font_size) =>
  t = display.newText(text, x, y, width, 0, native.systemFontBold, font_size)
  t\setReferencePoint(display.TopRightReferencePoint)
  @view\insert t
  return y + t.height * 1.2


scene.createScene = (event) =>
  background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  background\setFillColor(0,0,0,255)
  @view\insert(background)

  x = math.ceil(display.contentWidth / 20)
  y = math.ceil(display.contentHeight / 40)
  width = display.contentWidth - x * 2
  line_height = math.floor(display.contentHeight / 16)
  font_size = math.floor(math.max(10, line_height / 2))

  y = @\printLine('HowTo', x * 1.4, y, width, font_size * 1.6)
  y = @\printLine('You are sitting in a pumped up car tire.', x, y, width, font_size)
  y = @\printLine('You can paddle with you hands with the two', x, y, width, font_size)
  y = @\printLine('controls at the bottom left and bottom right', x, y, width, font_size)

  y = @\printLine('', x, y, width, font_size)
  y = @\printLine('Tap the two controls at the same time to paddle backwards', x, y, width, font_size)
  y = @\printLine('Tap one control to spin', x, y, width, font_size)
  y = @\printLine('You will need to tap a lot to gain some speed', x, y, width, font_size)

  @view\addEventListener("touch", gotoMainMenu)
  @view\addEventListener("tap", gotoMainMenu)
  @view

scene.exitScene = (event) =>
  storyboard.purgeScene()


scene\addEventListener( "createScene", scene )
scene\addEventListener( "exitScene", scene )

return scene

