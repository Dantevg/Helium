local Dimensions = require "helium.Dimensions"

local Node = {}
Node.__index = Node

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
	return setmetatable(self, Node)
end

function Node:X()
	return (self.x or 0) + (self.parent and self.parent.inner:X() or 0)
end
function Node:Y()
	return (self.y or 0) + (self.parent and self.parent.inner:Y() or 0)
end

function Node:insert(node, i)
	node.parent = self
	table.insert(self.nodes, i or #self.nodes+1, node)
	return node
end

function Node:find(fn)
	if not self.nodes then return end
	for i, node in ipairs(self.nodes) do
		if fn(node, i) then return node, i end
	end
end

function Node:sibling(n)
	if not self.parent then return end
	local _, i = self.parent:find(function(x) return x == self end)
	return i and self.parent.nodes[i+n]
end

function Node:Style(style, node)
	node = node or self
	return self.style[style] or (self.parent and self.parent:Style(style, node))
end

function Node:draw(canvas)
	if self.drawself then self:drawself(canvas) end
	for _, node in ipairs(self.nodes) do
		node:draw(canvas)
	end
end

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

function Node:within(x, y)
	return x >= self.outer:X() and x <= self.outer:X() + self.outer:W()
		and y >= self.outer:Y() and y <= self.outer:Y() + self.outer:H()
end

function Node:__tostring()
	return string.format("Node @ (%d,%d)", self.x, self.y)
end

return setmetatable(Node, {__call = function(_, ...) return Node.new(...) end})
