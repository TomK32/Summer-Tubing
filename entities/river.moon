require 'entities.white_water'

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
    @collision_map_scaleX = @image.width / #@collision_map[1] * 0.9
    @collision_map_scaleY = @image.height / #@collision_map * 0.9

    for i, pos in pairs(@level.effects.white_water or {})
      white_water = WhiteWater(pos.x, pos.y, pos.width)
      @group\insert(white_water.group)

    @

  update: (dt, position) =>
    @group.y = 0 - position.y
    @

  current: (x, y) =>
    return({x: 0, y: 0.2})

  collision: (x, y) =>
    y = math.ceil((y + 1) / @collision_map_scaleY)
    if @collision_map[y]
      x = math.ceil((x + 1) / @collision_map_scaleX)
      return @collision_map[y][x]
    return nil
