
return {
  images = {
    {x = 0, y = 0, file = 'images/level_1.png'},
  },
  width = 320, -- usually width of your level images
  start = {x = 140, y = 200},
  finish = 1000, -- pixel, y-value
  clock = 90, -- seconds
  -- scores are always a bit after the white water
  -- player needs to avoid collision for some time to score
  default_bonus_score = { height = 10, score = 30 },

  bonus_scores = {
    {x = 130, y = 230, width = 60},
    {x = 180, y = 420, width = 30},
    {x = 120, y = 580, width = 45},
    {x = 130, y = 760, width = 20},
    {x = 105, y = 920, width = 55, score = 60}
  },
  effects = {
    white_water = {
      {x = 130, y = 210, width = 60},
      {x = 180, y = 400, width = 50},
      {x = 120, y = 560, width = 45},
      {x = 130, y = 740, width = 20},
      {x = 105, y = 900, width = 55}
    }
  }
}

