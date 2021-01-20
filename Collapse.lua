local CollapseBase = require "helium.CollapseBase"

local Collapse = {}
Collapse.__index = Collapse

function Collapse.new(x, y, w, h)
	local self = CollapseBase(x, y, w, h)
	table.insert(self.tags, 1, "Collapse")
	
	return setmetatable(self, Collapse)
end

return setmetatable(Collapse, {
	__index = CollapseBase,
	__call = function(_, ...) return Collapse.new(...) end,
})
