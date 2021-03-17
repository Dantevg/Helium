--- @submodule helium

local Dimensions = require "helium.Dimensions"

local Node = {}
Node.__index = Node

--- Create a new Node.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @treturn Node the new node
function Node.new(x, y)
	local self = {}
	self.x = x
	self.y = y
	self.outer = Dimensions.outer(self)
	self.inner = Dimensions.inner(self)
	self.tags = {"*"}
	self.style = {}
	self.on = {}
	self.nodes = {}
	self.memo = {}
	return setmetatable(self, Node)
end

--- @type Node

--- Get the x-position.
-- @treturn number x
function Node:X()
	return (self.x or 0) + (self.parent and self.parent.inner:X() or 0)
end
--- Get the y-position.
-- @treturn number y
function Node:Y()
	return (self.y or 0) + (self.parent and self.parent.inner:Y() or 0)
end

--- Get a style value of this node, or of `node`.
-- @tparam string style the style to get
-- @tparam[opt] Node node the node for which to get the style
-- @return the style value, or `nil` when the style is not found
function Node:Style(style, node)
	node = node or self
	return self.style[style] or (self.parent and self.parent:Style(style, node))
end

--- Insert a as a child of this node.
-- @tparam Node node the child node to insert
-- @tparam[opt] number i the position at which to place the child node
-- @treturn Node the child node just inserted
function Node:insert(node, i)
	node.parent = self
	table.insert(self.nodes, i or #self.nodes+1, node)
	return node
end

--- Find a child node.
-- The function `fn` receives the node and the index of this node,
-- and should return a boolean indicating whether this node is wanted.
-- @tparam function fn
-- @treturn Node|nil the first node found, or `nil` when no nodes found
-- @usage
-- -- Find index of self in parent
-- self.parent:find(function(n) return n == self end)
function Node:find(fn)
	if not self.nodes then return end
	for i, node in ipairs(self.nodes) do
		if fn(node, i) then return node, i end
	end
end

--- Get the n-th sibling of this node.
-- @tparam[opt=0] number n the **relative** number of the sibling to get.
-- I.e. `0` is `self`, `-1` is the previous sibling and `1` is the next sibling
-- @treturn Node|nil the sibling node, or `nil` when no node found
function Node:sibling(n)
	if not self.parent then return end
	local _, i = self.parent:find(function(x) return x == self end)
	return i and self.parent.nodes[i+(n or 0)]
end

--- Draw this node and its children.
-- Will first draw self using `drawself`,
-- after which it will draw its child nodes.
-- @param canvas the canvas to draw to
function Node:draw(canvas)
	if self.drawself then self:drawself(canvas) end
	for _, node in ipairs(self.nodes) do
		node:draw(canvas)
	end
	self.memo = {} -- Reset memoisation table
end

--- Handle incoming events.
-- @param event the event that happened
-- @param[opt] ... the event parameters
-- @treturn[1] nil normally
-- @treturn[2] boolean `false` when this node or one of its child nodes
-- had a callback for this event and returned `false`.
-- I.e. stop further handling this event.
function Node:event(...)
	-- First call nodes lowest in hierarchy
	if self.nodes then
		for _, node in ipairs(self.nodes) do
			if node:event(...) == false then return false end
		end
	end
	
	-- Then call self
	local params = {...}
	local event = table.remove(params, 1)
	if self.on[event] then return self.on[event](self, params) end
end

--- Check whether coordinates fall within this node's bounding box.
-- @tparam number x
-- @tparam number y
-- @treturn boolean within
function Node:within(x, y)
	return x >= self.outer:X() and x <= self.outer:X() + self.outer:W()
		and y >= self.outer:Y() and y <= self.outer:Y() + self.outer:H()
end

--- Memoise a value.
-- @param the name of the memoised value
-- @tparam function calc the function to generate the memoised value
-- @return value the memoised (or calculated) value
function Node:Memo(name, calc, ...)
	if self.memo[name] then return self.memo[name] end
	self.memo[name] = calc(...)
	return self.memo[name]
end

function Node:__tostring()
	return string.format("Node @ (%d,%d)", self.x, self.y)
end

return setmetatable(Node, {__call = function(_, ...) return Node.new(...) end})
