--- @submodule helium

local Box = require "helium.Box"
local Autopos = require "helium.Autopos"

local List = {}
List.__index = List

--- Create a new List node.
-- Elements inserted into this node will automatically be placed in
-- a vertical list form, one after the other.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @treturn List the new list node
-- @see Box
function List.new(x, y, w, h)
	local self = Box(x, y, w, h)
	table.insert(self.tags, 1, "List")
	return setmetatable(self, List)
end

--- @type List

function List:insert(node, i)
	Box.insert(self, node, i)
	node.X = Autopos.vert.X
	node.Y = Autopos.vert.Y
	return node
end

function List:__tostring()
	return string.format("List @ (%d,%d) %d nodes", self.x, self.y, #self.nodes)
end

return setmetatable(List, {
	__index = Box,
	__call = function(_, ...) return List.new(...) end,
})
