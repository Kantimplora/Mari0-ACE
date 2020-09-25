powblock = class:new()

function powblock:init(x, y, t)
	--PHYSICS STUFF
	self.x = x-1
	self.y = y-1
	self.speedy = 0
	self.speedx = 0
	self.width = 1
	self.height = 1
	self.static = false
	self.active = true
	self.category = 2

	self.t = t or "blue"
	
	self.mask = {	true, 
					false, false, false, false, false,
					false, true, false, true, false,
					false, false, true, false, false,
					true, true, false, false, false,
					false, true, true, false, false,
					true, false, true, true, true,
					false, true}
	
	self.emancipatecheck = true
	self.autodelete = true
	self.drawable = false
	
	self.rotation = 0 --for portals

	self.shot = false
	self.explodetimer = 0
	self.scale = 1

	self.light = 3
	self.trackplatform = true
	self.trackplatformpush = true
	self.pipespawnmax = 1
end

function powblock:update(dt)
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

	if self.explode then
		self.explodetimer = self.explodetimer + dt
		self.scale = 1+(math.abs(math.sin(self.explodetimer*30))*(1+self.explodetimer*5))/2
		if self.explodetimer > 0.2 then
			return true
		end
		return false
	else
		if self.speedx > 0 then
			self.speedx = self.speedx - friction*dt*2
			if self.speedx < 0 then
				self.speedx = 0
			end
		elseif self.speedx < 0 then
			self.speedx = self.speedx + friction*dt*2
			if self.speedx > 0 then
				self.speedx = 0
			end
		end
		return false
	end
end

function powblock:draw()
	if self.customscissor then
		love.graphics.setScissor(math.floor((self.customscissor[1]-xscroll)*16*scale), math.floor((self.customscissor[2]-.5-yscroll)*16*scale), self.customscissor[3]*16*scale, self.customscissor[4]*16*scale)
	end
	if self.t == "red" then
		love.graphics.draw(redpowblockimg, coinblockquads[spriteset][coinframe], math.floor((self.x+.5-xscroll)*16*scale), ((self.y+.5-yscroll)*16-8)*scale, 0, scale*self.scale, scale*self.scale, 8, 8)
	else
		love.graphics.draw(powblockimg, coinblockquads[spriteset][coinframe], math.floor((self.x+.5-xscroll)*16*scale), ((self.y+.5-yscroll)*16-8)*scale, 0, scale*self.scale, scale*self.scale, 8, 8)
	end
	love.graphics.setScissor()
end

function powblock:hit()
	playsound(blockhitsound)
	playsound(powblocksound)
	self.explode = true
	self.active = false
	self.claw = false
	self.dead = true

	if self.t == "red" then
		for x = math.floor(self.x-(redpowrange-0.5))+1, math.floor(self.x+(redpowrange+0.5))+1 do
			for y = math.floor(self.y-(redpowrange-0.5))+1, math.floor(self.y+(redpowrange+0.5))+1 do
				--blocks
				hitblock(x, y, {size=2})
				--enemies
				for i2, v2 in pairs(objects) do
					if i1 ~= "tile" and i2 ~= "pixeltile" and i2 ~= "buttonblock" then
						for i, v in pairs(objects[i2]) do
							if v.active and v.shotted and math.ceil(v.x) == x and math.ceil(v.y) == y and (not v.resistsredpowblock) then
								local dir = "right"
								if math.random(1,2)==1 then
									dir = "left"
								end
								v:shotted(dir, "powblock")
							end
						end
					end
				end
			end
		end
	else
		for i2, v2 in pairs(objects) do
			if i1 ~= "tile" and i2 ~= "pixeltile" and i2 ~= "buttonblock" then
				for i, v in pairs(objects[i2]) do
					if v.active and v.shotted and onscreen(v.x,v.y) and (not v.resistspowblock) and v.speedy == 0 then
						local dir = "right"
						if math.random(1,2)==1 then
							dir = "left"
						end
						v:shotted(dir, "powblock")
					end
				end
			end
		end
	end
end

function powblock:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "thwomp" or a == "skewer" or (a == "koopa" and b.small) then
		self:hit()
	end
	return true
end

function powblock:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "thwomp" or a == "skewer" or (a == "koopa" and b.small) then
		self:hit()
	end
	return true
end

function powblock:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "thwomp" or a == "skewer" or a == "icicle" then
		self:hit()
	end
	return true
end

function powblock:globalcollide(a, b)
	if a == "spikeball" then
		self:hit()
		return true
	end
end

function powblock:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "player" or a == "skewer" or a == "thwomp" then
		self:hit()
	end
	return true
end

function powblock:passivecollide(a, b)
	return false
end

function powblock:emancipate(a)
	self:shotted()
end

function powblock:laser()
	self:shotted()
end