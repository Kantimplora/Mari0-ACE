tilegravity = class:new()

function tilegravity:init(x, y, r, t)
	--PHYSICS STUFF
	self.cox = x-1
	self.coy = y-1
	self.x = x-1
	self.y = y-1
	self.width = 1
	self.height = 1
	self.speedy = 0
	self.speedx = 0
	self.storespeedx = 0
	self.storespeedy = 0
	self.canpush = false
	self.storecanpush = false
	self.static = false
	self.active = true
	self.portalable = true
	self.first = true

	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)

	if #self.r > 0 and self.r[1] ~= "link" then
		local v = convertr(self.r[1], {"bool", "num", "num"}, true)
		self.storecanpush = v[1] or false
		self.storespeedx = v[2] or 0
		self.storespeedy = v[3] or 0
		table.remove(self.r, 1)
	end

	self.t = t or map[x][y][1]
	objects["tile"][tilemap(x, y)] = nil
	map[x][y][1] = 1

	self.speedy = self.storespeedy
	self.speedx = self.storespeedx
	self.canpush = self.storecanpush

	self.category = 2
	self.mask = {	true,
					false, false, false, false, false,
					false, false, false, true, true,
					false, false, true, false, false,
					true, true, false, false, true,
					false, true, true, false, false,
					true, false, true, true, true,
					false, true, false}
					
	self.emancipatecheck = false

	self.offsetX = 8
	self.offsetY = 0
	self.quadcenterX = 8
	self.quadcenterY = 8

	--IMAGE STUFF
	self.quad = tilequads[self.t].quad
	self.breakable = tilequads[self.t].breakable
	self.hardblock = tilequads[self.t].debris and blockdebrisquads[tilequads[self.t].debris]
	self.ice = tilequads[self.t].ice
	self.noteblock = tilequads[self.t].noteblock
	self.glass = tilequads[self.t].glass

	--wen you add something not even alesan added, smarts
	if tilequads[self.t].rightslant and tilequads[self.t].leftslant then
		self.height = 0.5
		if (not tilequads[self.t].downslant) and self.height ~= 1 then
			self.y = self.y + 0.5
			self.offsetY = 8
		end
	elseif tilequads[self.t].rightslant and tilequads[self.t].halfleftslant1 then
		self.height = 0.5
		self.width = 0.5
		if (not tilequads[self.t].downslant) and self.height ~= 1 then
			self.y = self.y + 0.5
			self.offsetY = 8
		end
	elseif tilequads[self.t].rightslant and tilequads[self.t].halfleftslant2 then
		self.width = 0.5
	elseif tilequads[self.t].halfrightslant1 and tilequads[self.t].leftslant then
		self.height = 0.5
		self.width = 0.5
		self.x = self.x + 0.5
		self.offsetX = 0
		if (not tilequads[self.t].downslant) and self.height ~= 1 then
			self.y = self.y + 0.5
			self.offsetY = 8
		end
	elseif tilequads[self.t].halfrightslant2 and tilequads[self.t].leftslant then
		self.width = 0.5
		self.x = self.x + 0.5
		self.offsetX = 0
	end
	
	self.rotation = 0 --for portals
	self.rotationspeed = 0

	self.moveobject = false
	self.falling = false
	self.destroying = false
	self.portaledframe = false
end

function tilegravity:link()
	if #self.r > 2 then
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[2]) == v.cox and tonumber(self.r[3]) == v.coy then
					v:addoutput(self)
					self.speedy = 0
					self.speedx = 0
					self.canpush = false
					self.static = true
					self.portalable = false
					self.x = self.cox
					self.y = self.coy
					if tilequads[self.t].rightslant and tilequads[self.t].leftslant then
						if (not tilequads[self.t].downslant) and self.height ~= 1 then
							self.y = self.y + 0.5
						end
					elseif tilequads[self.t].rightslant and tilequads[self.t].halfleftslant1 then
						if (not tilequads[self.t].downslant) and self.height ~= 1 then
							self.y = self.y + 0.5
						end
					elseif tilequads[self.t].halfrightslant1 and tilequads[self.t].leftslant then
						self.x = self.x + 0.5
						if (not tilequads[self.t].downslant) and self.height ~= 1 then
							self.y = self.y + 0.5
						end
					elseif tilequads[self.t].halfrightslant2 and tilequads[self.t].leftslant then
						self.x = self.x + 0.5
					end
					blockedportaltiles[tilemap(self.cox+1, self.coy+1)] = true
				end
			end
		end
	end
end

function tilegravity:input(t)
	if self.first then
		self.first = false
		self.static = false
		self.portalable = true
		self.speedy = self.storespeedy
		self.speedx = self.storespeedx
		self.canpush = self.storecanpush
		blockedportaltiles[tilemap(self.cox, self.coy)] = nil
	end
end

function tilegravity:update(dt)
	if self.delete then
		return true
	end

	if edgewrapping then --wrap around screen
		local minx, maxx = -self.width, mapwidth
		if self.x < minx then
			self.x = maxx
		elseif self.x > maxx then
			self.x = minx
		end
	end
		
	local friction = boxfrictionair
	if self.falling == false then
		friction = boxfriction
	end
	
	if (inmap(math.floor(self.x+1+self.width), math.floor(self.y+self.height+20/16)) or inmap(math.floor(self.x+1), math.floor(self.y+self.height+20/16))) then
		local t, t2
		local cox, coy = math.floor(self.x+1), math.floor(self.y+self.height+20/16)
		local cox2 = math.floor(self.x+1+self.width)
		if inmap(cox, coy) then
			t = map[cox][coy]
		end
		if inmap(cox2, coy) then
			t2 = map[cox2][coy]
		end
		if (t and ((t[2] and entityquads[t[2]] and entityquads[t[2]].t == "ice") or (t[1] and tilequads[t[1]] and tilequads[t[1]]:getproperty("ice", cox, coy)))) or
			(t2 and ((t2[2] and entityquads[t2[2]] and entityquads[t2[2]].t == "ice") or (t2[1] and tilequads[t2[1]] and tilequads[t2[1]]:getproperty("ice", cox, coy)))) then
			friction = icefriction
		end
	end

	if self.parent then
		local oldx = self.x
		local oldy = self.y

		self.x = (self.parent.x+math.sin(-self.parent.pointingangle)*0.8)-0.125
		self.y = (self.parent.y-math.cos(-self.parent.pointingangle)*0.8)-0.125
	end

	if not self.pushed then
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
	else
		self.pushed = false
	end

	--rotate back to 0 (portals)
	if self.gel and (not self.parent) and self.rotationspeed ~= 0 then
		self.rotation = (self.rotation + (self.rotationspeed)*dt)%(math.pi*2)
		while self.rotation < 0 do
			self.rotation = self.rotation + math.pi*2
		end
	else
		self.rotation = self.rotation + (self.speedx*math.pi)*dt
	end

	self.portaledframe = false
end

function tilegravity:draw()
	if onscreen(self.x, self.y, self.width, self.height) then
		if self.customscissor then
			love.graphics.setScissor(math.floor((self.customscissor[1]-xscroll)*16*scale), math.floor((self.customscissor[2]-.5-yscroll)*16*scale), self.customscissor[3]*16*scale, self.customscissor[4]*16*scale)
		end
		local img = customtilesimg
		if self.t > 90000 then
			img = tilequads[self.t].image
		elseif math.floor(self.t) <= smbtilecount then
			img = smbtilesimg
		elseif self.t <= smbtilecount+portaltilecount then
			img = portaltilesimg
		end
		if tilequads[self.t].coinblock and self.t < 90000 then --coinblock
			love.graphics.draw(coinblockimage, coinblockquads[spriteset][coinframe], math.floor(((self.x-xscroll)*16+self.offsetX)*scale), ((self.y-yscroll)*16-self.offsetY)*scale, 0, scale, scale, self.quadcenterX, self.quadcenterY)
		elseif tilequads[self.t].coin and self.t < 90000 then --coin
			love.graphics.draw(coinimage, coinquads[spriteset][coinframe], math.floor(((self.x-xscroll)*16+self.offsetX)*scale), ((self.y-yscroll)*16-self.offsetY)*scale, 0, scale, scale, self.quadcenterX, self.quadcenterY)
		else
			love.graphics.draw(img, tilequads[self.t].quad, math.floor(((self.x-xscroll)*16+self.offsetX)*scale), ((self.y-yscroll)*16-self.offsetY)*scale, 0, scale, scale, self.quadcenterX, self.quadcenterY)
		end
		love.graphics.setScissor()
	end
end

function tilegravity:leftcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "player" then
		self.pushed = true
		return false
	end
end

function tilegravity:rightcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if a == "player" then
		self.pushed = true
		return false
	end
end

function tilegravity:floorcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
	if self.falling then
		self.falling = false
	end
	if a == "player" then
		self:hit(a, b)
	end
	if a == "enemy" and b.killedbyboxes then
		if b.stompable then
			b:stomp()
		else
			b:shotted("right", false, false, false)
		end
		addpoints(200, self.x, self.y)
		playsound("stomp")
		self.falling = true
		self.speedy = -10
		return false
	end
end

function tilegravity:ceilcollide(a, b)
	if self:globalcollide(a, b) then
		return false
	end
end

function tilegravity:passivecollide(a, b)
	if a == "player" and b.speedy < 0 and self.trackable then
		self:hit(a, b)
	end
	if a == "player" then
		if self.x+self.width > b.x+b.width then
			self.x = b.x+b.width
		else
			self.x = b.x-self.width
		end
	end
end

function tilegravity:globalcollide(a, b)
	if (self.breakable or self.hardblock) and a == "player" and (b.size == 8 or b.size == 16) then
		--big mario destroy
		self:breakblock()
		return true
	end
end

function tilegravity:startfall()
	self.falling = true
end

function tilegravity:portaled()
	self.portaledframe = true
end

function tilegravity:hit(a, b, getbroken)
	if getbroken then
		self.getbroken = true
	end
	if (self.breakable or self.hardblock) and a == "player" and (b.size == 8 or b.size == 16) then
		--big mario destroy
		self.getbroken = true
	end
	if self.breakable or self.getbroken then
		playsound(blockhitsound)
		if ((not b.size) or b.size >= 2) then
			self:breakblock()
		else
			self.blockbouncetimer = 0
		end
	--[[else
		playsound(blockhitsound)]]
	end
end

function tilegravity:breakblock(a, b)
	playsound(blockbreaksound)
	addpoints(50)
	local debris = tilequads[self.t].debris
	local x, y = self.x+1, self.y+1
	if debris and blockdebrisquads[debris] then
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -23, blockdebrisimage, blockdebrisquads[debris][spriteset]))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -23, blockdebrisimage, blockdebrisquads[debris][spriteset]))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -14, blockdebrisimage, blockdebrisquads[debris][spriteset]))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -14, blockdebrisimage, blockdebrisquads[debris][spriteset]))
	else
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -23))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -23))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, 3.5, -14))
		table.insert(blockdebristable, blockdebris:new(x-.5, y-.5, -3.5, -14))
	end
	self.delete = true
	self.active = false
	return true
end