--- @submodule helium

local CollapseBase = require "helium.CollapseBase"
local Text = require "helium.Text"
local List = require "helium.List"
local Autopos = require "helium.Autopos"
local Autosize = require "helium.Autosize"

local Collapse = {}
Collapse.__index = Collapse

--- Create a new Collapse node.
-- This is a convenience wrapper around the @{CollapseBase} node.
-- It is basically a `CollapseBase` with a @{Text} node and a @{List} node.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @tparam[optchain] string name the title of the collapse node
-- @treturn Collapse the new collapse node
-- @see CollapseBase, Text, List
function Collapse.new(x, y, w, h, name)
	local self = CollapseBase(x, y, w, h)
	table.insert(self.tags, 1, "Collapse")
	
	self.title = self:insert(Text(0, 0, name))
	
	self.content = self:insert(List())
	self.content.X = Autopos.vert.X
	self.content.Y = Autopos.vert.Y
	self.content.W = Autosize.FitParent.W
	self.content.H = Autosize.FitParent.H
	
	return setmetatable(self, Collapse)
end

function Collapse:insert(node, i)
	CollapseBase.insert(self.content, node, i) -- Insert into content element
end

return setmetatable(Collapse, {
	__index = CollapseBase,
	__call = function(_, ...) return Collapse.new(...) end,
})
