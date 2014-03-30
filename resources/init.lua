local oo = require 'oo'
local sfx = require 'sfx'
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

function clear()
   czor:clear_with_color({0,0,0,0})
end

local HexGrid = oo.class(oo.Object)
function HexGrid:init(size)
   self.size = size
   self.height = size * 2
   self.vsep = 3 * self.height / 4
   self.width = math.sqrt(3) * size / 2
   self.hsep = self.width
end

function HexGrid:axial_to_cube(acoord)
   local x = acoord[1]
   local z = acoord[2]
   local y = -(x + z)
   return {x, y, z}
end

function HexGrid:cube_to_axial(ccoord)
   return {ccoord[1], ccoord[3]}
end

function HexGrid:center(acoord)
   local x = self.size * math.sqrt(3) * (acoord[1] + acoord[2] / 2)
   local y = self.size * 3 * acoord[2] / 2
   return vector.new({x, y})
end

function HexGrid:dist(a1, a2)
   local c1 = self:axial_to_cube(a1)
   local c2 = self:axial_to_cube(a2)
   local mhd = math.abs(c1[1] - c2[1]) + math.abs(c1[2] - c2[2]) + math.abs(c1[3] - c2[3])
   return mhd / 2
end

HexGrid.neighbors = {
   {1, -1, 0}, {1, 0, -1}, {0, 1, -1},
   {-1, 1, 0}, {-1, 0, 1}, {0, -1, 1}
}

HexGrid.diagonals = {
   {2, -1, -1}, {1, 1,  -2}, {-1, 2, -1},
   {-2, 1,  1}, {-1, -1, 2}, {1, -2,  1}
}

function HexGrid:add_cube(c1, c2)
   return {c1[1] + c2[1], c1[2] + c2[2], c1[3] + c2[3]}
end

function HexGrid:neighbor(acoord, n)
   local ccoord = self:axial_to_cube(acoord)
   return self:cube_to_axial(self:add_cube(ccoord, HexGrid.neighbors[n]))
end

function HexGrid:diagonal(acoord, n)
   local ccoord = self:axial_to_cube(acoord)
   return self:cube_to_axial(self:add_cube(ccoord, HexGrid.diagonals[n]))
end

function HexGrid:polar(dist, angle)
   return vector.new({dist * math.cos(angle), dist * math.sin(angle)})
end

function HexGrid:hex_lines(mesh, center, size, color)
   local step = math.pi * 2 / 6

   local start = center + self:polar(size, step * 0.5)
   local last = start

   for i = 1,5 do
      local current = center + self:polar(size, step * (i + 0.5))
      mesh:add_point(last, color)
      mesh:add_point(current, color)
      last = current
   end

   mesh:add_point(last, color)
   mesh:add_point(start, color)
end

function HexGrid:round_cube(cube)
   local rx = util.round(cube[1])
   local ry = util.round(cube[2])
   local rz = util.round(cube[3])

   local xdiff = math.abs(rx - cube[1])
   local ydiff = math.abs(ry - cube[2])
   local zdiff = math.abs(rz - cube[3])

   if xdiff > ydiff and xdiff > zdiff then
      rx = -ry - rz
   elseif ydiff > zdiff then
      ry = -rx - rz
   else
      rz = -rx - ry
   end

   return {rx, ry, rz}
end

function HexGrid:round_axial(axial)
   return self:cube_to_axial(self:round_cube(self:axial_to_cube(axial)))
end

function HexGrid:point_to_axial(point)
   local q = (point[1] * math.sqrt(3) / 3 - point[2] / 3) / self.size
   local r = 2 * point[2] / (3 * self.size)
   return self:round_axial({q, r})
end

function spawn_mesh()
   local mesh = game:create_object('Mesh')
   local vprect = Rect(camera:viewport())
   local swidth = vprect:width()
   local sheight = vprect:height()
   local scenter = vector.new({swidth/2, sheight/2})

   local grid = HexGrid(24)

   mesh:type(constant.LINES)

   local font = font_factory(0.8)
   local w = {1,1,1,1}

   for xx = -4,4 do
      for yy = -4,4 do
         zz = -(xx + yy)
         local center = scenter + grid:center({xx, yy})
         grid:hex_lines(mesh, vector.new(center), grid.size, w)

         local str = string.format('%d,%d', xx, yy)
         local strw = font:string_width(str)
         stage:add_component('CDrawText', {font=font, color={1,1,1,1}, message=str,
                                           offset=center - {strw/2, 0},
                                           layer=constant.BACKGROUND})

      end
   end

   stage:add_component('CMesh', {mesh=mesh})
   return {grid=grid, center=scenter}
end

function init()
   util.install_basic_keymap()
   util.install_mouse_map()

   camera:pre_render(util.fthread(clear))

   local grid = spawn_mesh()
   local mesh = game:create_object('Mesh')
   mesh:type(constant.LINES)
   local cmesh = stage:add_component('CMesh', {mesh=mesh})

   local thread = function()
      local mouse = util.mouse_state() - grid.center
      local axial = grid.grid:point_to_axial(mouse)
      local center = grid.center + grid.grid:center(axial)
      mesh:clear()
      grid.grid:hex_lines(mesh, center, grid.grid.size-5, {1,0,1,1})
   end
   stage:add_component('CScripted', {update_thread=util.fthread(thread)})
end

function game_init()
   util.protect(init)()
end
