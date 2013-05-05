require 'entities.movable'
export class Player extends Movable

  new: (group, @level) =>
    Movable.__init(self)
    @group = group
    @level = level
    @position.x = level.start.x
    @position.y = level.start.y
    @create()
    @rotation = 90
    @image\rotate(@rotation)
    @collided = false
    @

  create: =>
    @image = display.newImage(@group, 'images/player.png', 0, 0)
    @

  update: (dt) =>
    @speed.x -= @speed.x * dt
    @speed.y -= @speed.y * dt

    collision = @level\collision(self.position.x, self.position.y)
    if collision > 0
      current = @level\current(self.position.x, self.position.y)
      @speed.x = @speed.x + dt * current.x
      @speed.y = @speed.y + dt * current.y
      @move(@speed.x, @speed.y)
    else
      @collided = true

    --@spin = @spin * dt
    if math.abs(@spin) < dt
      @spin = 0
    if @spin ~= 0
      spin = @spin * dt *  20
      @rotation = (@rotation + spin) % 360
      @image\rotate(spin)
    @group.x = @position.x
    @

  toString: =>
    return 'x: ' .. math.floor(@position.x) .. ', y: ' .. math.floor(@position.y) .. ', rot: ' .. math.floor(@rotation) .. ', spin: ' .. math.floor(@spin*10)/10 .. ', s_x: ' .. math.floor(@speed.x*10)/10 .. ', s_y:' .. math.floor(@speed.y*10)/10
