pedestal = class:new()

function pedestal:init(x, y, t)
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.width = 1
	self.height = 1
	self.speedx = 0
	self.speedy = 0
	self.portals = t or "both"
	self.active = true
	self.static = true
	self.category = 23
	self.mask = {true, true, false}
	self.quadi = 1
	self.gun = true
	self.timer = 0
end

function pedestal:draw()
	if pedestalimage:getWidth() == 160 and (not reset) then --damm old graphics
		love.graphics.draw(pedestalimage, pedestalquad[spriteset][self.quadi], math.floor((self.cox-1-xscroll)*16*scale), ((self.y-0.5-yscroll)*16*scale), 0, scale, scale)
	else
		love.graphics.setColor(255,255,255)--added the dot so it chages color
		love.graphics.draw(pedestalimage, pedestalquad[spriteset][self.quadi], math.floor((self.cox-1-xscroll)*16*scale), ((self.y-0.5-yscroll)*16*scale), 0, scale, scale)
		if self.portals == "2 only" then
			love.graphics.setColor(portalcolor[1][2])
		else
			love.graphics.setColor(portalcolor[1][1])
		end
		if self.gun then
			love.graphics.draw(pedestalimage, pedestalquad[spriteset][2], math.floor((self.cox-1-xscroll)*16*scale), ((self.y-0.5-yscroll)*16*scale), 0, scale, scale)
		end
	end
end

function pedestal:update(dt)
	if not self.gun then
		if self.quadi ~= 11 then
			self.timer = self.timer + dt
			if self.timer > 0.1 then
				self.quadi = self.quadi + 1
				self.timer = 0
			end
		end
	end
end

function pedestal:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	return false
end

function pedestal:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	return false
end

function pedestal:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function pedestal:globalcollide(a, b)
	if a == "player" and self.gun then
		b.pickupgun = true
		self.quadi = 3
		self.gun = false
		self.active = false
	end
end

function pedestal:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function pedestal:passivecollide(a, b)
	self:leftcollide(a, b)
	return false
end