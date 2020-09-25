muncher = class:new()

function muncher:init(x, y, physics)
	--PHYSICS STUFF
	self.x = x-7/16
	self.y = y-13/16
	self.speedy = 0
	self.speedx = 0
	self.width = 14/16
	self.height = 14/16
	self.static = true
	self.active = true
	self.category = 4
	
	self.mask = {	true, 
					false, false, false, false, true,
					false, true, false, true, false,
					false, false, true, false, false,
					true, true, false, false, false,
					false, true, true, false, false,
					true, false, true, true, true,
					false, true}
	
	--IMAGE STUFF
	self.drawable = true
	self.graphic = muncherimg
	self.quadi = 1
	self.quad = starquad[spriteset][self.quadi]
	self.offsetX = 7
	self.offsetY = 2
	self.quadcenterX = 8
	self.quadcenterY = 8
	
	self.direction = "left"
	self.animationtimer = 0

	self.rotation = 0

	self.extremeautodelete = true

	self.shot = false

	if physics then
		self.static = false
		self.offscreenstatic = true

		self.weight = 2
	end

	self.supersizeup = true
	self.supersizeoffsetx = .5
end

function muncher:update(dt)
	if self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		
		return false
	end

	if self.offscreenstatic then
		self.static = not onscreen(self.x-2, self.y-2, self.width+4, self.height+4)
		if self.static then
			return false
		end
	end

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

	if self.speedx > 0 then
		self.speedx = self.speedx - friction*dt
		if self.speedx < 0 then
			self.speedx = 0
		end
	else
		self.speedx = self.speedx + friction*dt
		if self.speedx > 0 then
			self.speedx = 0
		end
	end

	self.animationtimer = self.animationtimer + dt
	while self.animationtimer > muncheranimationspeed do
		self.animationtimer = self.animationtimer - muncheranimationspeed
		if self.quadi == 1 then
			self.quadi = 2
		else
			self.quadi = 1
		end
		self.quad = starquad[spriteset][self.quadi]
	end
	
	return false
end

function muncher:shotted(dir, cause) --fireball, star, turtle
	self.claw = false
	self.dead = true
	if (cause ~= "powblock") or (self.speedy > 0) then
		return false
	end
	playsound(shotsound)
	self.shot = true
	self.speedy = -shotjumpforce
	self.direction = dir or "right"
	self.active = false
	self.gravity = shotgravity
	self.autodelete = true
	if self.direction == "left" then
		self.speedx = -shotspeedx
	else
		self.speedx = shotspeedx
	end
	return false
end

function muncher:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	return true
end

function muncher:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	return true
end

function muncher:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return true
	end
end

function muncher:globalcollide(a, b)
end

function muncher:startfall()

end

function muncher:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return true
	end

	if mariohammerkill[a] then
		if a == "enemy" then
			if b:shotted("right", nil, nil, false, true) then
				addpoints(firepoints[b.t] or 100, self.x, self.y)
			end
		else
			b:shotted("right")
			if a ~= "bowser" then
				addpoints(firepoints[a], self.x, self.y)
			end
		end
	end
end

function muncher:passivecollide(a, b)
	self:leftcollide(a, b)
	return false
end