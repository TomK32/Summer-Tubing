require 'entities.movable'
export class Player extends Movable

  new: (group, @level) =>
    Movable.__init(self)
    @group = group
    @level = level
    self.position.x = level.start.x
    self.position.y = level.start.y
    @create()
    @

  create: =>
    @image = display.newImage(@group, 'images/player.png', 0, 0)
    @

  update: (dt) =>
    self\move(unpack(@level\current(self.position.x, self.position.y)))

    if @spin < 0
      @spin += dt
    elseif @spin > 0
      @spin -= dt
    if math.abs(@spin) < dt
      @spin = 0
    if @spin ~= 0
      @rotation += @spin * dt * 50
      @image\rotate(@spin * dt * 50)
    @group.x = @position.x

  toString: =>
    return 'x: ' .. math.floor(@position.x) .. ', y: ' .. math.floor(@position.y) .. ', rotation: ' .. math.floor(@rotation*10)/10 .. ', spin: ' .. math.floor(@spin*10)/10
