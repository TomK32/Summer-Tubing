require 'entities.movable'
export class Player extends Movable

  new: (group) =>
    Movable.__init(self)
    print(group.insert)
    @group = group
    @create()
    @

  create: =>
    image = display.newImage(@group, 'images/player.png', 0, 0)
    @

  toString: =>
    return 'x: ' .. @position.x .. ', y: ' .. @position.y .. ', rotation: ' .. @rotation .. ', spin: ' .. @spin
