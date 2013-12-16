local oo = require 'oo'
local util = require 'util'
local vector = require 'vector'
local constant = require 'constant'
local font_factory = require 'dejavu_font'
local font_factory_big = require 'dejavu_font_big'
local font_factory_mid = require 'dejavu_font_mid'

local Timer = require 'Timer'
local Rect = require 'Rect'
local DynO = require 'DynO'
local Indicator = require 'Indicator'
local Sequence = require 'Sequence'
local Menu = require 'Menu'

local czor = game:create_object('Compositor')

-- intentionally globally scoped
Tile = nil
Board = nil
Hand = nil
Deck = nil
Marker = nil
EvalState = nil
PSManager = nil
Steam = nil
SteamManager = nil

tw = 64
th = 64
padding = 8

deck = nil
board = nil
hand = nil
score = nil
marker = nil
steam_manager = nil
cscript = nil

local levels = require 'levels'
local level_idx = 5


function background()
   czor:clear_with_color({1,1,1,1})
end

local DIRECTION = {
   NORTH = {angle=0, offset=vector.new({0,1}), next='EAST', opposite='SOUTH'},
   SOUTH = {angle=math.pi, offset=vector.new({0,-1}), next='WEST', opposite='NORTH'},
   EAST =  {angle=-math.pi/2, offset=vector.new({1,0}), next='SOUTH', opposite='WEST'},
   WEST =  {angle=math.pi/2, offset=vector.new({-1,0}), next='NORTH', opposite='EAST'}
}

local function bind(fn, ...)
   local args = {...}
   return function(...)
      fn(table.unpack(args), ...)
   end
end

local sfx = {}

function load_sfx(kind, names)
   sfx[kind] = {}
   for ii, name in ipairs(names) do
      table.insert(sfx[kind], game:get_sound(name, 1.0))
   end
end

function play_sfx(kind)
   local snd = util.rand_choice(sfx[kind])
   game:play_sound(snd, 1)
end

local function steps_between(start, stop)
   if start == stop then
      return 0
   end

   for ii = 1,3 do
      start = DIRECTION[start].next
      if start == stop then
         return ii
      end
   end
end

PSManager = oo.class(oo.Object)
function PSManager:init(n, ctor)
   self.n = n
   self.systems = {}
   for i = 1,n do
      table.insert(self.systems, ctor())
   end
end

function PSManager:activate(...)
   local psys = table.remove(self.systems, 1)
   psys:activate(...)
   table.insert(self.systems, psys)
   return psys
end

Steam = oo.class(oo.Object)
function Steam:init(lifetime, speed)
   self.lifetime = lifetime
   self.speed = speed

   local _art = game:atlas_entry(constant.ATLAS, 'steam')
   local params =
      {def=
          {layer=constant.BACKGROUND,
           n=50,
           renderer={name='PSC_E2SystemRenderer',
                     params={entry=_art}},
           activator={name='PSConstantRateActivator',
                      params={rate=0}},
           components={
              {name='PSConstantAccelerationUpdater',
               params={acc={0,0}}},
              {name='PSTimeAlphaUpdater',
               params={time_constant=0.4,
                       max_scale=1.0}},
              {name='PSBoxInitializer',
               params={initial={-16,-34,16,-30},
                       refresh={-16,-34,16,-30},
                       minv={0,0},
                       maxv={0,0}}},
              {name='PSTimeInitializer',
               params={min_life=0.2,
                       max_life=0.4}},
              {name='PSRandColorInitializer',
               params={min_color={1,1,1,1},
                       max_color={1,1,1,1}}},
              {name='PSTimeTerminator'}}}}

   local system = stage:add_component('CParticleSystem', params)
   local activator = system:def():find_component('PSConstantRateActivator')
   local psbox = system:def():find_component('PSBoxInitializer')

   self.activator = activator
   self.psbox = psbox
   self.timer = Timer()
end

function Steam:activate(center, w, h)
   local rect = {center[1] - w/2, center[2] - h/2, center[1] + w/2, center[2] + h/2}
   self.psbox:initial(rect)
   self.psbox:refresh(rect)
   self.psbox:minv({-self.speed, -self.speed})
   self.psbox:maxv({self.speed, self.speed})
   self.activator:rate(1000)
   local term = function()
      self.activator:rate(0)
   end
   self.timer:reset(self.lifetime, term)
end

SteamManager = oo.class(PSManager)
function SteamManager:init(n)
   local ctor = function()
      return Steam(.3, 100)
   end
   PSManager.init(self, n, ctor)
end

function tile_steam_fn(center)
   return function()
      steam_manager:activate(center, tw, th)
   end
end

Tile = oo.class(DynO)
function Tile:init(center, n, d)
   DynO.init(self, center)

   local go = self:go()
   go:body_type(constant.STATIC)
   self:fpos(center)
   self.n = n
   self:direction(d)
   self:hide()
end

function Tile:isnumber()
   return util.isnumber(self.n)
end

function Tile:direction(name)
   if not name then
      return self.d
   else
      self.d = name
      if self.t3 then
         self.t3:angle_offset(DIRECTION[self.d].angle)
      end
   end
end

function Tile:show()
   local font = font_factory_mid(1)
   local str = tostring(self.n)
   local sw = font:string_width(str)
   local sh = font:line_height(str)

   self:hide(true)
   local go = self:go()
   self.t1 = go:add_component('CDrawText', {font=font, color={0,0,0,1}, message=str,
                                            offset={-sw/2-2, -sh/2+2},
                                            layer=constant.BACKGROUND})
   self.t2 = go:add_component('CDrawText', {font=font, color={1,1,1,1}, message=str,
                                            offset={-sw/2, -sh/2},
                                            layer=constant.BACKGROUND})


   local dir = DIRECTION[self.d]
   local _art = game:atlas_entry(constant.ATLAS, 'tile')
   self.t3 = go:add_component('CStaticSprite', {entry=_art,
                                                angle_offset=dir.angle,
                                                layer=constant.BACKGROUND})
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

local function square_board(nw, nh)
   local locs = {}
   local bs = {locs=locs, start={1, util.round(nh/2)}}

   for yy = 1,nh do
      for xx = 1,nw do
         table.insert(locs, {xx, yy})
      end
   end
   return bs
end

local BParser = oo.class(oo.Object)
function BParser:init(str)
   self.str = str
   self.nidx = 1
   self.nloc = 1
end

function BParser:hasmore()
   return self.nidx <= string.len(self.str)
end

function BParser:char()
   if self:hasmore() then
      return self.str:sub(self.nidx, self.nidx)
   end
end

function BParser:advance()
   local ch = self:char()
   self.nidx = self.nidx + 1
   return ch
end

function BParser:advance_location()
   local loc = self.nloc
   self.nloc = self.nloc + 1
   return loc
end

function BParser:next()
   -- bail if no more data
   if not self:hasmore() then
      return nil
   end

   -- consume comment marks
   local ch = self:advance()
   while ch == '_' do
      ch = self:advance()
   end

   -- read chords as a unit
   if ch == '(' then
      local choord = ''
      ch = self:advance()
      while ch and ch ~= ')' do
         choord = choord .. ch
         ch = self:advance()
      end

      return { value = choord, loc = self:advance_location(),
               num = self:choord_num(choord),
               dir = self:choord_dir(choord),
               cmd = choord:sub(1,1) }
   else
      return { value = ch, loc = self:advance_location(),
               num = self:choord_num(ch),
               dir = self:choord_dir(ch),
               cmd = ch:sub(1,1) }
   end
end

local choord_dir_table = {
   E = 'EAST',
   S = 'SOUTH',
   W = 'WEST',
   N = 'NORTH'
}

function BParser:choord_dir(choord)
   local lchr = choord:sub(string.len(choord))
   return choord_dir_table[lchr] or 'EAST'
end

function BParser:choord_num(choord)
   local numstr = choord:match('%d+')
   return tonumber(numstr)
end

--
-- s.......
--        .
--      e..
local function parse_board(bstr, dstr)
   local h = #bstr
   local locs = {}
   local start
   local deck = {}
   local recs = {}

   for ii=1,h do
      local row = BParser(bstr[h - (ii - 1)])

      while row:hasmore() do
         local val = row:next()
         local loc = vector.new({val.loc, ii})
         if val.cmd == 's' then
            start = {loc=loc, n=val.num, d=val.dir}
         elseif val.cmd == '.' then
            table.insert(locs, loc)
         elseif val.num then
            table.insert(locs, loc)
            table.insert(recs, {loc=loc, n=val.num, d=val.dir})
         end
      end
   end

   for ii=1,string.len(dstr) do
      local ch = dstr:sub(ii, ii)
      local num = tonumber(ch)
      if num then
         table.insert(deck, num)
      else
         table.insert(deck, ch)
      end
   end

   -- start is always the last rec
   table.insert(recs, start)
   return {locs=locs, recs=recs, deck=deck}
end

Board = oo.class(oo.Object)
function Board:init(offset, deck, boardspec)
   self.offset = offset
   self.tiles = {}
   self.boardspec = boardspec
   self.firstidx = #boardspec.recs

   -- construct the tiles required by the spec
   for ii=1,#boardspec.recs do
      local rec = boardspec.recs[ii]
      local tile = Tile(self:loc2center(rec.loc), rec.n, rec.d)
      tile:show()
      table.insert(self.tiles, {tile=tile, loc=rec.loc})
   end

   local mesh = self:board_mesh()
   self.mesh = stage:add_component('CMesh', {mesh=mesh, layer=constant.BACKERGROUND})
end

function Board:terminate()
   if self.hl then
      self.hl:delete_me(1)
   end
   self.mesh:delete_me(1)
end

function Board:place_animated(tile)
   local dest = self:place(tile)

   local anim = Sequence()
   local dpos = self:loc2center(dest)
   anim:animate_between(tile:go(), tile:pos(), dpos, .3)
   anim:next(tile_steam_fn(dpos))
   anim:next(tile:bind('show'))
   anim:next(tile:bind('fpos'), self:loc2center(dest))
   anim:next(self:bind('update'))
   anim:start()
   return anim
end

function Board:rotate_animated(tile)
   tile = tile or self:lastrec().tile

   local anim = Sequence()
   local nextdir = self:next_direction()
   if not nextdir then
      -- no other position available
      return anim
   end

   local start = 0
   local stop = steps_between(tile:direction(), nextdir) * -math.pi/2

   anim:rotate_between(tile:go(), start, stop, .3)
   anim:next(function()
                tile:go():angle(0)
                tile:direction(nextdir)
                self:update()
   end)
   anim:start()
   return anim
end

function Board:board_mesh()
   local mesh = game:create_object('Mesh')
   local color = {0,0,0,1}

   for ii = 1,#self.boardspec.locs do
      local cc = self:loc2center(self.boardspec.locs[ii])
      local ll = cc - {tw/2, th/2}
      local ul = ll + {0, th}
      local lr = ll + {tw, 0}
      local ur = ll + {tw, th}

      mesh:add_point(ll, color)
      mesh:add_point(ul, color)

      mesh:add_point(ul, color)
      mesh:add_point(ur, color)

      mesh:add_point(ur, color)
      mesh:add_point(lr, color)

      mesh:add_point(lr, color)
      mesh:add_point(ll, color)
   end

   mesh:type(constant.LINES)
   return mesh
end

function Board:place(tile)
   local dest = self:next_active()
   table.insert(self.tiles, {tile=tile, loc=vector.new(dest)})

   local valids = self:valid_directions()
   tile:direction(valids[1])

   return dest
end

function Board:update()
   if self.hl then
      self.hl:delete_me(1)
   end

   local nl = self:next_active()
   if nl then
      local cc = self:loc2center(nl)
      self.hl = stage:add_component('CTestDisplay', {offset=cc, w=tw, h=th,
                                                     color={.8,.8,1,1},
                                                     layer=constant.BACKERGROUND})
   end
end

function Board:firstrec()
   return self.tiles[self.firstidx]
end

function Board:nextrec(rec)
   local lastloc = rec.loc
   local nextloc = lastloc + DIRECTION[rec.tile.d].offset
   return self:rec_at(nextloc)
end

function Board:lastrec()
   return self.tiles[#self.tiles]
end

function Board:lasttile()
   return self:lastrec().tile
end

function Board:lastloc()
   return self:lastrec().loc
end

function Board:lastpos()
   return self:loc2center(self:lastloc())
end

function Board:lastrect()
   return Rect.centered(self:lastpos(), tw, th)
end

function Board:valid_offset_from(loc, dir)
   local dirobj = DIRECTION[dir]
   local offset = dirobj.offset
   local nl = loc + offset

   for ii = 1,2 do
      -- abort if we fall off the board
      if not self:loc_at(nl) then
         return nil
      end

      local rec = self:rec_at(nl)
      if not rec then
         return nl
      else
         local tile = rec.tile

         -- opposites block progress
         if tile.d == dirobj.opposite then
            return nil
         else
            nl = nl + offset
         end
      end
   end
end

function Board:next_active()
   if util.empty(self.tiles) then
      return self.boardspec.start
   end

   local lastrec = self:lastrec()
   local lastloc = lastrec.loc
   return self:valid_offset_from(lastloc, lastrec.tile.d)
end

function Board:loc_at(loc)
   for ii=1,#self.boardspec.locs do
      local tloc = self.boardspec.locs[ii]
      if loc:equals(tloc) then
         return ii
      end
   end
end

function Board:rec_at(loc)
   for ii=1,#self.tiles do
      if self.tiles[ii].loc:equals(loc) then
         return self.tiles[ii]
      end
   end
end

function Board:valid_directions()
   local valids = {}
   local lastrec = self:lastrec()
   local dir = lastrec.tile:direction()
   for ii=1,4 do
      if self:valid_offset_from(lastrec.loc, dir) then
         table.insert(valids, dir)
      end
      dir = DIRECTION[dir].next
   end
   return valids
end

function Board:next_direction()
   local valids = self:valid_directions()
   if #valids > 1 then
      return valids[2]
   end
end

function Board:loc2center(loc)
   return self.offset + {loc[1] * tw, loc[2] * th}
end

function Board:wants_number()
   local state = EvalState(self)
   state:last()
   return state:wants_number()
end

function Board:worldpos2loc(pos)
   pos = pos - self.offset
   local xx = util.round(pos[1] / tw)
   local yy = util.round(pos[2] / th)
   local loc = {xx, yy}
   if self:loc_at(loc) then
      return loc
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

EvalState = oo.class()
function EvalState:init(board)
   self.board = board
   self.current = nil
end

function EvalState:next()
   if not self.current then
      self.current = self.board:firstrec()
      self.seen = {self.current.tile}
   else
      -- check for a direction override and clear it
      local dir = self.next_dir or self.current.tile.d

      -- get the next tile
      local nl = self.current.loc + DIRECTION[dir].offset
      local nr = self.board:rec_at(nl)

      -- if it's something we've seen before then use the current
      -- direction as an override for the next call
      if nr and util.contains(self.seen, nr.tile) then
         self.next_dir = dir
      elseif nr then
         self.next_dir = nil
      end

      -- don't go past the end
      if not nr then
         return nil
      else
         self.current = nr
         table.insert(self.seen, nr.tile)
      end
   end

   return self.current
end

function EvalState:last()
   local n = self:next()
   while n do
      n = self:next()
   end
   return self.current
end

function EvalState:peek()
   return self.current
end

function EvalState:wants_number()
   return self.current and (not self.current.tile:isnumber())
end

function EvalState:wants_op()
   return self.current and self.current.tile:isnumber()
end

Marker = oo.class(DynO)
function Marker:init(board, score)
   DynO.init(self, {0,0})
   local go = self:go()
   go:body_type(constant.STATIC)

   local _art = game:atlas_entry(constant.ATLAS, 'marker')
   go:add_component('CStaticSprite', {entry=_art, layer=constant.FOREGROUND})
   self.value = Indicator(font_factory(1), {0, 16}, {0,0,0,1}, go)
   self.value.text:layer(constant.MENU)
   self.board = board
   self.score = score
   self.score_value = 0
   self.state = EvalState(board)

   -- hokey to put this here
   local anim = Sequence()
   anim:wait(.4)
   self:update_animated(anim)
   anim:start()
end

function Marker:wants_number()
   return self.state:wants_number()
end

function Marker:wants_op()
   return self.state:wants_op()
end

function Marker:evaluate()
   local op = nil
   local state = EvalState(self.board)
   local value = 0

   while true do
      local rec = state:next()
      if not rec then
         break
      end

      local tile = rec.tile

      if tile:isnumber() then
         if not op then
            value = tile.n
         elseif op == '+' then
            value = value + tile.n
         elseif op == '-' then
            value = value - tile.n
         end
      else
         op = tile.n
      end
   end

   return value
end

function Marker:update_total()
   local value = self:evaluate()
   self.value:update(tostring(value))

   if value ~= self.last_value and value == 1 then
      self.score_value = self.score_value + 1
      self.score:update('%d', self.score_value)
   end

   self.last_value = value
end

function Marker:pos()
   return vector.new(self:go():pos())
end

function Marker:update_animated(anim)
   local lastpos = self:pos()
   local lastrec = self.state:peek()

   -- don't move if we're on the last tile that was placed
   local blr = self.board:lastrec()
   if lastrec and lastrec.loc:equals(blr.loc) then
      return
   end

   while true do
      local nextrec = self.state:next()
      if not nextrec then
         break
      end

      local nextpos = self.board:loc2center(nextrec.loc) + {0, 40}
      anim:animate_between(self:go(), lastpos, nextpos, .3)
      lastpos = nextpos

      if nextrec.loc:equals(blr.loc) then
         break
      end
   end

   anim:next(self:bind('update_total'))
   return anim
end

Hand = oo.class(oo.Object)
function Hand:init(deck, board, marker, max, offset)
   self.max = max
   self.tiles = {}
   self.highlights = {}

   self.offset = vector.new(offset)
   self.deck = deck
   self.board = board
   self.marker = marker
   self:update()
end

function Hand:idx2center(ii)
   return self.offset + {ii * tw, 0}
end

function Hand:worldpos2loc(pos)
   pos = pos - self.offset
   local xx = util.round(pos[1] / tw)
   local yy = util.round(pos[2] / th)

   if xx < 1 or xx > self.max or yy ~= 0 then
      return nil
   else
      return xx
   end
end

function Hand:worldpos2center(pos)
   local loc = self:worldpos2loc(pos)
   if loc then
      return self:idx2center(loc)
   else
      return nil
   end
end

function Hand:worldpos2rect(pos)
   local cc = self:worldpos2center(pos)
   if cc then
      return Rect.centered(cc, tw, th)
   else
      return nil
   end
end

function Hand:draw(ii, ganim)
   local anim = ganim or Sequence()
   local tile = self.deck:draw()
   if not tile then
      return nil
   end

   self.tiles[ii] = tile
   anim:animate_between(tile:go(), tile:pos(), self:idx2center(ii), .3)
   anim:next(tile:bind('show'))
   anim:next(tile:bind('fpos'), self:idx2center(ii))

   -- automatically animate unless we were given one
   if not ganim then
      anim:start()
   end
end

function Hand:take(ii)
   local result = self.tiles[ii]
   self.tiles[ii] = nil
   return result
end

function Hand:valid_tiles()
   local wantnum = self.board:wants_number()
   local valids = {}
   for ii=1,self.max do
      if self.tiles[ii] then
         local isnum = self.tiles[ii]:isnumber()
         if wantnum == isnum then
            table.insert(valids, ii)
         end
      end
   end
   return valids
end

function Hand:remove_highlights()
   for ii=1,#self.highlights do
      self.highlights[ii]:delete_me(1)
   end
   self.highlights = {}
end

function Hand:terminate()
   self:remove_highlights()
end

function Hand:update()
   local anim = Sequence()
   for ii=1,self.max do
      if not self.tiles[ii] then
         self:draw(ii, anim)
      end
   end

   -- remove old highlights
   self:remove_highlights()

   -- add new highlights
   local hl = function()
      local valids = self:valid_tiles()

      for ii=1,#valids do
         local cc = self:idx2center(valids[ii])
         table.insert(self.highlights,
                      stage:add_component('CTestDisplay', {offset=cc, w=tw, h=th,
                                                           color={1,1,1,.3}}))
      end
   end
   anim:next(hl)
   anim:start()
end

function Hand:no_more_moves()
   return util.empty(self:valid_tiles()) or not self.board:next_active()
end

local GAME_OVER = constant.NEXT_EPHEMERAL_MESSAGE()
function Hand:check_game_over()
   if self:no_more_moves() then
      stage:send_message(stage:create_message(GAME_OVER))
   end
end

Deck = oo.class(oo.Object)
function Deck:init(offset, values, shuffle)
   self.offset = vector.new(offset)

   if shuffle then
      values = util.rand_shuffle(values)
   end

   self.tiles = {}
   for ii=1,#values do
      local tile = Tile(self.offset, values[ii], 'EAST')
      tile:hide()
      table.insert(self.tiles, tile)
   end
end

function Deck:terminate()
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
      if self.tiles[ii]:isnumber() then
         local tile = self.tiles[ii]
         table.remove(self.tiles, ii)
         return tile
      end
   end
end

function Deck:pos()
   return self.offset
end

function Deck:empty()
   return util.empty(self.tiles)
end

function add_controls()
   local hl = stage:add_component('CTestDisplay', {w=tw, h=th,
                                                   color={1,1,1,.3}})
   local click = util.rising_edge_trigger(false)

   local controls = function()
      local mouse = util.mouse_state()
      local input = util.input_state()

      local hrect = hand:worldpos2rect(mouse)
      local brect = board:lastrect()

      if hrect then
         local ii = hand:worldpos2loc(mouse)
         local valids = hand:valid_tiles()
         local isvalid = util.contains(valids, ii)

         if isvalid then
            hl:offset(hrect:center())
         else
            hl:offset({-100, -100})
         end

         -- selected?
         if click(input.mouse1) then
            if isvalid then
               local tile = hand:take(ii)

               -- defalt to the orientation of the previous tile
               local last = board:lastrec()
               tile:direction(last.tile.d)

               local anim = board:place_animated(tile)
               marker:update_animated(anim)
               anim:next(bind(play_sfx, 'thunk'))
               anim:next(hand:bind('update'))
               anim:next(hand:bind('check_game_over'))
            end
         end
      elseif brect:contains(mouse) and #board.tiles > 1then
         hl:offset(brect:center())

         if click(input.mouse1) then
            local anim = board:rotate_animated()
            anim:next(hand:bind('update'))
         end
      else
         hl:offset({-100, -100})
      end
   end

   local messages = function()
      if stage:has_message(GAME_OVER) then
         local testwin = levels[level_idx].win
         local anim = Sequence()

         if testwin() then
            -- next level!
            local level = levels[level_idx]
            level.win_animation(anim)

            level_idx = level_idx + 1
            if level_idx > #levels then
               -- you win them all! (make it worth it)
               level_idx = 1
            end
         end
         anim:next(bind(setup_level, level_idx))
         anim:start()
      end
   end

   cscript = stage:add_component('CScripted', {update_thread=util.fthread(controls),
                                               message_thread=util.fthread(messages)})
end

function clean()
   world:delete_me(1)
   world = game:create_world()
   stage = world:stage()

   world:gravity({0,0})

   local cam = stage:find_component('Camera', nil)
   cam:pre_render(util.fthread(background))
end

function setup_level(idx)
   clean()

   local cam = stage:find_component('Camera', nil)
   local screen_rect = Rect(cam:viewport())
   local screen_width = screen_rect:width()
   local screen_height = screen_rect:height()

   local level = levels[idx]
   local bstr = level.bstr
   local dstr = level.dstr
   local boardspec = parse_board(bstr, dstr)
   local score_offset = vector.new({0,0})

   if level.desc then
      local font = font_factory(1)
      local desc = Indicator(font, {screen_width/2, screen_height-th/2},
                             {0,0,0,1})
      local text = font:wrap_string(level.desc, screen_width-tw)
      desc:update(text)
      score_offset[2] = -font:string_height(text) - th/2
   end

   if not level.score then
      -- hide the score
      score_offset[2] = -10000
   end

   deck = Deck(vector.new({screen_width-tw, th}), boardspec.deck, false)

   score = Indicator(font_factory_big(1),
                     score_offset + {screen_width/2, screen_height-th/2},
                     {0,0,0,1}, stage)

   board = Board(vector.new({0, 1.5*th}), deck, boardspec)

   marker = Marker(board, score)
   hand = Hand(deck, board, marker, 5, vector.new({0,th}))

   steam_manager = SteamManager(2)

   score:update('0')
   add_controls()
   util.loop_music({'resources/waterdancer.ogg'})
end

function init()
   util.install_basic_keymap()
   util.install_mouse_map()

   setup_level(level_idx)
end

function game_init()
   util.protect(init)()

   load_sfx('thunk', {'resources/thunk.ogg'})
end
