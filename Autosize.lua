--- Size nodes to fit parent or content.
-- @module helium.Autosize
-- @set no_return_or_parms=true

local Autosize = {}

Autosize.fitParent = {}

--- Get the width so that the node fits its parent's width.
-- @treturn number width
function Autosize.fitParent:W()
	return self.parent
		and self.parent.inner:W() - (self.outer:X() - self.parent.inner:X())
		or 0
end
--- Get the height so that the node fits its parent's height.
-- @treturn number height
function Autosize.fitParent:H()
	return self.parent
		and self.parent.inner:H() - (self.outer:Y() - self.parent.inner:Y())
		or 0
end

Autosize.fitContent = {}

--- Get the width so that the node fits its content's width.
-- @treturn number width
function Autosize.fitContent:W()
	if not self.nodes then return 0 end
	local max = 0
	for _, node in ipairs(self.nodes) do
		if node.W ~= Autosize.fitParent.W then
			max = math.max(max, node.outer:W())
		end
	end
	return max + 2*(self.padding or 0)
end
--- Get the height so that the node fits its content's height.
-- @treturn number height
function Autosize.fitContent:H()
	if not self.nodes then return 0 end
	local max = 0
	for _, node in ipairs(self.nodes) do
		if node.W ~= Autosize.fitParent.H then
			max = math.max(max, node.outer:H())
		end
	end
	return max + 2*(self.padding or 0)
end

return Autosize