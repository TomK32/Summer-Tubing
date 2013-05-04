
export class Movable
  new: (position) =>
    @position = position or {x: 0, y: 0}
    @rotation = 0
    -- -1 to +1 depending on how hard you paddle.
    -- -1 being a paddle to the left and +1 being right
    @spin = 0

  -- side: 'left' or 'right'
  -- strength: 0..1
  paddle: (side, strength) =>
    if side == 'left'
      if @spin > 0
        -- we move
        @move(0, 1)
    elseif side == 'right'
      if @spin < 0
        @move(0, 1)
    else
      assert(side, "left or right")
    @spin += strength / 2

  move: (x, y) =>
    -- TODO: check for boundaries and collisions
    self.position.x += x
    self.position.y += y
