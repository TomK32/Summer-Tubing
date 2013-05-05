require 'entities.white_water'

export class River
  new: (group, level) =>
    @group = group

    @level = require 'levels.level' .. level
    assert(@level)

    @image = display.newImage(@group, @level.image, 0, 0, true)
    @scale = display.contentWidth / @image.width

    @start = { x: @level.start.x * @scale, y: @level.start.y * @scale}
    @finish = @level.finish * @scale

    @group\scale(@scale, @scale)

    @collision_map = require 'levels.level' .. level .. '_collision'
    @collision_map_scaleX = display.contentWidth / #@collision_map[1]
    @collision_map_scaleY = @image.height / #@collision_map

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

  touch: (event) =>
    print(math.ceil(event.x / @collision_map_scaleY / @scale), math.ceil((math.abs(@group.y/@scale) + event.y) / @collision_map_scaleY), @collision(event.x, @group.y + event.y))

