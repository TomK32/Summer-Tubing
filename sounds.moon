
sounds = {}
sounds.music = {
  audio.loadSound('sounds/level_start.mp3')
}

sounds.play = (file) ->
  file = sounds[file]
  if type(file) == 'table'
    file = file[math.ceil(math.random() * #file)]
  audio.play(file)

return sounds
