ceilblocker = class:new()

function ceilblocker:init(x, y, r)
	self.justthisspot = false
	
	self.r = r
	local v = convertr(r, {"bool"}, true)
	if v[1] ~= nil then
		self.justthisspot = v[1]
	end

	if self.justthisspot then
		self.x = x-1
		self.y = y-1
		self.height = 1
		self.width = 1
	else
		self.x = x-1
		self.y = -1000
		self.height = 1000
		self.width = 1
	end
	self.static = true
	self.active = true
end