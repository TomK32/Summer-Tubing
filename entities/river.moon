require 'entities.white_water'

export class River
  new: (group, level) =>
    @group = group
    @debug_collision = false

    @level = require 'levels.level_' .. level
    assert(@level)
    @scale = display.contentWidth / @level.width

    for i, image in ipairs(@level.images)
      image = display.newImage(@group, image.file, image.x * @scale, image.y * @scale, true)

    @start = { x: @level.start.x * @scale, y: @level.start.y * @scale}
    @finish = @level.finish * @scale

    @group\scale(@scale, @scale)

    @collision_map = require 'levels.level_' .. level .. '_collision'
    @collision_map_scaleX = @level.width / #@collision_map[1]
    @collision_map_scaleY = @collision_map_scaleX

    for i, pos in pairs(@level.effects.white_water or {})
      white_water = WhiteWater(pos.x, pos.y, pos.width)
      @group\insert(white_water.group)

    @prepareBonusScores()
    @renderBonusScores()

    @

  prepareBonusScores: =>
    -- copy in the default values
    for i, score in ipairs(@level.bonus_scores)
      for k, v in pairs(@level.default_bonus_score)
        if score[k] == nil
          score[k] = v

  renderBonusScores: =>
    for i, score in ipairs(@level.bonus_scores)
      score.score_text = display.newText(@group, score.score .. '', 0, score.y, native.systemFontBold, game.font_size/@scale)
      score.score_text.x = score.x + score.width / 2 - score.score_text.width / 2
      score.score_text\setTextColor(255, 200, 0, 255)

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
    return({x: 0 * @scale, y: 0.2 * @scale})

  collision: (x, y) =>
    y = math.ceil((y / @scale) / @collision_map_scaleY) + 1
    if @collision_map[y]
      x = math.ceil((x / @scale) / @collision_map_scaleX) + 1
      return @collision_map[y][x]
    return 0

  findBestX: (y) =>
    best_x = false
    y = math.ceil((y/@scale) / @collision_map_scaleY)
    if not @collision_map[y]
      return false
    cur_c = @collision_map[y][1]
    for x = 1, #@collision_map[y]
      c = @collision_map[y][x]
      if c > 255
        return x * @collision_map_scaleX
      if c > cur_c or (c == cur_c and math.random() > 0.2)
        cur_c = c
        best_x = x
    return best_x * @collision_map_scaleX * @scale

  hasBonusScore: (x, y) =>
    x = x / @scale
    y = y / @scale
    for i, score in ipairs(@level.bonus_scores)
      if x > score.x and x < score.x + score.width and y > score.y and y < score.y + score.height
        if score.score_text
          score.score_text\removeSelf()
        table.remove(@level.bonus_scores, i)
        return score.score

