
sounds = {}
sounds.music = audio.loadSound('sounds/music_menu.mp3')

sounds.play = (file, options) ->
  file = sounds[file]
  if type(file) == 'table'
    file = file[math.ceil(math.random() * #file)]
  audio.play(file, options)

return sounds
