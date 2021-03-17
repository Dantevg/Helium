--- @submodule helium

local Node = require "helium.Node"

local Text = {}
Text.__index = Text

--- Create a new Text node.
-- @tparam[optchain] number x the horizontal position of the node
-- @tparam[optchain] number y the vertical position of the node
-- @tparam[optchain] string text
-- @treturn Text the new text node
-- @see Node
function Text.new(x, y, text)
	local self = Node(x, y)
	table.insert(self.tags, 1, "Text")
	self.text = tostring(text)
	return setmetatable(self, Text)
end

--- @type Text

--- Get the text.
-- @treturn string text
function Text:Text() return self.text or "" end
--- Get the text's width.
-- @treturn number width
function Text:W() return #self:Text() * (self:Style("fontWidth") or 1) end
--- Get the text's height.
-- @treturn number height
function Text:H() return self:Style("fontHeight") or 1 end

function Text:drawself(canvas)
	canvas:colour(table.unpack(self:Style("colour")))
	canvas:write(self:Text(), self:X(), self:Y())
end

function Text:__tostring()
	return string.format("Text @ (%d,%d) %q", self.x, self.y, self.text)
end

return setmetatable(Text, {
	__index = Node,
	__call = function(_, ...) return Text.new(...) end,
})