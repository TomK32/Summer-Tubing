export class River
  new: (group, level) =>
    @group = group

    @level = require 'levels.level' .. level
    assert(@level)

    @start = @level.start

    @image = display.newImage(@group, @level.image, 0, 0, true)
    scale = display.contentWidth / @image.width
    @image\scale(scale, 1)
    @image.x = math.floor(@image.contentWidth / 2)

    @collision_map = require 'levels.level' .. level .. '_collision'
    @collision_map_scaleX = @image.width / #@collision_map[1]
    @collision_map_scaleY = @image.height / #@collision_map

    @

  update: (dt, position) =>
    @image.y = @image.height / 2 - position.y
    @

  current: (x, y) =>
    return({x: 0, y: 0.2})

  collision: (x, y) =>
    y = math.ceil((y + 1) / @collision_map_scaleY)
    if @collision_map[y]
      x = math.ceil((x + 1) / @collision_map_scaleX)
      return @collision_map[y][x]
    return nil
