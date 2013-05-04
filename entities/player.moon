require 'entities.movable'
export class Player extends Movable

  new: (group) =>
    Movable.__init(self)
    @group = group
    @create()
    @

  create: =>
    @image = display.newImage(@group, 'images/player.png', 0, 0)
    @

  update: (dt) =>
    if @spin < 0
      @spin += dt
    elseif @spin > 0
      @spin -= dt
    if math.abs(@spin) < dt
      @spin = 0
    if @spin ~= 0
      @rotation += @spin * dt * 50
      @image\rotate(@spin * dt * 50)

  toString: =>
    return 'x: ' .. @position.x .. ', y: ' .. @position.y .. ', rotation: ' .. @rotation .. ', spin: ' .. @spin
