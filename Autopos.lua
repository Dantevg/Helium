--- Position nodes automatically according to document flow.
-- @module helium.Autopos
-- @set no_return_or_parms=true

local Autopos = {}

Autopos.vert = {}

--- Get the x-position in a vertical flow.
-- @treturn number x
function Autopos.vert:X()
	return self.parent and self.parent.inner:X() + (self.x or 0) or 0
end
--- Get the y-position in a vertical flow.
-- @treturn number y
function Autopos.vert:Y()
	local prev = self:sibling(-1)
	return prev and prev.outer:Y() + prev.outer:H() + (self.y or 0)
		or (self.parent and self.parent.inner:Y() + (self.y or 0) or 0)
end

Autopos.hor = {}

--- Get the x-position in a horizontal flow.
-- @treturn number x
function Autopos.hor:X()
	local prev = self:sibling(-1)
	return prev and prev.outer:X() + prev.outer:W() + (self.x or 0)
		or (self.parent and self.parent.inner:X() + self.x or 0)
end
--- Get the y-position in a horizontal flow.
-- @treturn number y
function Autopos.hor:Y()
	return self.parent and self.parent.inner:Y() + (self.y or 0) or 0
end

return Autopos
