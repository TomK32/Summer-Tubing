export class River
  new: (group, level) =>
    @group = group
    
    @image = display.newImage(@group, 'images/level_' .. level .. '.png', 0, 0, true)
    scale = display.contentWidth / @image.width
    @image\scale(scale, 1)
    @image.x = math.floor(@image.contentWidth / 2)
  
