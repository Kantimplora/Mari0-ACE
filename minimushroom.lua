minimushroom = class:new()

function minimushroom:init(x, y)
	--PHYSICS STUFF
	self.x = x-2/16
	self.y = y-11/16
	self.speedy = 0
	self.speedx = 0
	self.width = 6/16
	self.height = 6/16
	self.static = true
	self.active = true
	self.category = 6
	self.mask = {	true,
					false, false, true, true, true,
					false, true, false, true, true,
					false, true, true, false, true,
					true, true, false, true, true,
					false, true, true, false, false,
					true, false, true, true, true,
					false, true}
	self.destroy = false
	self.autodelete = true
	
	--IMAGE STUFF
	self.drawable = false
	self.graphic = itemsimg
	self.quad = itemsquad[spriteset][7]
	self.offsetX = 3
	self.offsetY = 6
	self.quadcenterX = 8
	self.quadcenterY = 12
	
	self.rotation = 0 --for portals
	self.uptimer = 0
	
	self.falling = false
	self.light = 0.8
end

function minimushroom:update(dt)
	--rotate back to 0 (portals)
	self.rotation = math.mod(self.rotation, math.pi*2)
	if self.rotation > 0 then
		self.rotation = self.rotation - portalrotationalignmentspeed*dt
		if self.rotation < 0 then
			self.rotation = 0
		end
	elseif self.rotation < 0 then
		self.rotation = self.rotation + portalrotationalignmentspeed*dt
		if self.rotation > 0 then
			self.rotation = 0
		end
	end
	
	if edgewrapping then --wrap around screen
		local minx, maxx = -self.width, mapwidth
		if self.x < minx then
			self.x = maxx
		elseif self.x > maxx then
			self.x = minx
		end
	end
	
	if self.uptimer < mushroomtime then
		self.uptimer = self.uptimer + dt
		self.y = self.y - dt*(1/mushroomtime-8/16)
		self.speedx = mushroomspeed
		
	else
		if self.static == true then
			self.static = false
			self.active = true
			self.drawable = true
		end
	end
	
	if self.destroy then
		return true
	else
		return false
	end
end

function minimushroom:draw()
	if self.uptimer < mushroomtime and not self.destroy then
		--Draw it coming out of the block.
		love.graphics.draw(itemsimg, self.quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), math.floor(((self.y-yscroll)*16-self.offsetY)*scale), 0, scale, scale, self.quadcenterX, self.quadcenterY)
	end
end

function minimushroom:leftcollide(a, b)
	self.speedx = mushroomspeed
	
	if a == "player" then
		self:use(a, b)
	end
	
	return false
end

function minimushroom:rightcollide(a, b)
	self.speedx = -mushroomspeed
	
	if a == "player" then
		self:use(a, b)
	end
	
	return false
end

function minimushroom:floorcollide(a, b)
	if a == "player" then
		self:use(a, b)
	end	
end

function minimushroom:ceilcollide(a, b)
	if a == "player" then
		self:use(a, b)
	end	
end

function minimushroom:passivecollide(a, b)
	if a == "player" then
		self:use(a, b)
	end	
	if a == "donut" then
		return false
	end	
end

function minimushroom:use(a, b)
	b:grow(-1)
	self.active = false
	self.destroy = true
	self.drawable = false
end

function minimushroom:jump(x)
	self.falling = true
	self.speedy = -mushroomjumpforce
	if self.x+self.width/2 < x-0.5 then
		self.speedx = -mushroomspeed
	elseif self.x+self.width/2 > x-0.5 then
		self.speedx = mushroomspeed
	end
end