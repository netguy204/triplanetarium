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
local Hand
local Deck

local tw = 64
local th = 64
local nw = 8
local nh = 8
local padding = 8

function background()
   czor:clear_with_color(util.rgba(255,255,255,255))
end

local function animate_between(item)
   local s = (1 - item.rdt / item.dt)
   local dx = item.stop - item.start
   local x = item.start + dx * s

   item.go:pos(x)
   item.rdt = item.rdt - world:dt()
   if item.rdt <= 0 then
      item.go:pos(item.stop)
      return false
   else
      return true
   end
end

local Sequence = oo.class(oo.Object)
function Sequence:init()
   self.queue = {}
   self.running = false
end

function Sequence:animate_between(go, start, stop, dt)
   table.insert(self.queue, {fn=animate_between, arg={go=go, start=start, stop=stop, dt=dt, rdt=dt}})
end

function Sequence:next(fn, ...)
   local lfn = function(item)
      return fn(unpack(item))
   end
   table.insert(self.queue, {fn=fn, item={...}})
end

function Sequence:start()
   if util.empty(self.queue) or self.running then
      return
   end

   self.running = true
   local comp

   local thread = function()
      local item = self.queue[1]
      if not item.fn(item.arg) then
         table.remove(self.queue, 1)
         if util.empty(self.queue) then
            comp:delete_me(1)
            self.running = false
            return
         end
      end
   end

   comp = stage:add_component('CScripted', {update_thread=util.fthread(thread)})
end

local DIRECTION = {
   NORTH = {angle=0, offset=vector.new({0,1})},
   SOUTH = {angle=math.pi, offset=vector.new({0,-1})},
   EAST =  {angle=-math.pi/2, offset=vector.new({1,0})},
   WEST =  {angle=math.pi/2, offset=vector.new({-1,0})}
}

Tile = oo.class(DynO)
function Tile:init(center, n, d)
   DynO.init(self, center)

   local go = self:go()
   go:body_type(constant.STATIC)
   self:fpos(center)
   self.n = n
   self.d = d
   self:hide()
end

function Tile:direction(name)
   if not name then
      return DIRECTION[self.d]
   else
      self.d = name
      if self.t3 then
         self.t3:angle_offset(DIRECTION[self.d].angle)
      end
   end
end

function Tile:show()
   local font = font_factory(2)
   local str = tostring(self.n)
   local sw = font:string_width(str)
   local sh = font:line_height(str)

   self:hide(true)
   local go = self:go()
   self.t1 = go:add_component('CDrawText', {font=font, color={0,0,0,1}, message=str,
                                            offset={-sw/2, -sh/8-2}})
   self.t2 = go:add_component('CDrawText', {font=font, color={1,1,1,1}, message=str,
                                            offset={-sw/2, -sh/8}})


   local dir = DIRECTION[self.d]
   local _art = game:atlas_entry(constant.ATLAS, 'tile')
   self.t3 = go:add_component('CStaticSprite', {entry=_art,
                                                angle_offset=dir.angle})
end

function Tile:hide(fully)
   local parts = {'t1', 't2', 't3'}
   for ii=1,#parts do
      if self[parts[ii]] then
         self[parts[ii]]:delete_me(1)
         self[parts[ii]] = nil
      end
   end

   if not fully then
      local go = self:go()
      local _art = game:atlas_entry(constant.ATLAS, 'tile_back')
      self.t3 = go:add_component('CStaticSprite', {entry=_art})
   end
end

function Tile:vpos(pos)
   if not pos then
      return self._vpos
   else
      self._vpos = vector.new(pos)
   end
end

function Tile:pos(pos)
   if not pos then
      return vector.new(self:go():pos())
   else
      self:go():pos(pos)
   end
end

function Tile:fpos(pos)
   self:vpos(pos)
   self:pos(pos)
end

Board = oo.class(oo.Object)
function Board:init(offset, deck)
   self.offset = offset
   local tiles = {}
   local tile = deck:draw_number()
   tiles[{1,nh}] = tile
   tile:direction('EAST')

   local anim = Sequence()
   anim:animate_between(tile:go(), tile:pos(), self:loc2center({1,nh}), .3)
   anim:next(tile:bind('show'))
   anim:next(tile:bind('fpos'), self:loc2center({1,nh}))
   anim:start()

   self.tiles = tiles
   self.nw = nw
   self.nh = nh
end

function Board:loc2center(loc)
   return self.offset + {loc[1] * tw, loc[2] * th}
end

function Board:worldpos2loc(pos)
   pos = pos - self.offset
   local xx = util.round(pos[1] / tw)
   local yy = util.round(pos[2] / th)
   if xx < 1 or xx > nw or yy < 1 or yy > nh then
      return nil
   else
      return {xx, yy}
   end
end

function Board:worldpos2center(pos)
   local loc = self:worldpos2loc(pos)
   if not loc then
      return nil
   end

   return self.offset + {loc[1] * tw, loc[2] * th}
end

function Board:worldpos2rect(pos)
   local cc = self:worldpos2center(pos)
   if not cc then
      return nil
   end

   return Rect.centered(cc, tw, th)
end

Hand = oo.class(oo.Object)
function Hand:init(deck, max, offset)
   self.max = max
   self.tiles = {}
   self.offset = vector.new(offset)

   local anim = Sequence()
   for ii=1,max do
      local tile = deck:draw()
      self.tiles[ii] = tile
      anim:animate_between(tile:go(), tile:pos(), self:idx2center(ii), .3)
      anim:next(tile:bind('show'))
      anim:next(tile:bind('fpos'), self:idx2center(ii))
   end
   anim:start()
end

function Hand:idx2center(ii)
   return self.offset + {ii * tw, 0}
end

Deck = oo.class(oo.Object)
function Deck:init(offset)
   self.offset = vector.new(offset)

   local values = {2, 3, 4, 4, 5, 5, 7, 9, 9,
                   '+', '+', '+', '+', '-', '-', '-'}
   values = util.rand_shuffle(values)

   self.tiles = {}
   for ii=1,#values do
      local tile = Tile(self.offset, values[ii], 'NORTH')
      tile:hide()
      table.insert(self.tiles, tile)
   end
end

function Deck:draw()
   if util.empty(self.tiles) then
      return nil
   else
      local item = self.tiles[1]
      table.remove(self.tiles, 1)
      return item
   end
end

function Deck:draw_number()
   for ii=1,#self.tiles do
      if util.isnumber(self.tiles[ii].n) then
         local tile = self.tiles[ii]
         table.remove(self.tiles, ii)
         return tile
      end
   end
end

function Deck:pos()
   return self.offset
end

function init()
   util.install_basic_keymap()
   util.install_mouse_map()
   world:gravity({0,0})

   local cam = stage:find_component('Camera', nil)
   cam:pre_render(util.fthread(background))

   local deck = Deck({800,600})
   local hand = Hand(deck, 5, {800,200})
   local board = Board(vector.new({-16, -16}), deck)

   local hl = stage:add_component('CTestDisplay', {w=tw, h=th,
                                                   color={1,1,1,.3}})
   local input = function()
      local mouse = util.mouse_state()
      local rect = board:worldpos2rect(mouse)
      if rect then
         hl:offset(rect:center())
      end
   end
   stage:add_component('CScripted', {update_thread=util.fthread(input)})

end

function game_init()
   util.protect(init)()
end
