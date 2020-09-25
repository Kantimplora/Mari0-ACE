regiontrigger = class:new()

function regiontrigger:init(x, y, vars, r)
	self.cox = x
	self.coy = y
	self.x = x-1
	self.y = y-1
	self.width = 1
	self.height = 1

	self.checktable = {"player"}

	if vars ~= nil then
		self.vars = vars:split("|")
		local s = self.vars[1]:gsub("n", "-")
		self.width = tonumber(s)
		s = self.vars[2]:gsub("n", "-")
		self.height = tonumber(s)
		
		if #self.vars > 4 then
			s = self.vars[3]:gsub("n", "-")
			self.x = self.cox-1+tonumber(s)
			s = self.vars[4]:gsub("n", "-")
			self.y = self.coy-1+tonumber(s)

			local s = self.vars[5]
			if s == "player" then
				self.checktable = {"player"}
			elseif s == "enemy" then
				self.checktable = deepcopy(enemies)
				table.insert(self.checktable, "enemy")
			elseif s == "everything" then
				self.checktable = deepcopy(enemies)
				table.insert(self.checktable, "player")
				table.insert(self.checktable, "enemy")
			elseif s == "powerups" then
				self.checktable = {"mushroom","oneup","flower","star","poisonmush","smbsitem","hammersuit","frogsuit","minimushroom"}
			else
				self.checktable = {}
				local all = s:split("/")
				for i = 1, #all do
					table.insert(self.checktable, all[i])
				end
			end
		elseif #self.vars > 2 then
			s = self.vars[3]:gsub("n", "-")
			self.x = tonumber(s)
			s = self.vars[4]:gsub("n", "-")
			self.y = tonumber(s)
		end
	end
	self.quadi = 1
	self.timer = 0
	self.on = false
	self.inregion = false
	
	self.outtable = {}
	
	self.out = "off"
end

function regiontrigger:draw()
	--draw orange rectangle
	--[[love.graphics.setColor(234, 160, 45, 111)
	love.graphics.rectangle("fill", (((self.x)*16)-xscroll*16)*scale, ((self.y-(8/16))*16)*scale, (self.width*16)*scale, (self.height*16)*scale)
	love.graphics.setColor(255, 255, 255, 255)]]
end

function regiontrigger:update(dt)
	local col = checkrect(self.x, self.y, self.width, self.height, self.checktable, nil, "regiontrigger")
	if self.out == "off" and #col > 0 then
		self.out = "on"
		for i = 1, #self.outtable do
			self.outtable[i][1]:input(self.out, self.outtable[i][2])
		end
	elseif self.out == "on" and #col == 0 then
		self.out = "off"
		for i = 1, #self.outtable do
			self.outtable[i][1]:input(self.out, self.outtable[i][2])
		end
	end
end

function regiontrigger:addoutput(a, t)
	table.insert(self.outtable, {a, t})
end
function regiontrigger:passivecollide(a, b)
	if a == "player" then
		self.on = true
	end
end