
return {
  image = 'images/level_1.png',
  start = {x = 90, y = 30},
  finish = 1000, -- pixel, y-value
  -- scores are always a bit after the white water
  -- player needs to avoid collision for some time to score
  default_bonus_score = { height = 30, score = 30 },

  bonus_scores = {
    {x = 130, y = 230, width = 60},
    {x = 180, y = 420, width = 50, height = 30},
    {x = 120, y = 580, width = 45, height = 30},
    {x = 130, y = 760, width = 20, height = 30},
    {x = 115, y = 840, width = 55, height = 30, score = 60}
  },
  effects = {
    white_water = {
      {x = 130, y = 210, width = 60},
      {x = 180, y = 400, width = 50},
      {x = 120, y = 560, width = 45},
      {x = 130, y = 740, width = 20},
      {x = 115, y = 820, width = 55}
    }
  }
}
