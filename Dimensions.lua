--- Store a node's inner and outer dimensions.
-- @module helium.Dimensions
-- @set no_return_or_parms=true

local Dimensions = {}

function Dimensions.new(node)
	local self = {}
	self.node = node
	return setmetatable(self, Dimensions)
end



Dimensions.outer = {}
Dimensions.outer.__index = Dimensions.outer

--- @type Dimensions.outer

--- Create a new outer Dimensions container.
-- @tparam helium.Node node
-- @treturn Dimensions.outer
function Dimensions.outer.new(node)
	local self = Dimensions.new(node)
	return setmetatable(self, Dimensions.outer)
end

--- Get the outer x-position.
-- @treturn number x
function Dimensions.outer:X()
	return self.node:Memo("outer.X", function() return self.node.X and self.node:X() or 0 end)
end
--- Get the outer y-position.
-- @treturn number y
function Dimensions.outer:Y()
	return self.node:Memo("outer.Y", function() return self.node.Y and self.node:Y() or 0 end)
end
--- Get the outer width.
-- @treturn number width
function Dimensions.outer:W()
	return self.node:Memo("outer.W", function() return self.node.W and self.node:W() or 0 end)
end
--- Get the outer height.
-- @treturn number height
function Dimensions.outer:H()
	return self.node:Memo("outer.H", function() return self.node.H and self.node:H() or 0 end)
end

setmetatable(Dimensions.outer, {
	__index = Dimensions,
	__call = function(_, ...) return Dimensions.outer.new(...) end,
})



Dimensions.inner = {}
Dimensions.inner.__index = Dimensions.inner

--- @type Dimensions.inner

--- Create a new inner Dimensions container.
-- @tparam helium.Node node
-- @treturn Dimensions.inner
function Dimensions.inner.new(node)
	local self = Dimensions.new(node)
	return setmetatable(self, Dimensions.inner)
end

--- Get the inner x-position.
-- @treturn number x
function Dimensions.inner:X()
	return (self.node.outer and self.node.outer:X() or 0)
		+ (self.node.padding or 0)
end
--- Get the inner y-position.
-- @treturn number y
function Dimensions.inner:Y()
	return (self.node.outer and self.node.outer:Y() or 0)
		+ (self.node.padding or 0)
end
--- Get the inner width.
-- @treturn number width
function Dimensions.inner:W()
	return (self.node.outer and self.node.outer:W() or 0)
		- 2*(self.node.padding or 0)
end
--- Get the inner height.
-- @treturn number height
function Dimensions.inner:H()
	return (self.node.outer and self.node.outer:H() or 0)
		- 2*(self.node.padding or 0)
end

setmetatable(Dimensions.inner, {
	__index = Dimensions,
	__call = function(_, ...) return Dimensions.inner.new(...) end,
})



return setmetatable(Dimensions, {
	__call = function(_, ...) return Dimensions.new(...) end,
})
