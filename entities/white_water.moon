export class WhiteWater
  image: 'images/white_water.png'
  -- intesity is an integer. 20 is defaul
  new: (x, y, width, intensity) =>
    @width = width or 20
    @count = intensity or 4
    @images = 0
    @group = display.newGroup()
    @group.x, @group.y = x, y
    @create()
    @

  create: =>
    if not @group.insert
      return
    white_water = @
    for i=1, @count
      @images +=1
      image = display.newImage(WhiteWater.image, math.ceil(math.random() * @width), 0, 10, 3)
      if math.random() > 0.8
        image.blendMode = 'multiply'
      @group\insert(image)
      transition.from(image, {time: 400, alpha: 0, transition: easing.inQuad})
      transition.to(image, {delay: 2600, time: 400, alpha: 0, transition: easing.inQuad})
      transition.to(image, {time: 3000, y: 40 * (1 + math.random()),
        onComplete: =>
          white_water.images -= 1
          if @.removeSelf
            @\removeSelf()
      })


    timer.performWithDelay 1000, -> @create()
