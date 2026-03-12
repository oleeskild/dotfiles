return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  --blue = 0xff76cce0,
  --yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,

  -- catpuccing
  color0 =  0xffEDEFF1,
  color1 =  0xffC98093,
  color2 =  0xff7CA198,
  color3 =  0xffDDB278,
  yellow = 0xffDDB278,
  color4 =  0xff6080B0,
  blue =  0xff6080B0,
  color5 =  0xff8E6F98,
  purple =  0xff8E6F98,
  color6 =  0xff6ca8cf,
  lightblue =  0xff6ca8cf,

  bartr = {
    bg = 0x00000000,
    border = 0xff2c2e34,
  },

  bar = {
      bg = 0xffe2e2e3,
    --bg = 0xf02c2e34,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490
  },
  bg1 = 0xffe2e2e3,
  bg2 = 0xff414550,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
