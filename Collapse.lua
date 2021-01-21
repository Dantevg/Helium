local CollapseBase = require "helium.CollapseBase"
local Box = require "helium.Box"
local Text = require "helium.Text"
local Autopos = require "helium.Autopos"
local Autosize = require "helium.Autosize"

local Collapse = {}
Collapse.__index = Collapse

function Collapse.new(x, y, w, h, name)
	local self = CollapseBase(x, y, w, h)
	table.insert(self.tags, 1, "Collapse")
	
	self.title = self:insert(Text(0, 0, name))
	
	self.content = self:insert(Box())
	self.content.X = Autopos.vert.x(self.content)
	self.content.Y = Autopos.vert.y(self.content)
	self.content.W = Autosize.FitParent.w(self.content)
	self.content.H = Autosize.FitParent.h(self.content)
	
	return setmetatable(self, Collapse)
end

function Collapse.on.click(self, x, y)
	if self.title:within(x, y) then
		self.collapsed = not self.collapsed
	end
end

function Collapse:insert(node, i)
	CollapseBase.insert(self.content, node, i) -- Insert into content element
end

return setmetatable(Collapse, {
	__index = CollapseBase,
	__call = function(_, ...) return Collapse.new(...) end,
})
