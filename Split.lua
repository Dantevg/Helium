--- @submodule helium

local Box = require "helium.Box"
local Autopos = require "helium.Autopos"
local Autosize = require "helium.Autosize"

local Split = {}
Split.__index = Split

--- Create a new Split node.
-- This node can contain 2 child nodes. The child nodes will automatically
-- be sized to fit the split.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @tparam[optchain=0.5] number split the ratio between the sides.
-- @treturn Split the new split node
-- @see Box
function Split.new(x, y, w, h, split)
	local self = Box(x, y, w, h)
	table.insert(self.tags, 1, "Split")
	self.split = split
	return setmetatable(self, Split)
end

--- @type Split

--- Get the split ratio.
-- @treturn number split
function Split:Split() return self.split or 0.5 end

function Split:drawself(canvas) end -- Don't draw self

function Split:__tostring()
	return string.format("Split @ (%d,%d) %dx%d %d%%", self.x, self.y, self.w, self.h, self.split*100)
end



Split.hor = {}
Split.hor.__index = Split.hor

--- Create a new horizontal Split node.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @tparam[optchain=0.5] number split the ratio between the sides.
-- @treturn Split.hor the new horizontal split node
-- @see Split
function Split.hor.new(...)
	local self = Split(...)
	return setmetatable(self, Split.hor)
end

--- @type Split.hor

function Split.hor:insert(node, i)
	if #self.nodes >= 2 then error("Split can contain at most 2 elements") end
	Split.insert(self, node, i)
	local n = #self.nodes
	node.X = function()
		return math.floor(
			self.inner:X()
			+ (n >= 2 and self.inner:W() * self:Split()
			+ (self.padding or 0)/2 or 0)
		)
	end
	node.Y = Autopos.hor.Y
	node.W = function()
		return (n >= 2 and math.ceil or math.floor)(
			self.inner:W() * (n >= 2 and 1-self:Split() or self:Split())
			- (self.padding or 0)/2
		)
	end
	node.H = Autosize.fitParent.H
end

setmetatable(Split.hor, {
	__index = Split,
	__call = function(_, ...) return Split.hor.new(...) end,
})



Split.vert = {}
Split.vert.__index = Split.vert

--- Create a new vertical Split node.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] number w the width of the node
-- @tparam[optchain] number h the height of the node
-- @tparam[optchain=0.5] number split the ratio between the sides.
-- @treturn Split.vert the new vertical split node
-- @see Split
function Split.vert.new(...)
	local self = Split(...)
	return setmetatable(self, Split.vert)
end

--- @type Split.vert

function Split.vert:insert(node, i)
	if #self.nodes >= 2 then error("Split can contain at most 2 elements") end
	Split.insert(self, node, i)
	local n = #self.nodes
	node.X = Autopos.vert.X
	node.Y = function()
		return math.floor(
			self.inner:Y()
			+ (n >= 2 and self.inner:H() * self:Split()
			+ (self.padding or 0)/2 or 0)
		)
	end
	node.W = Autosize.fitParent.W
	node.H = function()
		return (n >= 2 and math.ceil or math.floor)(
			self.inner:H() * (n >= 2 and 1-self:Split() or self:Split())
			- (self.padding or 0)/2
		)
	end
end

setmetatable(Split.vert, {
	__index = Split,
	__call = function(_, ...) return Split.vert.new(...) end,
})



return setmetatable(Split, {
	__index = Box,
	__call = function(_, ...) return Split.new(...) end,
})
