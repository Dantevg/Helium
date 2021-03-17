--- Store a node's inner and outer dimensions.
-- @module helium.Dimensions
-- @set no_return_or_parms=true

function memo(fn)
	return function(self, ...)
		if self.node.memo and self.node.memo[fn] then return self.node.memo[fn] end
		self.node.memo[fn] = fn(self.node, ...)
		return self.node.memo[fn]
	end
end

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
Dimensions.outer.X = memo(function(self) return self.X and self:X() or 0 end)
--- Get the outer y-position.
-- @treturn number y
Dimensions.outer.Y = memo(function(self) return self.Y and self:Y() or 0 end)
--- Get the outer width.
-- @treturn number width
Dimensions.outer.W = memo(function(self) return self.W and self:W() or 0 end)
--- Get the outer height.
-- @treturn number height
Dimensions.outer.H = memo(function(self) return self.H and self:H() or 0 end)

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
Dimensions.inner.X = memo(function(self)
	return (self.outer and self.outer:X() or 0)
		+ (self.padding or 0)
end)
--- Get the inner y-position.
-- @treturn number y
Dimensions.inner.Y = memo(function(self)
	return (self.outer and self.outer:Y() or 0)
		+ (self.padding or 0)
end)
--- Get the inner width.
-- @treturn number width
Dimensions.inner.W = memo(function(self)
	return (self.outer and self.outer:W() or 0)
		- 2*(self.padding or 0)
end)
--- Get the inner height.
-- @treturn number height
Dimensions.inner.H = memo(function(self)
	return (self.outer and self.outer:H() or 0)
		- 2*(self.padding or 0)
end)

setmetatable(Dimensions.inner, {
	__index = Dimensions,
	__call = function(_, ...) return Dimensions.inner.new(...) end,
})



return setmetatable(Dimensions, {
	__call = function(_, ...) return Dimensions.new(...) end,
})
