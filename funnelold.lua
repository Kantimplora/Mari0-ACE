funnel = class:new()

function funnel:init(x, y, dir, r)
	self.cox = x
	self.coy = y
	self.dir = dir or "right"
	self.reverse = 1
	self.reversed = false
	self.power = true
	self.quad = 1
	
	self.timer = 0
	self.timer2 = 0
	
	self.objtable = {"player", "goomba", "box", "koopa", "spikeball", "gel", "turret", "enemy", "ice"}
	
	self.speed = funnelspeed
	self.defaultpower = true

	self.r = {unpack(r)}
	table.remove(self.r, 1)
	table.remove(self.r, 1)
	
	if #self.r > 0 and self.r[1] ~= "link" then
		local v = convertr(self.r[1], {"num", "bool", "string", "bool"}, true)
		--SPEED
		self.speed = math.max(0.8, math.min(50, v[1] or funnelspeed))
		--REVERSED
		if v[2] then
			self.reversed = true
			self.reverse = -1
		end
		--DIR
		if v[3] ~= nil then
			self.dir = v[3]
		end
		--DEFAULT OFF
		if v[4] ~= nil then
			if v[4] then
				self.defaultpower = false
			end
		else
			self.legacy = true
		end
		table.remove(self.r, 1)
	end

	self.power = self.defaultpower
	
	--self:updaterange()
	
	self.animationtime = 2/self.speed

	self.funneltable = {}
	self.funnelrangetable = {}
	self.outtable = {}
	
	self.framestart = 0
end

function funnel:link()
	while #self.r >= 3 do
		for j, w in pairs(outputs) do
			for i, v in pairs(objects[w]) do
				if tonumber(self.r[2]) == v.cox and tonumber(self.r[3]) == v.coy then
					if self.legacy and self.r[4] == "power" then
						self.power = false
					end
					v:addoutput(self, self.r[4] or "reverse")
				end
			end
		end
		
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
		table.remove(self.r, 1)
	end
end

function funnel:input(t, input)
	if input == "power" then
		if t == "on" then
			self.power = self.defaultpower
		elseif t == "off" then
			self.power = not self.defaultpower
		else
			self.power = not self.power
		end
		self:updaterange()
	else--if input == "reverse" then
		if t == "on" then
			if self.reversed then
				self.reverse = 1
			else
				self.reverse = -1
			end
			self:updaterange()
		elseif t == "off" then
			if self.reversed then
				self.reverse = -1
			else
				self.reverse = 1
			end
			self:updaterange()
		else
			self.reverse = -self.reverse
			self:updaterange()
		end
	end
end

function funnel:update(dt)
	if self.power then
		if self.power and #self.funnelrangetable > 0 then
			self.timer = self.timer + dt
			while self.timer > self.animationtime do
				self.timer = self.timer - self.animationtime
			end
		
			self.timer2 = self.timer2 + dt
			while self.timer2 > excursionbaseanimationtime do
				self.timer2 = self.timer2 - excursionbaseanimationtime
				if self.reverse == 1 then
					self.quad = self.quad + 1
					if self.quad > 8 then
						self.quad = 1
					end
				else
					self.quad = self.quad - 1
					if self.quad < 1 then
						self.quad = 8
					end
				end
			end
		end
		
		for n, t in pairs(self.funnelrangetable) do
			local rectcol = checkrect(t[1]-1, t[2]-1, t[3], t[4], self.objtable)
			local x, y = t[1]-1, t[2]-1
			
			for i = 1, #rectcol, 2 do
				local w = objects[rectcol[i]][rectcol[i+1]]
				w.speedx = 0
				w.speedy = 0
				
				if rectcol[i] == "gel" then
					w.lifetime = 5
				end
				
				if t[5] == "right" then
					w.speedx = self.speed*self.reverse
					
					local diff = (w.y+w.height/2)-y-1
					w.speedy = -diff*funnelforce
					
					if rectcol[i] == "player" and w.controlsenabled then
						if downkey(rectcol[i+1]) then
							w.speedy = funnelmovespeed
						elseif upkey(rectcol[i+1]) then
							w.speedy = w.speedy-funnelmovespeed
						end
					end
				
				elseif t[5] == "left" then
					w.speedx = -self.speed*self.reverse
					
					local diff = (w.y+w.height/2)-y-1
					w.speedy = -diff*funnelforce
					
					if rectcol[i] == "player" and w.controlsenabled then
						if downkey(rectcol[i+1]) then
							w.speedy = funnelmovespeed
						elseif upkey(rectcol[i+1]) then
							w.speedy = w.speedy-funnelmovespeed
						end
					end
				
				elseif t[5] == "up" then
					w.speedy = -self.speed*self.reverse
					
					local diff = (w.x+w.width/2)-x-1
					w.speedx = -diff*funnelforce
					
					if rectcol[i] == "player" and w.controlsenabled then
						if leftkey(rectcol[i+1]) then
							w.speedx = -funnelmovespeed
						elseif rightkey(rectcol[i+1]) then
							w.speedx = funnelmovespeed
						end
					end
				
				else
					w.speedy = self.speed*self.reverse
					
					local diff = (w.x+w.width/2)-x-1
					w.speedx = -diff*funnelforce
					
					if rectcol[i] == "player" and w.controlsenabled then
						if leftkey(rectcol[i+1]) then
							w.speedx = -funnelmovespeed
						elseif rightkey(rectcol[i+1]) then
							w.speedx = funnelmovespeed
						end
					end
				end
				
				if rectcol[i] == "player" then
					--w.animationstate = "jumping"
				end
				
				w.funnel = true
				w.gravity = 0
			end
		end
	end
end

function funnel:draw()
	--[[love.graphics.setColor(255, 255, 255, 100)
	for i, t in pairs(self.funneltable) do
		local x, y, dir = t[1], t[2], t[3]
		love.graphics.draw(buttonblockimage, flipblockquad[2][1], math.floor((x-xscroll-1)*16*scale), math.floor((y-yscroll-1.5)*16*scale), 0, scale, scale)
		local x2, y2 = x, y
		if dir == "up" then
			x2 = x + 1
		elseif dir == "down" then
			x2 = x + 1
		elseif dir == "right" then
			y2 = y + 1
		elseif dir == "left" then
			y2 = y +1
		end
		love.graphics.draw(buttonblockimage, flipblockquad[2][1], math.floor((x2-xscroll-1)*16*scale), math.floor((y2-yscroll-1.5)*16*scale), 0, scale, scale)
	end
	love.graphics.setColor(255, 0, 0, 50)
	for i, t in pairs(self.funnelrangetable) do
		local x, y, w, h, d = t[1], t[2], t[3], t[4], t[5]
		love.graphics.rectangle("line", math.floor((x-xscroll-1)*16*scale), math.floor((y-yscroll-1.5)*16*scale), (w*16)*scale, (h*16)*scale)
	end]]
	local img = funnel1img
	if self.reverse == -1 then
		img = funnel2img
	end
	local m1, m2 = 0, -1
	if self.reverse == -1 then
		m1, m2 = -1, 0
	end
	love.graphics.setColor(255, 255, 255)
	for i, t in pairs(self.funnelrangetable) do
		local x, y, w, h, d = t[1], t[2], t[3], t[4], t[5]
		love.graphics.setScissor(math.floor((x-xscroll-1)*16*scale), math.floor((y-yscroll-1.5)*16*scale), (w*16)*scale, (h*16)*scale)
		local anim = ((self.timer/self.animationtime)*2)*self.reverse
		if d == "left" then
			for i = 0, math.ceil(w/2) do
				love.graphics.draw(img, math.floor((x+((i+m1)*2)-xscroll-1-anim)*16*scale), math.floor((y-yscroll-1.5)*16*scale), 0, scale, scale)
			end
		elseif d == "right" then
			for i = 0, math.ceil(w/2) do
				love.graphics.draw(img, math.floor((x+((i+m2)*2)-xscroll-1+anim)*16*scale), math.floor((y-yscroll-1.5)*16*scale), 0, scale, scale)
			end
		elseif d == "up" then
			for i = 0, math.ceil(h/2) do
				love.graphics.draw(img, math.floor((x-xscroll)*16*scale), math.floor((y+((i+m1)*2)-yscroll-.5-anim)*16*scale), -math.pi/2, scale, scale, 16, 16)
			end
		elseif d == "down" then
			for i = 0, math.ceil(h/2) do
				love.graphics.draw(img, math.floor((x-xscroll)*16*scale), math.floor((y+((i+m2)*2)-yscroll-.5+anim)*16*scale), math.pi/2, scale, scale, 16, 16)
			end
		end
	end
	love.graphics.setScissor()
	if self.dir == "right" then
		love.graphics.draw(funnelbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll-1)*16*scale), math.floor((self.coy-yscroll-1.5)*16*scale), 0, scale, scale)
	elseif self.dir == "left" then
		love.graphics.draw(funnelbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll)*16*scale), math.floor((self.coy-yscroll+.5)*16*scale), math.pi, scale, scale)
	elseif self.dir == "up" then
		love.graphics.draw(funnelbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll-1)*16*scale), math.floor((self.coy-yscroll-.5)*16*scale), -math.pi/2, scale, scale)
	elseif self.dir == "down" then
		love.graphics.draw(funnelbaseimg, excursionquad[self.quad], math.floor((self.cox-xscroll+1)*16*scale), math.floor((self.coy-yscroll-1.5)*16*scale), math.pi/2, scale, scale)
	end
end

function funnel:updaterange()
	self.funneltable = {}
	self.funnelrangetable = {}
	
	if not self.power then
		return
	end
	
	local dir = self.dir
	local startx, starty = self.cox, self.coy
	local x, y = self.cox, self.coy
	local portalcount = 0
	
	while inmap(x, y) do
		local tile = map[x][y]
		if tilequads[tile[1]]:getproperty("collision", x, y) and not tilequads[tile[1]].grate and not tilequads[tile[1]].invisible then
			break
		end
		if dir == "up" or dir == "down" then
			if not inmap(x+1, y) then
				break
			end
			local tile = map[x+1][y]
			if tilequads[tile[1]]:getproperty("collision", x+1, y) and not tilequads[tile[1]].grate and not tilequads[tile[1]].invisible then
				break
			end
		elseif dir == "right" or dir == "left" then
			if not inmap(x, y+1) then
				break
			end
			local tile = map[x][y+1]
			if tilequads[tile[1]]:getproperty("collision", x, y+1) and not tilequads[tile[1]].grate and not tilequads[tile[1]].invisible then
				break
			end
		end
		
		table.insert(self.funneltable, {x, y, dir})
		
		local tx, ty = x, y
		if dir == "up" then
			ty = y - 1
		elseif dir == "down" then
			ty = y + 1
		elseif dir == "right" then
			tx = x + 1
		elseif dir == "left" then
			tx = x -1
		end
		if portalcount < 4 and inmap(tx, ty) then
			local portalx, portaly, portalfacing, infacing = getPortal(tx, ty, opp)
			local portalx2, portaly2 --check if it is entirely in the portal
			if dir == "up" then
				portalx2, portaly2 = getPortal(tx+1, ty, opp)
			elseif dir == "down" then
				portalx2, portaly2 = getPortal(tx+1, ty, opp)
			elseif dir == "left" then
				portalx2, portaly2 = getPortal(tx, ty+1, opp)
			elseif dir == "right" then
				portalx2, portaly2 = getPortal(tx, ty+1, opp)
			end

			if portalx and portaly and portalx2 then
				local dir2 = infacing

				local cx, cy, cdir
				local instartingposition = false --prevents funnels from infinitely portalling and glitching through walls
				cx = portalx
				cy = portaly
				cdir = portalfacing
				if dir == "up" then
					cy = cy - 1
					if (cx == startx and cy == starty) then
						instartingposition = true
					end
				elseif dir == "down" then
					cx = cx - 1
					cy = cy + 1
					if (cx == startx-1 and cy == starty) then
						instartingposition = true
					end
				elseif dir == "right" then
					cx = cx + 1
					if (cx == startx and cy == starty) then
						instartingposition = true
					end
				elseif dir == "left" then
					cx = cx - 1
					cy = cy - 1
					if (cx == startx and cy == starty-1) then
						instartingposition = true
					end
				end
				if ((dir == "left" and dir2 == "right") or (dir == "right" and dir2 == "left") or (dir == "up" and dir2 == "down") or (dir == "down" and dir2 == "up")) and not instartingposition then
					tx = portalx
					ty = portaly
					local odir = dir
					dir = portalfacing
					if dir == "up" then
						if odir == "left" then
							tx = tx - 1
						end
						ty = ty - 1
					elseif dir == "down" then
						if odir == "right" then
							tx = tx - 1
						end
						ty = ty + 1
					elseif dir == "right" then
						tx = tx + 1
						if odir == "down" then
							ty = ty - 1
						end
					elseif dir == "left" then
						tx = tx - 1
						if odir == "up" then
							ty = ty - 1
						end
					end
					portalcount = portalcount + 1
				end
			end
		end
		x, y = tx, ty
	end
	
	self:funnelranges()
end

function funnel:funnelranges()
	self.funnelrangetable = {}
	local dir = false
	local x, y = false, false
	local w, h = 0, 0
	local count = #self.funneltable
	
	for i, t in pairs(self.funneltable) do
		local x2, y2, d = t[1], t[2], t[3]
		if not dir then dir = d;x = x2;y = y2 end
		if not self.funneltable[i+1] then
			if dir == "up" then
				h = h - 1
			elseif dir == "down" then
				h = h + 1
			elseif dir == "left" then
				w = w - 1
			elseif dir == "right" then
				w = w + 1
			end
		end
		
		if self.funneltable[i+1] and dir == d and (((dir == "up" or dir == "down") and x == x2) or ((dir == "left" or dir == "right") and y == y2)) and ((dir == "up" and y2 == y-1) or (dir == "down" and y2 == y+1) or (dir == "left" and x2 == x-1) or (dir == "right" and x2 == x+1) or (x2 == x or y2 == y)) then
			if dir == "up" then
				h = h - 1
			elseif dir == "down" then
				h = h + 1
			elseif dir == "left" then
				w = w - 1
			elseif dir == "right" then
				w = w + 1
			end
		else
			if (dir == "up" or dir == "down") then
				w = 2
			else
				h = 2
			end
			--do some fixes (and fix the PHANTOM glitch)
			local fix = false
			if dir == "up" then
				y = y + h + 1
				h = -h
				if istile(x, y) and (tilequads[map[x][y][1]].collision and not tilequads[map[x][y][1]].grate and not tilequads[map[x][y][1]].invisible) then
					y = y + 1
					h = h -1
					fix = true
				end
			elseif dir == "left" then
				x = x + w + 1
				w = -w
				if istile(x, y) and (tilequads[map[x][y][1]].collision and not tilequads[map[x][y][1]].grate and not tilequads[map[x][y][1]].invisible) then
					x = x + 1
					w = w -1
					fix = true
				end
			elseif dir == "right" then
				if istile(x+w-1, y) and (tilequads[map[x+w-1][y][1]].collision and not tilequads[map[x+w-1][y][1]].grate and not tilequads[map[x+w-1][y][1]].invisible) then
					w = w - 1
					fix = true
				end
			elseif dir == "down" then
				if istile(x, y+h-1) and (tilequads[map[x][y+h-1][1]].collision and not tilequads[map[x][y+h-1][1]].grate and not tilequads[map[x][y+h-1][1]].invisible) then
					h = h - 1
					fix = true
				end
			end
			table.insert(self.funnelrangetable, {x, y, w, h, dir})
			if fix then
				local t2 = self.funneltable[count]
				if t2[3] == "up" or t2[3] == "down" then
					table.insert(self.funnelrangetable, {t2[1], t2[2], 2, 1, t2[3]})
				else
					table.insert(self.funnelrangetable, {t2[1], t2[2], 1, 2, t2[3]})
				end
			end
			
			dir = false
			x, y = false, false
			w, h = 0, 0
			if self.funneltable[i+1] then
				local t2 = self.funneltable[i+1]
				dir = t2[3]
				x, y = t2[1], t2[2]
				w, h = 1, 1
				if t2[3] == "up" or t2[3] == "left" then
					w, h = -1, -1
				end
				if t2[3] == "up" then
					y = y + 1
				elseif t2[3] == "down" then
					y = y - 1
				elseif t2[3] == "left" then
					x = x + 1
				elseif t2[3] == "right" then
					x = x - 1
				end
			end
		end
	end
end
