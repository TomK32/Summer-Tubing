
scene = storyboard.newScene('Menu')
widget = require "widget"
require 'entities.river'

scene.enterScene = (event) =>

  @background_group = display.newGroup()
  level = River(@background_group, 'menu')
  @view\insert(@background_group)
  --  @background_image = display.newImage(@view, 'images/level_1.png', 0, 0)
  --scale = display.contentWidth / @background_image.width
  --@background_image\scale(scale, scale)


  y = display.contentHeight / 5

  title = display.newText("Summer Tubing", 0, y, native.systemFontBold, game.font_size * 1.5)
  title.x = display.contentWidth / 2
  @view\insert(title)

  y += title.height * 1.9

  play_button = widget.newButton({
    label: "Play Now",
    labelColor: { default: {0}, over: {0} },
    top: y,
    onRelease: ->
      storyboard.gotoScene("scenes.level", "fade", 50)
      analytics.newEvent("design", {event_id: "menu:play"})
      return true
  })

  play_button\setReferencePoint(display.CenterReferencePoint)
  play_button.x = display.contentWidth * 0.5
  y += play_button.height * 1.2

  games_button = widget.newButton({
    label: 'More games',
    top: y,
    onRelease: ->
      analytics.newEvent("design", {event_id: "menu:visit_more_games"})
      system.openURL( 'http://ananasblau.com/games?utm_source=summertubing&utm_medium=android&utm_term=main+menu&utm_campaign=games' )
  })
  games_button.x = play_button.x
  y += games_button.height * 1.2

  highscores_button = widget.newButton({
    label: 'Highscores',
    top: y,
    onRelease: ->
      storyboard.gotoScene("scenes.highscores", "fade", 50)
      analytics.newEvent("design", {event_id: "menu:highscores"})
      return true
  })
  highscores_button.x = play_button.x
  y += highscores_button.height * 1.2

  howto_button = widget.newButton({
    label: 'Howto play',
    top: y,
    onRelease: ->
      storyboard.gotoScene("scenes.howto", "fade", "50")
      analytics.newEvent("design", { event_id: "menu:howto"})
      return true
  })
  howto_button.x = play_button.x
  y += howto_button.height * 1.2

  author = display.newText("(C) 2013 Ananasblau Games", 0, y, native.systemFontBold, game.font_size / 2)
  author.x = display.contentWidth / 2
  @view\insert(author)


  @view\insert(howto_button)
  @view\insert(highscores_button)
  @view\insert(games_button)
  @view\insert(play_button)

scene.exitScene = (event) =>
  if @timer
    timer.cancel(@timer)

scene\addEventListener( "createScene", scene )
scene\addEventListener( "enterScene", scene )
scene\addEventListener( "exitScene", scene )

return scene

