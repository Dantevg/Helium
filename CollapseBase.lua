local Box = require "helium.Box"
local Autopos = require "helium.Autopos"

local CollapseBase = {}
CollapseBase.__index = CollapseBase

function CollapseBase.new(x, y, w, h)
	local self = Box(x, y, w, h)
	table.insert(self.tags, 1, "CollapseBase")
	self.collapsed = false
	
	return setmetatable(self, CollapseBase)
end

function CollapseBase:Collapsed() return self.collapsed or false end

function CollapseBase:drawself(canvas) end -- Don't draw self

function CollapseBase:insert(node, i)
	if #self.nodes >= 2 then error("Collapse can contain at most 2 elements") end
	Box.insert(self, node, i)
	node.X = Autopos.vert.x(node)
	node.Y = Autopos.vert.y(node)
end

function CollapseBase:draw(canvas)
	if self.nodes[1] then self.nodes[1]:draw(canvas) end
	if self.nodes[2] and not self:Collapsed() then self.nodes[2]:draw(canvas) end
end

function CollapseBase:__tostring()
	return string.format("Collapse @ (%d,%d) %s",
		self.x, self.y, self.collapsed and "collapsed" or "opened")
end

return setmetatable(CollapseBase, {
	__index = Box,
	__call = function(_, ...) return CollapseBase.new(...) end,
})
