local oo = require 'oo'
local util = require 'util'
local vector = require 'vector'
local constant = require 'constant'
local font_factory = require 'dejavu_font'

local Timer = require 'Timer'
local Rect = require 'Rect'
local DynO = require 'DynO'

local czor = game:create_object('Compositor')
local Tile
local Board

local tw = 84
local th = 84
local nw = 8
local nh = 8
local padding = 8

function background()
   czor:clear_with_color(util.rgba(255,255,255,255))
end

local DIRECTION = {
   'NORTH',
   'SOUTH',
   'EAST',
   'WEST'
}

Tile = oo.class(DynO)
function Tile:init(center, n)
   DynO.init(self, center)

   local go = self:go()
   go:body_type(constant.STATIC)

   local font = font_factory(1)
   local w = tw - padding/2
   local h = th - padding/2
   local str = tostring(n)
   local sw = font:string_width(str)
   local sh = font:line_height(str)
   go:add_component('CDrawText', {font=font, color={1,1,1,1}, message=tostring(n),
                                  offset={-sw/2, -sh/8}})
   go:add_component('CTestDisplay', {w=w, h=h})
end

Board = oo.class(oo.Object)
function Board:init(offset)
   local tiles = {}

   for yy = 1,nh do
      for xx = 1,nw do
         local tile = Tile(offset + {xx * tw, yy * th}, xx + (yy-1) * nw)
         table.insert(tiles, tile)
      end
   end

   self.tiles = tiles
end



function init()
   util.install_basic_keymap()
   world:gravity({0,0})

   local cam = stage:find_component('Camera', nil)
   cam:pre_render(util.fthread(background))

   local board = Board(vector.new({-16, -16}))
end

function game_init()
   util.protect(init)()
end
