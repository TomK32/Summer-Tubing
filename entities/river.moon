require 'entities.white_water'

export class River
  new: (group, level) =>
    @group = group
    @debug_collision = false

    @level = require 'levels.level' .. level
    assert(@level)

    @image = display.newImage(@group, @level.image, 0, 0, true)
    @scale = display.contentWidth / @image.width

    @start = { x: @level.start.x * @scale, y: @level.start.y * @scale}
    @finish = @level.finish * @scale

    @group\scale(@scale, @scale)

    @collision_map = require 'levels.level' .. level .. '_collision'
    @collision_map_scaleX = @image.width / #@collision_map[1]
    @collision_map_scaleY = @image.height / #@collision_map

    for i, pos in pairs(@level.effects.white_water or {})
      white_water = WhiteWater(pos.x, pos.y, pos.width)
      @group\insert(white_water.group)
    @

  debug: =>
    if @debug_collision
      if @debug_group
        @debug_group\removeSelf()
        @debug_group = nil
      @debug_collision = false
      return

    @debug_collision = true
    @debug_group = display.newGroup()
    @group\insert(@debug_group)
    for y, row in pairs(@collision_map)
      for x, c in pairs(row)
        if c > 0
          r = display.newRect((x - 1) * @collision_map_scaleX, y * @collision_map_scaleY, 4, 4)
          c = 255 - (255 + c) / 8
          r\setFillColor(c, c, c, c)
          @debug_group\insert(r)

  update: (dt, position) =>
    @group.y = 0 - position.y
    @

  current: (x, y) =>
    return({x: 0, y: 0.2})

  collision: (x, y) =>
    y = math.ceil(y / @collision_map_scaleY) + 1
    if @collision_map[y]
      x = math.ceil(x / @collision_map_scaleX) + 1
      return @collision_map[y][x]
    return 0

  findBestX: (y) =>
    best_x = false
    y = math.ceil(y / @collision_map_scaleY)
    if not @collision_map[y]
      return false
    cur_c = @collision_map[y][1]
    for x = 1, #@collision_map[y]
      c = @collision_map[y][x]
      print(c, cur_c)
      if c > 255
        return x * @collision_map_scaleX
      if c > cur_c or (c == cur_c and math.random() > 0.5)
        cur_c = c
        best_x = x
    return best_x * @collision_map_scaleX

  touch: (event) =>

