--- @submodule helium

local Box = require "helium.Box"

local Square = {}
Square.__index = Square

--- Create a new Square node.
-- @tparam number|nil x the horizontal position of the node
-- @tparam number|nil y the vertical position of the node
-- @tparam number size the size of the node
-- @treturn Square the new square node
-- @see Box
function Square.new(x, y, size)
	local self = Box(x, y, size, size)
	table.insert(self.tags, 1, "Square")
	self.size = size
	return setmetatable(self, Square)
end

--- @type Square

--- Get the size.
-- @treturn number size
function Square:Size() return self.size end
function Square:W() return self:Size() end
function Square:H() return self:Size() end

function Square:__tostring()
	return string.format("Square @ (%d,%d) %dx%d", self.x, self.y, self.size, self.size)
end

return setmetatable(Square, {
	__index = Box,
	__call = function(_, ...) return Square.new(...) end,
})
