
export class Movable
  new: (position) =>
    @position = position or {x: 0, y: 0}
    @rotation = 0
    @speed = {x: 0, y: 0}
    -- -1 to +1 depending on how hard you paddle.
    -- -1 being a paddle to the left and +1 being right
    @spin = 0
    @

  -- side: 'left' or 'right'
  -- strength: 0..1
  paddle: (side, strength) =>
    x_mod, y_mod = 1, 1
    s_x, s_y = 0, 0
    if @rotation > 180
      x_mod = -1
    if @rotation < 90 or @rotation > 270
      y_mod = -1
    if side == 'left'
      if @spin < 0
        s_x = ((strength + @spin)) * math.cos(@rotation * math.pi) - (@spin + strength) / 2
        s_y = ((strength + @spin)) * math.sin(@rotation * math.pi) - (@spin + strength) / 2
    elseif side == 'right'
      if @spin > 0
        s_x = ((strength + @spin)) * math.cos(@rotation * math.pi) - (@spin - strength) / 2
        s_y = ((strength + @spin)) * math.sin(@rotation * math.pi) - (@spin - strength) / 2
      strength = -strength
    else
      assert(side, "left or right")

    @speed.x += x_mod * math.abs(s_x)
    @speed.y += y_mod * math.abs(s_y)
    @spin += strength
    @


  move: (x, y) =>
    -- TODO: check for boundaries and collisions
    self.position.x += x
    self.position.y += y
    @
