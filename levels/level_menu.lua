
return {
  images = {
    {x = 0, y = 0, file = 'images/level_1.png'},
  },
  width = 320, -- usually width of your level images
  start = {x = 140, y = 880},
  finish = 950, -- pixel, y-value
  clock = 90, -- seconds
  -- scores are always a bit after the white water
  -- player needs to avoid collision for some time to score
  default_bonus_score = { height = 10, score = 30 },

  bonus_scores = {
  },
  effects = {
    white_water = {
      {x = 65, y = 25, width = 15},
      {x = 100, y = 130, width = 50}
    }
  }
}

