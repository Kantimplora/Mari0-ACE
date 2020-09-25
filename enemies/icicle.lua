icicle = class:new()

local icicledropdelay = 1.5

function icicle:init(x, y, t, respawn, r)
	--PHYSICS STUFF
	self.x = x-.5
	self.y = y-1
	self.cox = x
	self.coy = y
	self.speedy = 0
	self.speedx = 0
	self.width = 10/16
	self.height = 12/16
	self.static = true
	self.active = true
	self.category = 4
	self.gravity = 0
	self.falling = false
	self.killstuff = true
	self.playernear = false
	
	self.exploded = false
	self.customscissor = false
	self.invertedscissor = false
	self.counter = 0
	self.passive = false
	
	self.emancipatecheck = true
	self.autodelete = true
	self.t = t or "small"

	self.icicledroptimer = math.random(5, 15)
	self.icicledroptimer = self.icicledroptimer/10

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
	if self.t == "big" then
		self.width = 14/16
		self.height = 30/16
		self.r = r

		local v = convertr(r, {"num", "bool"})
		self.falls = v[2]
		self.fallingravity = (20/9)*v[1]
		self.maxyspeed = v[1]

		self.graphic = iciclebigimg
		if self.falls then
			self.quad = iciclebigquad[2]
		else
			self.quad = iciclebigquad[1]
		end
		self.offsetX = 7
		self.offsetY = -8
		self.quadcenterX = 8
		self.quadcenterY = 16

		self.trackplatform = true
	elseif self.t == "huge" then
		self.x = x
		self.width = 3
		self.height = 3
		self.r = r

		local v = convertr(r, {"num", "bool"})
		self.falls = v[2]
		self.fallingravity = (20/9)*v[1]
		self.maxyspeed = v[1]

		self.graphic = iciclehugeimg
		if self.falls then
			self.quad = iciclehugequad[2]
		else
			self.quad = iciclehugequad[1]
		end
		self.offsetX = -1
		self.offsetY = -8
		self.quadcenterX = 8
		self.quadcenterY = 16
	else
		self.graphic = icicleimage
		self.quad = iciclequad[spriteset][1]
		self.offsetX = 5
		self.offsetY = 1
		if self.t == "new" then
			self.offsetY = 0
		end
		self.quadcenterX = 8
		self.quadcenterY = 8

		if self.t == "new" then
			local v = convertr(r, {"num", "bool"}, true)
			self.falls = v[2]
			self.fallingravity = (20/9)*v[1]
			self.maxyspeed = v[1]

			if self.falls then
				self.quad = iciclequad[spriteset][1]
			else
				self.quad = iciclequad[spriteset][2]
			end

			self.trackplatform = true
		else
			self.fallingravity = r or 10
			self.falls = true
		end
	end
	self.x = self.x - self.width/2
	
	self.rotation = 0
	
	self.animationdirection = "right"
	
	self.falling = false
	self.falltimer = false
	self.dead = false
	self.shot = false

	self.doesrespawn = true
	self.respawn = respawn or false
	if self.respawn then
		self.drawable = false
		self.active = false
		self.respawntimer = 2
		self.autodelete = false
	end
	
	self.dontenterclearpipes = true
	self.pipespawnmax = 1
end

function icicle:update(dt)
	if self.respawn then
		self.respawntimer = self.respawntimer - dt
		if self.respawntimer < 0 and onscreen(self.x, self.y) then
			self:appear()
		else
			return false
		end
	end

	if self.falls and self.t ~=	"small" then
		self.icicledroptimer = self.icicledroptimer-dt
		if self.icicledroptimer < 0 then
			local obj = nil
			if self.t == "new" then
				obj = icicledrop:new(self.x+0.1875, self.y+1)
			elseif self.t == "big" then
				obj = icicledrop:new(self.x+0.3175, self.y+2)
			elseif self.t == "huge" and not self.exploded then
				obj = icicledrop:new(self.x+1.375, self.y+4)
			end
			table.insert(objects["icicledrop"], obj)
			self.icicledroptimer = icicledropdelay
		end
	end

	if self.falling then
		if self.falltimer then
			self.falltimer = self.falltimer - dt
			if self.t == "new" then
				self.offsetX = 5+math.floor((self.falltimer*10)%2)
			elseif self.t == "big" then
				self.offsetX = 7+math.floor((self.falltimer*10)%2)
			elseif self.t == "huge" then
				self.offsetX = -1+math.floor((self.falltimer*10)%5)
			end
			if self.falltimer < 0 then
				if self.t == "huge" then
					playsound(bigiciclefallsound)
				else
					playsound(iciclefallsound)
				end
				self.exploded = false
				self.speedy = 1
				self.static = false
				self.falltimer = false
				if self.t == "new" then
					self.offsetX = 5
				elseif self.t == "big" then
					self.offsetX = 7
				elseif self.t == "huge" then
					self.offsetX = -1
				end
				self.trackable = false
			end
		end

		if self.maxyspeed then
			self.speedy = math.min(self.maxyspeed, self.speedy)
		end

		--here's the messy part; keep mario and a few items on it as it falls
		if not self.static or not self.passive then
			local x, y, y2 = self.cox, math.floor(self.y+17/16), math.floor(self.y+16/16)
			if (not inmap(x, y)) or (istile(x,y) and (not tilequads[map[x][y][1]].collision) and inmap(x, y2) and not tilequads[map[x][y2][1]].collision) then --stop players from falling through ground
				local checktable = {"player", "smallspring"}
				for i, v in pairs(checktable) do
					for j, w in pairs(objects[v]) do
						if not w.jumping and inrange(w.x, self.x-w.width, self.x+self.width) then
							if inrange(w.y, self.y - w.height - 0.1, self.y - w.height + 0.1) then
								local x1, y1 = math.ceil(w.x), math.ceil(self.y+1-.5)
								local x2, y2 = math.ceil(w.x+w.width), math.ceil(self.y+1-.5)
								local maxy, col = math.huge, false
								if (inmap(x1, y1) and tilequads[map[x1][y1][1]]:getproperty("collision", x1, y1) and not tilequads[map[x1][y1][1]]:getproperty("invisible", x1, y1)) then
									maxy = y1-1-w.height
								elseif (inmap(x2, y2) and tilequads[map[x2][y2][1]]:getproperty("collision", x2, y2) and not tilequads[map[x2][y2][1]]:getproperty("invisible", x2, y2)) then
									maxy = y2-1-w.height
								end
								w.y = math.min(maxy, self.y - w.height + self.speedy*dt)
								w.ice = true
							end
						end
					end
				end
			end
		end
	elseif self.falls then
		for i = 1, players do
			local v = objects["player"][i]
			local fallrange = 3
			if self.t == "huge" then
				fallrange = 4
			elseif self.t ~= "small" then
				fallrange = 2
			end
			if inrange(v.x+v.width/2, self.x+self.width/2-fallrange, self.x+self.width/2+fallrange) and v.y > self.y and math.abs(v.y-(self.y+self.height)) < height then --player near
				self:fall()
				break
			end
		end
	end

	if self.exploded and not self.passive then
		self.counter = self.counter + dt
		if self.counter > 0.15 then
			self.passive = true
		end
	end
	
	if self.dead then
		return true
	elseif self.shot then
		self.speedy = self.speedy + shotgravity*dt
		
		self.x = self.x+self.speedx*dt
		self.y = self.y+self.speedy*dt
		return false
	else
		return false
	end
end

function icicle:shotted(dir) --fireball, star, turtle
	if self.respawn then
		return
	end
	if self.t ~= "huge" then
		self:explode()
	end
end

function icicle:fall()
	if self.falling or not self.falls then
		return false
	end
	self.gravity = self.fallingravity
	self.falling = true
	if self.t ~= "small" then
		self.falltimer = 0.8
	else
		self.static = false
	end
end

function icicle:appear()
	if self.t == "big" then
		self.drawable = true
		self.active = true
		self.respawn = false
		self.autodelete = true
		self.trackspeed = nil

		makepoof(self.x+self.width/2, self.y+.5, "makerpoof")
		makepoof(self.x+self.width/2, self.y+1.5, "makerpoof")
	end
end

function icicle:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	return false
end

function icicle:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	
	return false
end

function icicle:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end

	if (self.t ~= "small") and a == "player" then
		self:fall()
	end
end

function icicle:globalcollide(a, b)
	if a == "fireball" and self.t ~= "huge" then
		self:explode()
		return true
	--casuse issues
	elseif a == "fireball" and self.t == "huge" then
		self:fall()
		return true
	end
	
	if self.falling then
		if fireballkill[a] and not b.resistsenemykill then
			b:shotted("left")
			if self.t == "big" then
				return true
			end
		end
	end
end

function icicle:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if self.t == "huge" then
		if a == "tile" then
			self:explode()
		end
	else
		self:explode()
	end
end

function icicle:passivecollide(a, b)
	if a == "player" then
		if self.t == "huge" then
			if (b.invincible or b.starred) or not self.passive then
				--nothin
			else			
				b:die("Enemy (floorcollide)")
			end
		end
	else
		return false
	end
end

function icicle:explode()
	if self.t == "big" then
		self.dead = true
		self.active = false
		self.drawable = false
		
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+2, 2, -14, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+2, -2, -14, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+2, 2, -7, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+2, -2, -7, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		playsound(iciclesound)

		--respawn
		if self.doesrespawn then
			local obj = icicle:new(self.cox, self.coy, "big", true, self.r)
			if self.trackicicle then
				obj.trackable = true
				obj.trackspeed = 0
				local succ = trackobject(self.cox, self.coy, obj, "icicle")
			end
			table.insert(objects["icicle"], obj)
		end
	elseif self.t == "huge" then
		self.static = true
		playsound(bigiciclesound)
		if not self.exploded then
			earthquake = 8
			self.exploded = true
			self.y = math.ceil(self.y)
			self.customscissor = {self.x+.5, self.y+3.07, 2, 2}
			self.invertedscissor = true
		end
	elseif self.t == "new" then
		self.dead = true
		self.active = false
		self.drawable = false

		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+1, 2, -14, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+1, -2, -14, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+1, 2, -7, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		table.insert(blockdebristable, blockdebris:new(self.x+.5, self.y+1, -2, -7, iciclebigimg, icicledebrisquad[math.random(#icicledebrisquad)], "noframes"))
		playsound(iciclesound)
	else
		self.dead = true
		self.active = false
		self.quad = iciclequad[spriteset][2]
		playsound(iciclesound)
	end
end

function icicle:autodeleted()
	if self.respawn then
		return
	end
	--respawn
	if self.t == "big" then
		if self.doesrespawn then
			local obj = icicle:new(self.cox, self.coy, "big", true, self.r)
			if self.trackicicle then
				obj.trackable = true
				obj.trackspeed = 0
				local succ = trackobject(self.cox, self.coy, obj, "icicle")
			end
			table.insert(objects["icicle"], obj)
		end
	end
end

function icicle:emancipate(a)
	table.insert(emancipateanimations, emancipateanimation:new(self.x, self.y, self.width, self.height, self.graphic, self.quad, self.speedx, self.speedy, self.rotation, self.offsetX, self.offsetY, self.quadcenterX, self.quadcenterY))
	self.dead = true
	self.active = false
end

function icicle:dotrack(track)
	if track then
		--self.respawn = false
		self.trackicicle = true
	end
end

function icicle:dospawnanimation(a)
	self.doesrespawn = false
end

-----------------------------------------------------
icicledrop = class:new()

function icicledrop:init(x, y)
	self.x = x
	self.y = y
	self.width = .25
	self.height = .25
	self.active = true
	self.static = false
	self.speedy = 10
	self.speedx = 0
	self.mask = {true,
				true, true, true, true, true,
				true, true, true, true, true,
				true, true, true, true, true,
				true, true, true, true, true,
				true, true, true, true, true,
				true, true, true, true, true,
				true, true}
				
	self.portalable = false

	self.timer = 1.5
end

function icicledrop:update(dt)
	self.timer = self.timer-dt
	if self.timer < 0 then
		self.active = false
		self.destroy = true
		self.drawable = false
	end
end

function icicledrop:draw()
	love.graphics.draw(bubbleimg, math.floor(((self.x+0.125)-xscroll)*16*scale), math.floor(((self.y+0.125)-yscroll-.5)*16*scale), 0, scale, scale, 2, 2)
end