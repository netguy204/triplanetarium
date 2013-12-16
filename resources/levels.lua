local util = require 'util'
local vector = require 'vector'
local constant = require 'constant'
local font_factory_big = require 'dejavu_font_big'


local Rect = require 'Rect'
local Indicator = require 'Indicator'

-- win animations
local function firework_win(anim)
   local cam = stage:find_component('Camera', nil)
   local screen_rect = Rect(cam:viewport())
   local screen_width = screen_rect:width()
   local screen_height = screen_rect:height()

   local _art = game:atlas_entry(constant.ATLAS, 'spark')
   local crect = Rect.centered({screen_width/2, screen_height/2}, 100, 100)

   local params =
      {def=
          {layer=constant.PLAYER,
           n=500,
           renderer={name='PSC_E2SystemRenderer',
                     params={entry=_art}},
           activator={name='PSConstantRateActivator',
                      params={rate=200}},
           components={
              {name='PSConstantAccelerationUpdater',
               params={acc={0,-20}}},
              {name='PSTimeAlphaUpdater',
               params={time_constant=0.4,
                       max_scale=3.0}},
              {name='PSFireColorUpdater',
               params={max_life=0.8,
                       start_temperature=6000,
                       end_temperature=2000}},
              {name='PSVelocityAngleUpdater',
               params={}},
              {name='PSBoxInitializer',
               params={initial=crect,
                       refresh=crect,
                       minv={-300,10},
                       maxv={300,100}}},
              {name='PSTimeInitializer',
               params={min_life=0.4,
                       max_life=1.0}},
              {name='PSTimeTerminator'}}}}

   local system = stage:add_component('CParticleSystem', params)
   local win = Indicator(font_factory_big(1), {screen_width/2, screen_height/2},
                         {0,0,0,1}, stage)
   win:update('Level Complete!')

   local kill = function()
      system:delete_me(1)
      win:terminate()
   end

   anim:wait(2)
   anim:next(kill)
   return anim
end

local function game_win(anim)
   firework_win(anim)
   firework_win(anim)

   local win = Indicator(font_factory_big(1), {screen_width/2, screen_height/2},
                         {0,0,0,1}, stage)
   win:update('You completed all the levels! Check out resources/levels.lua to create your own.')

   anim:next(win:bind('terminate'))
end


local function last_is_one()
   return marker:evaluate() == 1
end

local function score_at_least(n)
   return function()
      return marker.score_value >= n
   end
end

local levels = {
   {bstr = {'(s5)....'},
    dstr = '2+6-',
    desc = 'Create an expression that is equal to one.',
    score = false,
    win = last_is_one,
    win_animation=firework_win},


   {bstr = {'(s5)....',
            '___    .',
            '___  ...'},
    dstr = '2+6-+44-',
    desc = 'You draw new tiles until you run out.',
    score = false,
    win = last_is_one,
    win_animation=firework_win},


   {bstr = {'___  ...',
            '___  .  ',
            '(s3)..  ',
            '___  .  ',
            '___  .. '},
    dstr = '43+-+9',
    desc = 'Click on the last tile you\'ve placed to rotate it.',
    score = false,
    win = last_is_one,
    win_animation=firework_win},


   -- pretty tough
   {bstr = {'___  .  ',
            '___  .  ',
            '(s2)....',
            '___  . .',
            '___  ...'},
    dstr = '44+-+73-+-5',
    desc = 'Reuse old tiles by crossing your path.',
    score = false,
    win = last_is_one,
    win_animation=firework_win},


   {bstr = {'___  ...',
            '___ ....',
            '(s3)....',
            '___ ....',
            '___  ...'},
    dstr = '43+-+962-3+3+45-6-+',
    desc = 'You score points every time you compute a 1. Try to get at least 2 points.',
    score = true,
    win = score_at_least(2),
    win_animation=game_win}

}

return levels
