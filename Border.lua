--- @submodule helium

local Box = require "helium.Box"

local Border = {}
Border.__index = Border

--- Create a new Border.
-- The border will automatically take the outer size of its parent element.
-- @treturn Border the new border node
-- @see Box
function Border.new()
	local self = Box()
	table.insert(self.tags, 1, "Border")
	return setmetatable(self, Border)
end

--- @type Border

function Border:X() return self.parent and self.parent.outer:X() or 0 end
function Border:Y() return self.parent and self.parent.outer:Y() or 0 end

function Border:W() return self.parent and self.parent.outer:W() or 0 end
function Border:H() return self.parent and self.parent.outer:H() or 0 end

function Border:drawself(canvas)
	canvas:colour(table.unpack(self:Style("colour")))
	canvas:rect(self:X(), self:Y(), self:W(), self:H())
end

function Border:__tostring()
	return "Border"
end

return setmetatable(Border, {
	__index = Box,
	__call = function(_, ...) return Border.new(...) end,
})
