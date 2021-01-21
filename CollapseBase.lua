--- @submodule helium

local Box = require "helium.Box"
local Autopos = require "helium.Autopos"

local CollapseBase = {}
CollapseBase.__index = CollapseBase

--- Create a new CollapseBase node.
-- This node can contain 2 child nodes. The first node will always be
-- visible, while the second node will only be visible when this node
-- is not collapsed. When clicked on (receiving the `click` event),
-- will automatically toggle its collapsed state.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @treturn CollapseBase the new collapse base node
-- @see Box
function CollapseBase.new(x, y, w, h)
	local self = Box(x, y, w, h)
	table.insert(self.tags, 1, "CollapseBase")
	self.collapsed = false
	
	return setmetatable(self, CollapseBase)
end

--- @type CollapseBase

--- Get whether the node is collapsed.
-- @treturn boolean collapsed
function CollapseBase:Collapsed() return self.collapsed or false end

function CollapseBase:drawself(canvas) end -- Don't draw self

function CollapseBase:insert(node, i)
	if #self.nodes >= 2 then error("Collapse can contain at most 2 elements") end
	Box.insert(self, node, i)
	node.X = Autopos.vert.X
	node.Y = Autopos.vert.Y
end

function CollapseBase:draw(canvas)
	if self.nodes[1] then self.nodes[1]:draw(canvas) end
	if self.nodes[2] and not self:Collapsed() then self.nodes[2]:draw(canvas) end
end

function CollapseBase.on.click(self, x, y)
	if self.nodes[1] and self.nodes[1]:within(x, y) then
		self.collapsed = not self.collapsed
	end
end

function CollapseBase:__tostring()
	return string.format("Collapse @ (%d,%d) %s",
		self.x, self.y, self.collapsed and "collapsed" or "opened")
end

return setmetatable(CollapseBase, {
	__index = Box,
	__call = function(_, ...) return CollapseBase.new(...) end,
})
