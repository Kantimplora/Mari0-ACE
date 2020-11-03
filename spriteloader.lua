imagestable = {  	"1", "2", "3", "blockdebrisimage", "coinblockanimationimage", "coinanimationimage",
						"coinblockimage", "flipblockimage", "blocktogglebuttonimage", "buttonblockimage", "coinimage", "axeimg", "levelballimg", 
						"springimg", "springgreenimg", "toadimg", "peachimg", "platformimg", "platformbonusimg", "titleimage", "playerselectarrowimg", 
						"flowerimg", "iceflowerimg", "fireballimg", "iceballimg", "vineimg", "gladosimage",
						"coreimage", "pedestalimage", "donutimage", "energylauncherimage", "energyballimage", "shyguyimg", "goombratimage", 
						"drygoombaimage", "goombaimage", "thwompimage", "biggoombaimage", "sidestepperimage", "barrelimage", "ninjiimage", 
						"bigspikeyimg", "splunkinimage", "icicleimage", "paragoombaimage", "muncherimg", "spikeyimg", 
						"parabeetleimg", "booimage", "moleimage", "bigmoleimage", "bombimage", "ampimage", "windleafimage", "lakitoimg", 
						"angrysunimg", "koopaimage", "kooparedimage", "beetleimage", "koopablueimage", "drybonesimage",  "bigkoopaimage", 
						"bigbeetleimage", "cheepcheepimg", "sleepfishimg", "meteorimg", "fishboneimg", "squidimg", "bigblocktogglebuttonimage",
						"pinksquidimg", "bulletbillimg", "bigbillimg", "kingbillimg", "cannonballimg", "torpedotedimage", "torpedolauncherimg",
						"hammerbrosimg", "firebrosimg", "boomerangbrosimg", "hammerimg", "boomerangimg", "plantimg", "redplantimg", 
						"dryplantimg", "fireplantimg", "longfireimg", "fireimg", "upfireimg", "bowserimg", "decoysimg",
						"boximage", "turretimg", "turret2img", "rocketturretimage", "flagimg", "castleflagimg", "bubbleimg", 
						"boomboomimg", "emanceparticleimg", "emancesideimg", "doorpieceimg", "doorcenterimg", "buttonimg",
						"pushbuttonimg", "wallindicatorimg", "walltimerimg", "lightbridgeimg", "lightbridgeglowimg", "lightbridgesideimg", "laserimg", 
						"lasersideimg", "faithplateplateimg", "laserdetectorimg", "gel1img", "gel2img", "gel3img", "gel4img", "gel5img", "gel6img", "gel1ground", 
						"gel2ground", "gel3ground", "gel4ground", "gel6ground", "geldispenserimg", "cubedispenserimg", "yoshieggimg", "yoshiimage", "fontimage", "fontbackimage", "seesawimg",
						"starimg", "pbuttonimg", "spiketopimg", "turretrocketimage", "pokeyimg", "fighterflyimg", "dkhammerimg", "itemsimg", "chainchompimg",
						"bighammerbrosimg", "rockywrenchimg", "wrenchimg", "rotodiscimg", "funnel1img", "funnel2img", "funnelend1img", "funnelend2img", "funnelbaseimg", "thwimpimg",
						"drybeetleimg", "tinygoombaimage", "koopalingimg", "koopalingshotimg", "bigmushroomimg", "icebrosimg", "homingbulletimg",
						"doorspriteimg", "squidbabyimg", "goombashoeimg", "wigglerimg", "keyimg", "magikoopaimg", "magikoopamagicimg",-- "bunnyearsimg", "capeimg",
						"fizzleimg", "spikeyshellimg", "boocrawlerimg", "skewerimg", "bigcloudimg", "beltimg", "poofimg", "hudclockimg", "luckystarimg", "portalimg",
						"groundlightimg", "portalglowimg", "actionblockimg", "gateimg", "collectableimg", "collectableuiimg", "keyuiimg",
						"switchblockimg", "superballflowerimg", "superballimg", "powblockimg", "smallspringimg", "iciclebigimg", "risingwaterimg", "beltonimg", "beltoffimg",
						"drybonesshellimg", "redseesawimg", "snakeblockimg", "oneuptextimage", "threeuptextimage", "boomboomflyingimg", "menuselectimg", "smallfont",
						"pblockimg", "spikeimg", "spikeballimg", "coinfrozenimg", "coinbrickfrozenimg", "helmetshellimg", "boxgelimg", "helmetpropellerimg", "helmetcannonimg",
						"cannonballcannonimg", "clearpipeimg", "plantcreeperimg", "trackimg", "pneumatictubeimg", "dustimg", "platformtrackimg", "checkpointflagimg", "iceimg",
						"snowspikeimg", "grinderimg", "fuzzyimg", "emancelaserimg", "iciclehugeimg", "mushroomfrozenimg", "frozenimg", "coinblockfrozenimg", "redpowblockimg",
						"clawimg", "moonimg", "rouletteblockimg","goombashoewingsimg","shoeghostimg"}

table.sort(imagestable, function(a, b) return a < b end)--sort alphabetically
imagestable[1] = "smbtilesimg"
imagestable[2] = "portaltilesimg"
imagestable[3] = "entitiesimg"

imagestabledisplay = {}
for i, s in pairs(imagestable) do
	--display better names
	local s2 = string.gsub(string.gsub(s, "img", ""), "image", "")
	table.insert(imagestabledisplay, s2)
end

local updatetilequads, fixsprites --update tilequad self.image

local loadedcustomsprites = {} --lists which graphics have been changed

function loadcustomsprites(initial) --Sprite loader
	local imgtable = imagestable
	local customspritesexist = love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom")
	if customspritesexist then
		local files = love.filesystem.getDirectoryItems(mappackfolder .. "/" .. mappack .. "/custom")
		if #files == 0 then
			customspritesexist = false
		end
	end

	--------------
	--GRAPHIC PACKS
	--[[for i, t in pairs(entityquads) do
		t.image = entitiesimg
	end
	customentityquads = false]]
	--------------

	if (not customspritesexist) and customsprites then
		for i = 1, #imgtable do
			if initial or loadedcustomsprites[imgtable[i]] then
				if i == 3 and classic then
					_G[imgtable[i]] = love.graphics.newImage("graphics/" .. string.gsub(string.gsub("entitiesclassic", "img", ""), "image", "") .. ".png")
					loadedcustomsprites[imgtable[i]] = nil
				else
					_G[imgtable[i]] = love.graphics.newImage("graphics/" .. graphicspack .. "/" .. string.gsub(string.gsub(imgtable[i], "img", ""), "image", "") .. ".png")
					loadedcustomsprites[imgtable[i]] = nil
				end
			end
		end

		for i, t in pairs(entityquads) do
			t.image = entitiesimg
		end
		customentityquads = false

		titlewidth = titleimage:getWidth()
		titleframes = math.floor(titleimage:getWidth()/titlewidth)
		titledelay = nil
		titleframe = 1
		titlequad = {}
		for x = 1, titleframes do
			titlequad[x] = love.graphics.newQuad((x-1)*176, 0, 176, 88, titleimage:getWidth(), titleimage:getHeight())
		end
		goombaquad = {}
		for y = 1, 4 do
			goombaquad[y] = {}
			for x = 1, 2 do
				goombaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, goombaimage:getWidth(), 64)
			end
		end
		koopaquad = {}
		for y = 1, 4 do
			koopaquad[y] = {}
			for x = 1, 6 do
				koopaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 96, 96)
			end
		end
		hammerbrosquad = {}
		for y = 1, 4 do
			hammerbrosquad[y] = {}
			for x = 1, 4 do
				hammerbrosquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*34, 16, 34, 64, 136)
			end
		end
		itemsquad = {}
		for y = 1, 4 do
			itemsquad[y] = {}
			for x = 1, 17 do
				itemsquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, itemsimg:getWidth(), 64)
			end
		end
		bowserquad = {}
		for i = 1, 2 do
			bowserquad[i] = {}
			bowserquad[i][1] = {love.graphics.newQuad(0, 64*(i-1), 32, 32, 64, 128), love.graphics.newQuad(32, 64*(i-1), 32, 32, 64, 128)}
			bowserquad[i][2] = {love.graphics.newQuad(0, 32+64*(i-1), 32, 32, 64, 128), love.graphics.newQuad(32, 32+64*(i-1), 32, 32, 64, 128)}
		end
		
		loaddebris()

		fixsprites("reset")

		updatetilequads()
		customsprites = false
		return
	elseif (not customspritesexist) and (not customsprites) and (not initial) then
		return
	end
	
	customsprites = true
	
	for i = 1, #imgtable do
		if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom/" .. string.gsub(string.gsub(imgtable[i], "img", ""), "image", "") .. ".png") then
			_G[imgtable[i]] = love.graphics.newImage(mappackfolder .. "/" .. mappack .. "/custom/" .. string.gsub(string.gsub(imgtable[i], "img", ""), "image", "") .. ".png")
			loadedcustomsprites[imgtable[i]] = true
		else
			if initial or loadedcustomsprites[imgtable[i]] then
				_G[imgtable[i]] = love.graphics.newImage("graphics/" .. graphicspack .. "/" .. string.gsub(string.gsub(imgtable[i], "img", ""), "image", "") .. ".png")
				loadedcustomsprites[imgtable[i]] = nil
			end
		end
	end

	goombaquad = {}
	for y = 1, 4 do
		goombaquad[y] = {}
		for x = 1, 2 do
			goombaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, goombaimage:getWidth(), 64)
		end
	end
	
	koopaquad = {}
	for y = 1, 4 do
		koopaquad[y] = {}
		for x = 1, 6 do
			koopaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, koopaimage:getWidth(), koopaimage:getHeight())
		end
	end
	
	hammerbrosquad = {}
	for y = 1, 4 do
		hammerbrosquad[y] = {}
		for x = 1, 4 do
			hammerbrosquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*34, 16, 34, hammerbrosimg:getWidth(), hammerbrosimg:getHeight())
		end
	end
	
	itemsquad = {}
	for y = 1, 4 do
		itemsquad[y] = {}
		for x = 1, 17 do
			itemsquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, itemsimg:getWidth(), 64)
		end
	end
	
	bowserquad = {}
	for i = 1, 2 do
		bowserquad[i] = {}
		bowserquad[i][1] = {love.graphics.newQuad(0, 64*(i-1), 32, 32, bowserimg:getWidth(), bowserimg:getHeight()), love.graphics.newQuad(32, 64*(i-1), 32, 32, bowserimg:getWidth(), bowserimg:getHeight())}
		bowserquad[i][2] = {love.graphics.newQuad(0, 32+64*(i-1), 32, 32, bowserimg:getWidth(), bowserimg:getHeight()), love.graphics.newQuad(32, 32+64*(i-1), 32, 32, bowserimg:getWidth(), bowserimg:getHeight())}
	end

	loaddebris()

	--fix old custom graphics
	fixsprites()
	
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom/title.png") then
		titleimage = love.graphics.newImage(mappackfolder .. "/" .. mappack .. "/custom/title.png")
		titlewidth = titleimage:getWidth()
		if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom/title.txt") then
			local s = love.filesystem.read(mappackfolder .. "/" .. mappack .. "/custom/title.txt")
			local lines
			if string.find(s, "\r\n") then
				lines = s:split("\r\n")
			else
				lines = s:split("\n")
			end
			for i = 1, #lines do
				local s2 = lines[i]:split("=")
				if s2[1] == "delay" then
					if tonumber(s2[2]) ~= nil then
						titledelay = tonumber(s2[2])
					else
						titledelay = nil
					end
				elseif s2[1] == "width" then
					if tonumber(s2[2]) ~= nil then
						titlewidth = tonumber(s2[2])
					end
				end
			end
		end
		titleframes = math.floor(math.max(titlewidth,titleimage:getWidth())/titlewidth)
		titleframe = 1
		titlequad = {}
		for x = 1, titleframes do
			titlequad[x] = love.graphics.newQuad((x-1)*titlewidth, 0, titlewidth, 88, titleimage:getWidth(), titleimage:getHeight())
		end
	else
		titleimage = love.graphics.newImage("graphics/" .. graphicspack .. "/title.png")
		titlewidth = titleimage:getWidth()
		titleframes = math.floor(titleimage:getWidth()/titlewidth)
		titleframe = 1
		titledelay = nil
		titlequad = {}
		for x = 1, titleframes do
			titlequad[x] = love.graphics.newQuad((x-1)*titlewidth, 0, titlewidth, 88, titleimage:getWidth(), titleimage:getHeight())
		end
	end
	
	updatetilequads()
	
	if initial then
		print("done loading all " .. #imgtable+2 .. " images!")
	else
		if not sausagesound then
			dothesausage(2)
		end
	end
end

function loaddebris()
	blockdebrisquads = {}
	blockdebrisquads.default = {}
	--default
	for y = 1, 4 do
		blockdebrisquads.default[y] = {}
		for x = 1, 2 do
			blockdebrisquads.default[y][x] = love.graphics.newQuad((x-1)*8, (y-1)*8, 8, 8, blockdebrisimage:getWidth(), 32)
		end
	end
	--custom
	local blockdebrisimgd = blockdebrisimage:getData()
	for i = 2, math.floor(blockdebrisimage:getWidth()/17) do
		local r, g, b, a = blockdebrisimgd:getPixel(i*17-1, 0)
		--id of block debris is r,g,b,a
		local name = r .. "," .. g .. "," .. b .. "," .. a
		blockdebrisquads[name] = {}
		for y = 1, 4 do
			blockdebrisquads[name][y] = {}
			for x = 1, 2 do
				blockdebrisquads[name][y][x] = love.graphics.newQuad(17*(i-1)+(x-1)*8, (y-1)*8, 8, 8, blockdebrisimage:getWidth(), 32)
			end
		end
	end
end

local makepquad --make player quad
local pquadx = 0

function loadplayerquads(t)
	local sets = {"small", "big", "hammer", "frog", "raccoon", "tiny", "cape", "shell", "boomerang"}
	--make quads for each image set
	--fully reprogrammed for custom characters, this was tough
	for seti, set in pairs(sets) do
		t[set] = {}
		t[set].idle = {}
		t[set].idleanim = {}
		t[set].run = {}
		t[set].slide = {}
		t[set].jump = {}
		t[set].climb = {}
		t[set].swim = {}
		t[set].duck = {} --hehe duck.
		t[set].shoe = {}
		t[set].fence = {}
		--set-exclusive quads
		if set == "small" or set == "tiny" then
			t[set].die = {}
			t[set].grow = {}
			t[set].grownogun = {}
		elseif set == "raccoon" then
			t[set].fire = {}
			t[set].float = {}
			t[set].spin = {}
			t[set].runfast = {}
			t[set].fly = {}
			t[set].statue = {}
		elseif set == "cape" then
			t[set].fire = {}
			t[set].spin = {}
			t[set].runfast = {}
			t[set].fly = {}
		else
			t[set].fire = {}
		end
		
		if t.fallframes > 0 then
			t[set].fall = {}
		end
		if t.customframes > 0 then
			t[set].custom = {}
		end

		local y, w, h = 0, 0, 0
		--image sizes
		if set == "small" then
			w, h = t.smallquadwidth, t.smallquadheight
			iw, ih = t.smallimgwidth, t.smallimgheight
		elseif set == "big" then
			w, h = t.bigquadwidth, t.bigquadheight
			iw, ih = t.bigimgwidth, t.bigimgheight
		elseif set == "hammer" then
			w, h = t.hammerquadwidth, t.hammerquadheight
			iw, ih = t.hammerimgwidth, t.hammerimgheight
		elseif set == "frog" then
			w, h = t.frogquadwidth, t.frogquadheight
			iw, ih = t.frogimgwidth, t.frogimgheight
		elseif set == "raccoon" then
			w, h = t.raccoonquadwidth, t.raccoonquadheight
			iw, ih = t.raccoonimgwidth, t.raccoonimgheight
		elseif set == "tiny" then
			w, h = t.tinyquadwidth, t.tinyquadheight
			iw, ih = t.tinyimgwidth, t.tinyimgheight
		elseif set == "cape" then
			w, h = t.capequadwidth, t.capequadheight
			iw, ih = t.capeimgwidth, t.capeimgheight
		elseif set == "shell" then
			w, h = t.shellquadwidth, t.shellquadheight
			iw, ih = t.shellimgwidth, t.shellimgheight
		elseif set == "boomerang" then
			w, h = t.boomerangquadwidth, t.boomerangquadheight
			iw, ih = t.boomerangimgwidth, t.boomerangimgheight
		end

		for i = 1, 5 do
			--BASICS
			if t.idleframes > 1 then
				t[set].idleanim[i] = {}
				for f = 1, t.idleframes do
					t[set].idleanim[i][f] = makepquad(i, w, h, iw, ih, t)
				end
				t[set].idle[i] = t[set].idleanim[i][1]
			else
				t[set].idle[i] = makepquad(i, w, h, iw, ih, t)
			end
			
			t[set].run[i] = {}
			for f = 1, t.runframes do
				t[set].run[i][f] = makepquad(i, w, h, iw, ih, t)
			end
			t[set].slide[i] = makepquad(i, w, h, iw, ih, t)

			--JUMP
			t[set].jump[i] = makepquad(i, w, h, iw, ih, t)
			if t.fallframes > 0 then --falling
				t[set].fall[i] = makepquad(i, w, h, iw, ih, t)
			end

			--DIE/FIRE
			if t[set].die then
				t[set].die[i] = makepquad(i, w, h, iw, ih, t)
			elseif t[set].fire then
				t[set].fire[i] = makepquad(i, w, h, iw, ih, t)
			end
			
			--CLIMB
			t[set].climb[i] = {}
			t[set].climb[i][1] = makepquad(i, w, h, iw, ih, t)
			t[set].climb[i][2] = makepquad(i, w, h, iw, ih, t)
			
			--FENCE
			t[set].fence[i] = {}
			for f = 1, t.fenceframes do
				t[set].fence[i][f] = makepquad(i, w, h, iw, ih, t)
			end

			--SWIMMING
			t[set].swim[i] = {}
			t[set].swim[i][1] = makepquad(i, w, h, iw, ih, t)
			t[set].swim[i][2] = makepquad(i, w, h, iw, ih, t)
			if t.swimframes < 4 then
				t[set].swim[i][3] = t[set].swim[i][1]
				t[set].swim[i][4] = t[set].swim[i][2]
			else
				t[set].swim[i][3] = makepquad(i, w, h, iw, ih, t)
				t[set].swim[i][4] = makepquad(i, w, h, iw, ih, t)
			end
			for f = 1, t.swimpushframes do
				t[set].swim[i][4+f] = makepquad(i, w, h, iw, ih, t)
			end

			--DUCKING
			if set == "small" then
				for f = 1, t.smallduckingframes do
					t[set].duck[i] = makepquad(i, w, h, iw, ih, t)
				end
			elseif set == "shell" then --shell frames
				t[set].duck[i] = {}
				for f = 1, t.blueshellframes do
					t[set].duck[i][f] = makepquad(i, w, h, iw, ih, t)
				end
			else
				t[set].duck[i] = makepquad(i, w, h, iw, ih, t)
			end
			
			--GROWING
			if t[set].grow then
				t[set].grow[i] = love.graphics.newQuad(pquadx, 0, t.growquadwidth, t.growquadheight, iw, ih, t)
				t[set].grownogun[i] = love.graphics.newQuad(pquadx+t.growquadwidth, 0, t.growquadwidth, t.growquadheight, iw, ih, t)
			end

			--FLOAT
			if t[set].float then
				t[set].float[i] = {}
				t[set].float[i][1] = makepquad(i, w, h, iw, ih, t)
				t[set].float[i][2] = makepquad(i, w, h, iw, ih, t)
				t[set].float[i][3] = t[set].jump[i]
				t[set].float[i][4] = t[set].jump[i]
			end

			--SPINNING
			if t[set].spin then
				t[set].spin[i] = {}
				t[set].spin[i][1] = makepquad(i, w, h, iw, ih, t)
				t[set].spin[i][2] = makepquad(i, w, h, iw, ih, t)
				t[set].spin[i][3] = makepquad(i, w, h, iw, ih, t)
			end

			--FLYING
			if t[set].runfast then
				t[set].runfast[i] = {}
				t[set].runfast[i][1] = makepquad(i, w, h, iw, ih, t)
				t[set].runfast[i][2] = makepquad(i, w, h, iw, ih, t)
				t[set].runfast[i][3] = makepquad(i, w, h, iw, ih, t)

				if set == "cape" then
					--cape flying
					t[set].fly[i] = {}
					t[set].fly[i][1] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][2] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][3] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][4] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][5] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][6] = makepquad(i, w, h, iw, ih, t)
				else
					--raccoon flying
					t[set].fly[i] = {}
					t[set].fly[i][1] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][2] = makepquad(i, w, h, iw, ih, t)
					t[set].fly[i][3] = makepquad(i, w, h, iw, ih, t)

					--statue
					t[set].statue[i] = makepquad(i, w, h, iw, ih, t)
				end
			end
			
			--SHOE
			if t.shoeframes and t.shoeframes > 0 then
				t[set].shoe[i] = makepquad(i, w, h, iw, ih, t)
			else
				if set == "small" then
					t[set].shoe[i] = makepquad(i, w, h, iw, ih, t, t.smallshoequadheight or 7)
				elseif set == "tiny" then
					t[set].shoe[i] = makepquad(i, w, h, iw, ih, t, t.tinyshoequadheight or 4)
				else
					t[set].shoe[i] = makepquad(i, w, h, iw, ih, t, t.shoequadheight or 22)
				end
			end

			--CUSTOM FRAMES
			if t.customframes > 0 then
				t[set].custom[i] = {}
				for f = 1, t.customframes do
					t[set].custom[i][f] = makepquad(i, w, h, iw, ih, t)
				end
			end

			resetpquad()
		end
	end
end

function makepquad(i, w, h, imgw, imgh, t, shoe)
	local y = 0
	if not t.nopointing then
		y = h
	end
	local quad
	if shoe then
		quad = love.graphics.newQuad(0, (i-1)*y, w, h-shoe, imgw, imgh)
	else
		quad = love.graphics.newQuad(pquadx, (i-1)*y, w, h, imgw, imgh)
		pquadx = pquadx + w
	end
	return quad
end

function resetpquad()
	pquadx = 0
end

function updatetilequads()
	for i = 1, smbtilecount+portaltilecount do
		if i <= smbtilecount then
			tilequads[i].image = smbtilesimg
		else
			tilequads[i].image = portaltilesimg
		end
	end
end

function loadquads(initial)
	--custom hud
	customhud = false
	hudstuff = {}
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/hud/hud.json") then
		--load properties
		customhud = true
		local s = love.filesystem.read(mappackfolder .. "/" .. mappack .. "/hud/hud.json")
		local temp = JSON:decode(s)	
		for i, v in pairs(temp) do
			hudstuff[i] = v
		end
	end
			
	--custom icons (oh boy)
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/hud/hud.png") then
		hudiconsimg = love.graphics.newImage(mappackfolder .. "/" .. mappack .. "/hud/hud.png")

		local imgheight = hudiconsimg:getHeight()
		local imgwidth = hudiconsimg:getWidth()
		local width = math.floor(imgwidth/5)
		local height = math.floor(imgheight/width)

		hudiconsquad = {}
		for y = 1, height do
			hudiconsquad[y] = {}
			for x = 1, 5 do
				hudiconsquad[y][x] = love.graphics.newQuad((x-1)*width, (y-1)*height, width, height, imgwidth, imgheight)
			end
		end
	end

	hudoverlay = false
	--overlay
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/hud/overlay.png") then
		hudoverlayimg = love.graphics.newImage(mappackfolder .. "/" .. mappack .. "/hud/overlay.png")
		hudoverlayquad = love.graphics.newQuad(0, 0, 400, 224, 400, 224)
		hudoverlay = true
	end

	--collects (think star coins)
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/hud/collects.png") then
		collectsimg = love.graphics.newImage(mappackfolder .. "/" .. mappack .. "/hud/collects.png")

		local imgheight = collectsimg:getHeight()
		local imgwidth = collectsimg:getWidth()
		local height = math.floor(imgheight/8)
		local fullheight = math.floor(imgheight/16)
		
		collectsquad = {}
		for y = 1, 10 do
			collectsquad[y] = {}
			for x = 1, 5 do
				collectsquad[y][x] = {}
				for q = 1, 2 do
					collectsquad[y][x][q] = love.graphics.newQuad((x-1)*(imgwidth/5), (y-1)*(imgheight/fullheight)+(q-1)*(imgheight/height), imgheight/height, imgheight/height, imgwidth, imgheight)
				end
			end
		end
	end

	--tile groups
	tilegroups = {}
	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/group.json") then
		--load properties
		local s = love.filesystem.read(mappackfolder .. "/" .. mappack .. "/group.json")
		local data = JSON:decode(s)
		createtilegroups(data)
	end

	------------------------------
	------------QUADS-------------
	------------------------------

	--emanceside
	emancesidequad = {}
	for y = 1, 4 do
		emancesidequad[y] = {}
		for x = 1, 10 do
			emancesidequad[y][x] = love.graphics.newQuad((x-1)*5, (y-1)*8, 5, 8, 50, 32)
		end
	end

	--emancepartical
	emanceparticlequad = {}
	for x = 1, 6 do
		emanceparticlequad[x] = love.graphics.newQuad((x-1), 0, 1, 64, 6, 64)
	end

	--emancelaser
	emancelaserquad = {}
	for x = 1, 4 do
		emancelaserquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 8, 64, 8)
	end

	coinblockanimationquads = {}
	for i = 1, 30 do
		coinblockanimationquads[i] = love.graphics.newQuad((i-1)*8, 0, 8, 52, 256, 64)
	end
	
	coinanimationquads = {}
	for j = 1, 4 do
		coinanimationquads[j] = {}
		for i = 1, 5 do
			coinanimationquads[j][i] = love.graphics.newQuad((i-1)*5, (j-1)*8, 5, 8, 25, 32)
		end
	end

	collectableuiquad = {}
	for s = 1, 4 do
		collectableuiquad[s] = {}
		for i = 1, 10 do
			collectableuiquad[s][i] = {}
			for f = 1, 5 do
				collectableuiquad[s][i][f] = love.graphics.newQuad((f-1)*8, (i-1)*32+(s-1)*8, 8, 8, 40, 320)
			end
		end
	end

	keyuiquad = {}
	for j = 1, 4 do
		keyuiquad[j] = {}
		for i = 1, 5 do
			keyuiquad[j][i] = love.graphics.newQuad((i-1)*8, (j-1)*8, 8, 8, 40, 32)
		end
	end
	
	--coinblock
	coinblockquads = {}
	for j = 1, 4 do
		coinblockquads[j] = {}
		for i = 1, 5 do
			coinblockquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
		end
	end
	
	--flipblock and other block-like entities
	flipblockquad = {}
	for y = 1, 4 do
		flipblockquad[y] = {}
		for x = 1, 4 do
			flipblockquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
		end
	end
	
	bigblockquad = {}
	for y = 1, 4 do
		bigblockquad[y] = {}
		for x = 1, 4 do
			bigblockquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 128, 128)
		end
	end
	
	--coin
	coinquads = {}
	for j = 1, 4 do
		coinquads[j] = {}
		for i = 1, 5 do
			coinquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
		end
	end
	
	--axe
	axequads = {}
	for i = 1, 5 do
		axequads[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 80, 16)
	end

	--gel dispensers
	geldispenserquad = {}
	for y = 1, 4 do
		geldispenserquad[y] = {}
		for x = 1, 6 do
			geldispenserquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 192, 128)
		end
	end
	
	--levelball
	levelballquad = {}
	for x = 1, 8 do
		levelballquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 128, 16)
	end

	--key
	keyquads = {}
	for j = 1, 4 do
		keyquads[j] = {}
		for i = 1, 5 do
			keyquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
		end
	end
	
	--spring
	springquads = {}
	for i = 1, 4 do
		springquads[i] = {}
		for j = 1, 3 do
			springquads[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*31, 16, 31, 48, 124)
		end
	end
	
	--yoshi
	yoshieggquad = {}
	for y = 1, 4 do
		yoshieggquad[y] = {}
		for x = 1, 2 do
			yoshieggquad[y][x] = love.graphics.newQuad((x-1)*12, 15*(y-1), 12, 15, 24, 60)
		end
	end
	
	yoshiquad = {}
	for y = 1, 4 do
		yoshiquad[y] = {}
		for x = 1, 18 do
			yoshiquad[y][x] = love.graphics.newQuad((x-1)*30, (y-1)*35, 30, 35, 570, 140)
		end
		yoshiquad[y][19] = love.graphics.newQuad(540, (y-1)*35, 4, 4, 570, 140) --tounge
	end

	platformquad = {}
	for x = 1, 3 do
		platformquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 48, 16)
	end
	platformquad[1.5] = love.graphics.newQuad((2-1)*16, 0, 8, 16, 48, 16)
	platformquad[2.5] = love.graphics.newQuad((3-1)*16+8, 0, 8, 16, 48, 16)
	
	seesawquad = {}
	for s = 1, 4 do
		seesawquad[s] = {}
		for i = 1, 4 do
			seesawquad[s][i] = love.graphics.newQuad((i-1)*16, (s-1)*16, 16, 16, 64, 64)
		end
	end
	
	--items (also in spriteloader.lua)
	itemsquad = {}
	for y = 1, 4 do
		itemsquad[y] = {}
		for x = 1, 17 do
			itemsquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 272, 64)
		end
	end
	
	starquad = {}
	for y = 1, 4 do
		starquad[y] = {}
		for x = 1, 4 do
			starquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
		end
	end
	
	flowerquad = {}
	for y = 1, 4 do
		flowerquad[y] = {}
		for x = 1, 4 do
			flowerquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
		end
	end
	
	hammersuitquad = {}
	for i = 1, 4 do
		hammersuitquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	frogsuitquad = {}
	for i = 1, 4 do
		frogsuitquad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
	end
	
	fireballquad = {}
	for i = 1, 4 do
		fireballquad[i] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 80, 16)
	end
	
	for i = 5, 7 do
		fireballquad[i] = love.graphics.newQuad((i-5)*16+32, 0, 16, 16, 80, 16)
	end
	
	vinequad = {}
	for i = 1, 4 do
		vinequad[i] = {}
		for j = 1, 8 do
			vinequad[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*16, 16, 16, 128, 64) 
		end
	end
	
	gladosquad = {}
	for x = 1, 2 do
		gladosquad[x] = love.graphics.newQuad((x-1)*86, 0, 86, 86, 86, 86)
	end
	
	corequad = {}
	for x = 1, 4 do
		corequad[x] = love.graphics.newQuad((x-1)*13, 0, 13, 12, 52, 12)
	end

	pedestalquad = {}
	for y = 1, 4 do
		pedestalquad[y] = {}
		for x = 1, 11 do
			pedestalquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 176, 64)
		end
	end
	
	energylauncherquad = {}
	for y = 1, 4 do
		energylauncherquad[y] = {}
		for x = 1, 6 do
			energylauncherquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 96, 64)
		end
	end
	
	energyballquad = {}
	for y = 1, 2 do
		energyballquad[y] = {}
		for x = 1, 4 do
			energyballquad[y][x] = love.graphics.newQuad((x-1)*8, (y-1)*8, 8, 8, 32, 16)
		end
	end
	
	thwompquad = {}
	for y = 1, 4 do
		thwompquad[y] = {}
		for x = 1, 7 do
			thwompquad[y][x] = love.graphics.newQuad((x-1)*24, (y-1)*32, 24, 32, 168, 128)
		end
	end

	biggoombaquad = {}
	for y = 1, 4 do
		biggoombaquad[y] = {}
		for x = 1, 2 do
			biggoombaquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 64, 128)
		end
	end
	
	tinygoombaquad = {}
	for y = 1, 4 do
		tinygoombaquad[y] = {}
		for x = 1, 2 do
			tinygoombaquad[y][x] = love.graphics.newQuad((x-1)*8, (y-1)*8, 8, 8, 16, 32)
		end
	end
	
	bigspikeyquad = {}
	for x = 1, 4 do
		bigspikeyquad[x] = love.graphics.newQuad((x-1)*32, 0, 32, 32, 128, 32)
	end
	
	splunkinquad = {}
	for y = 1, 4 do
		splunkinquad[y] = {}
		for x = 1, 6 do
			splunkinquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 96, 64)
		end
	end
	
	iciclequad = {}
	for y = 1, 4 do
		iciclequad[y] = {}
		for x = 1, 2 do
			iciclequad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 64)
		end
	end
	
	paragoombaquad = {}
	for y = 1, 4 do
		paragoombaquad[y] = {}
		for x = 1, 3 do
			paragoombaquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*23, 16, 23, 48, 92)
		end
	end
	
	muncherquad = {}
	for x = 1, 4 do
		muncherquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	spikeyquad = {}
	for x = 1, 4 do
		spikeyquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	parabeetlequad = {}
	for x = 1, 4 do
		parabeetlequad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	booquad = {}
	for y = 1, 4 do
		booquad[y] = {}
		for x = 1, 2 do
			booquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 64)
		end
	end
	
	molequad = {}
	for y = 1, 4 do
		molequad[y] = {}
		for x = 1, 4 do
			molequad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
		end
	end
	
	bigmolequad = {}
	for y = 1, 4 do
		bigmolequad[y] = {}
		for x = 1, 2 do
			bigmolequad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 64, 128)
		end
	end
	
	bombquad = {}
	for y = 1, 4 do
		bombquad[y] = {}
		for x = 1, 3 do
			bombquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 48, 64)
		end
	end
	
	ampquad = {}
	for y = 1, 4 do
		ampquad[y] = {}
		for x = 1, 4 do
			ampquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 128, 128)
		end
	end
	
	windleafquad = {}
	for y = 1, 4 do
		windleafquad[y] = {}
		for x = 1, 2 do
			windleafquad[y][x] = love.graphics.newQuad((x-1)*6, (y-1)*6, 6, 6, 12, 24)
		end
	end
	
	lakitoquad = {}
	for y = 1, 4 do
		lakitoquad[y] = {}
		for x = 1, 2 do
			lakitoquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 32, 96)
		end
	end
	
	angrysunquad = {}
	for x = 1, 2 do
		angrysunquad[x] = love.graphics.newQuad((x-1)*28, 0, 28, 28, 56, 28)
	end
	
	drybonesquad = {}
	for y = 1, 4 do
		drybonesquad[y] = {}
		for x = 1, 2 do
			drybonesquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 74, 96)
		end
		drybonesquad[y][3] = love.graphics.newQuad(32, (y-1)*24, 19, 24, 74, 96)
		drybonesquad[y][4] = love.graphics.newQuad(51, (y-1)*24, 23, 24, 74, 96)
	end
	
	bigkoopaquad = {}
	for y = 1, 4 do
		bigkoopaquad[y] = {}
		for x = 1, 6 do
			bigkoopaquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*48, 32, 48, 192, 192)
		end
	end
	
	cheepcheepquad = {}
	for y = 1, 4 do
		cheepcheepquad[y] = {}
		for x = 1, 4 do
			cheepcheepquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
		end
	end

	sleepfishquad = {}
	for y = 1, 2 do
		sleepfishquad[y] = {}
		for x = 1, 2 do
			sleepfishquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 32)
		end
	end
	
	meteorquad = {}
	meteorquad[1] = {}
	meteorquad[1][1] = love.graphics.newQuad(0, 0, 16, 16, 32, 24)
	meteorquad[1][2] = love.graphics.newQuad(16, 0, 16, 16, 32, 24)
	meteorquad[2] = {}
	meteorquad[2][1] = love.graphics.newQuad(0, 16, 8, 8, 32, 24)
	meteorquad[2][2] = love.graphics.newQuad(8, 16, 8, 8, 32, 24)
	
	fishbonequad = {}
	fishbonequad[1] = {}
	fishbonequad[1][1] = love.graphics.newQuad(0, 0, 23, 14, 46, 28)
	fishbonequad[1][2] = love.graphics.newQuad(23, 0, 23, 14, 46, 28)
	fishbonequad[2] = {}
	fishbonequad[2][1] = love.graphics.newQuad(0, 14, 23, 14, 46, 28)
	fishbonequad[2][2] = love.graphics.newQuad(23, 14, 23, 14, 46, 28)
	
	squidquad = {}
	for y = 1, 4 do
		squidquad[y] = {}
		for x = 1, 2 do
			squidquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*32, 16, 24, 32, 128)
		end
	end
	
	squidbabyquad = {}
	for y = 1, 4 do
		squidbabyquad[y] = {}
		for x = 1, 2 do
			squidbabyquad[y][x] = love.graphics.newQuad((x-1)*7, (y-1)*11, 7, 11, 14, 44)
		end
	end
	
	bulletbillquad = {}
	for y = 1, 4 do
		bulletbillquad[y] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 16, 64)
	end
	
	bigbillquad = {}
	for y = 1, 4 do
		bigbillquad[y] = love.graphics.newQuad(0, (y-1)*32, 32, 32, 32, 128)
	end
	
	kingbillquad = {}
	for y = 1, 4 do
		kingbillquad[y] = love.graphics.newQuad(0, (y-1)*200, 200, 200, 200, 800)
	end

	cannonballquad = {}
	for y = 1, 4 do
		cannonballquad[y] = {}
		for x = 1, 2 do
			cannonballquad[y][x] = love.graphics.newQuad((x-1)*12, (y-1)*12, 12, 12, 24, 48)
		end
	end
	
	torpedotedquad = {}
	for y = 1, 4 do
		torpedotedquad[y] = {}
		for x = 1, 2 do
			torpedotedquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*16, 32, 16, 64, 64)
		end
	end
	
	torpedolauncherquads = {}
	for j = 1, 4 do
		torpedolauncherquads[j] = {}
		for i = 1, 2 do
			torpedolauncherquads[j][i] = love.graphics.newQuad((i-1)*32, (j-1)*24, 32, 24, 64, 96)
		end
	end
	
	hammerbrosquad = {}
	for y = 1, 4 do
		hammerbrosquad[y] = {}
		for x = 1, 4 do
			hammerbrosquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*34, 16, 34, 64, 136)
		end
	end	
	
	bighammerbrosquad = {}
	for y = 1, 4 do
		bighammerbrosquad[y] = {}
		for x = 1, 4 do
			bighammerbrosquad[y][x] = love.graphics.newQuad((x-1)*24, (y-1)*39, 24, 39, 96, 156)
		end
	end
	
	hammerquad = {}
	for j = 1, 4 do
		hammerquad[j] = {}
		for i = 1, 4 do
			hammerquad[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
		end
	end
	
	plantquads = {}
	for j = 1, 4 do
		plantquads[j] = {}
		for i = 1, 2 do
			plantquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*24, 16, 24, 32, 96)
		end
	end
	
	longfirequad = {}
	for i = 1, 5 do
		longfirequad[i] = love.graphics.newQuad(0, (i-1)*16, 48, 16, 48, 80)
	end
	
	firequad = {love.graphics.newQuad(0, 0, 24, 8, 48, 8), love.graphics.newQuad(24, 0, 24, 8, 48, 8)}
	
	bowserquad = {}
	for i = 1, 2 do
		bowserquad[i] = {}
		bowserquad[i][1] = {love.graphics.newQuad(0, 64*(i-1), 32, 32, 64, 128), love.graphics.newQuad(32, 64*(i-1), 32, 32, 64, 128)}
		bowserquad[i][2] = {love.graphics.newQuad(0, 32+64*(i-1), 32, 32, 64, 128), love.graphics.newQuad(32, 32+64*(i-1), 32, 32, 64, 128)}
	end
	
	decoysquad = {}
	for y = 1, 7 do
		decoysquad[y] = love.graphics.newQuad(0, (y-1)*32, 32, 32, 64, 256)
	end
	
	boxquad = {}
	for s = 1, 4 do
		boxquad[s] = {}
		for i = 1, 3 do
			boxquad[s][i] = {}
			for x = 1, 2 do
				boxquad[s][i][x] = love.graphics.newQuad(24*(i-1)+12*(x-1), 12*(s-1), 12, 12, 72, 48)
			end
		end
	end

	boxgelquad = {}
	for s = 1, 4 do
		boxgelquad[s] = {}
		for i = 1, 2 do
			boxgelquad[s][i] = {}
			for x = 1, 4 do
				boxgelquad[s][i][x] = love.graphics.newQuad(48*(i-1)+12*(x-1), 12*(s-1), 12, 12, 96, 48)
			end
		end
	end
	
	rocketturretquad = {}	
	for x = 1, 4 do
		rocketturretquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 64, 16)
	end
	
	turretrocketquad = {}
	for x = 1, 2 do
		turretrocketquad[x] = love.graphics.newQuad((x-1)*5, 0, 5, 5, 5, 5)
	end
	
	boomboomquad = {}
	for y = 1, 4 do
		boomboomquad[y] = {}
		for x = 1, 10 do
			boomboomquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 320, 128)
		end
	end
	
	pokeyquad = {}
	
	pokeyquad[1] = {}
	pokeyquad[1][1] = love.graphics.newQuad(0, 0, 16, 17, 32, 34)
	pokeyquad[1][2] = love.graphics.newQuad(16, 0, 16, 17, 32, 34)
	pokeyquad[2] = {}
	pokeyquad[2][1] = love.graphics.newQuad(0, 17, 16, 17, 32, 34)
	pokeyquad[2][2] = love.graphics.newQuad(16, 17, 16, 17, 32, 34)
	
	chainchompquad = {}
	for y = 1, 4 do
		chainchompquad[y] = {}
		chainchompquad[y][1] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 40, 64)
		chainchompquad[y][2] = love.graphics.newQuad(16, (y-1)*16, 16, 16, 40, 64)
		chainchompquad[y][3] = love.graphics.newQuad(32, (y-1)*16+8, 8, 8, 40, 64)
	end
	
	rockywrenchquad = {}
	for y = 1, 4 do
		rockywrenchquad[y] = {}
		for x = 1, 3 do
			rockywrenchquad[y][x] = love.graphics.newQuad(16*(x-1), 32*(y-1), 16, 32, 48, 128)
		end
	end
	
	wrenchquad = {}
	for x = 1, 4 do
		wrenchquad[x] = love.graphics.newQuad(10*(x-1), 0, 10, 10, 40, 10)
	end
	
	thwimpquad = {}
	for y = 1, 4 do
		thwimpquad[y] = love.graphics.newQuad(0, 16*(y-1), 16, 16, 16, 64)
	end
	
	koopalingquad = {}
	for y = 1, 8 do
		koopalingquad[y] = {}
		for x = 1, 4 do
			koopalingquad[y][x] = love.graphics.newQuad((x-1)*40, (y-1)*36, 40, 36, 376, 336)
		end
		for x = 5, 13 do
			koopalingquad[y][x] = love.graphics.newQuad(160+(x-5)*24, (y-1)*36, 24, 24, 376, 336)
		end
	end
	koopalingquad[9] = {}
	for x = 1, 9 do
		koopalingquad[9][x] = love.graphics.newQuad((x-1)*36, 288, 36, 42, 376, 336)
	end
	
	koopalingshotquad = {}
	for y = 1, 3 do
		koopalingshotquad[y] = {}
		for x = 1, 3 do
			koopalingshotquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 48, 48)
		end
	end
	
	bigmushroomquad = love.graphics.newQuad(0, 0, 32, 32, 32, 32)
	
	doorspritequad = {}
	for y = 1, 3 do
		doorspritequad[y] = {}
		for x = 1, 4 do
			doorspritequad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*32, 16, 32, 64, 96)
		end
	end
	
	goombashoequad = {}
	for y = 1, 4 do
		goombashoequad[y] = {}
		for x = 1, 3 do --goombainshoe
			goombashoequad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*24, 16, 24, 48, 96)
		end --
		for x = 4, 6 do --just shoe
			goombashoequad[y][x] = love.graphics.newQuad((x-4)*16, 8+(y-1)*24, 16, 16, 48, 96)
		end
	end

	goombashoewingsquad = {}
	for y = 1, 8 do
		goombashoewingsquad[y] = {}
		for x = 1, 4 do --goombainshoe
			goombashoewingsquad[y][x] = love.graphics.newQuad((x-1)*18, (y-1)*24, 18, 24, 72, 96)
		end --
		for x = 5, 8 do --just shoe
			goombashoewingsquad[y][x] = love.graphics.newQuad((x-5)*18, 8+(y-1)*24, 18, 16, 72, 96)
		end
	end

	shoeghostquad = {} --Shoe squishy bois
	y=1
	shoeghostquad[y] = {}
	for x=1,5 do
		shoeghostquad[y][x] = love.graphics.newQuad((x-1)*26, (y-1)*16, 26, 16, 130, 16)
	end
	
	wigglerquad = {}
	for y = 1, 2 do
		wigglerquad[y] = {}
		for x = 1, 5 do
			wigglerquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*28, 16, 28, 80, 56)
		end
	end
	
	magikoopaquad = {}
	for y = 1, 4 do
		magikoopaquad[y] = {}
		for x = 1, 3 do
			magikoopaquad[y][x] = love.graphics.newQuad((x-1)*24, (y-1)*28, 24, 28, 72, 112)
		end
	end
	
	magikoopamagicquad = {}
	for x = 1, 3 do
		magikoopamagicquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 48, 16)
	end
	
	boocrawlerquad = {}
	for y = 1, 4 do
		boocrawlerquad[y] = {}
		for x = 1, 5 do
			boocrawlerquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*16, 32, 16, 160, 64)
		end
	end
	
	skewerquad = {}
	for y = 1, 4 do
		skewerquad[y] = {}
		for y2 = 1, 3 do
			skewerquad[y][y2] = love.graphics.newQuad(0, ((y-1)*48)+((y2-1)*16), 64, 16, 64, 192)
		end
	end
	
	bigcloudquad = {}
	for y = 1, 4 do
		bigcloudquad[y] = love.graphics.newQuad(0, 16*(y-1), 20, 16, 20, 64)
	end
	
	beltquad = {}
	for y = 1, 4 do
		beltquad[y] = {}
		for x = 1, 24 do
			beltquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 384, 64)
		end
	end

	gatequad = {}
	for x = 1, 9 do
		gatequad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 160, 16)
	end

	collectablequad = {}
	for s = 1, 4 do
		collectablequad[s] = {}
		for t = 1, 10 do
			collectablequad[s][t] = {}
			for f = 1, 5 do
				collectablequad[s][t][f] = love.graphics.newQuad((f-1)*32, (t-1)*128+(s-1)*32, 32, 32, 160, 1280)
			end
		end
	end

	superballquad = {}
	superballquad[1] = love.graphics.newQuad(0, 0, 12, 12, 24, 12)
	superballquad[2] = love.graphics.newQuad(12, 0, 12, 12, 24, 12)

	smallspringquad = {}
	for x = 1, 7 do
		smallspringquad[x] = love.graphics.newQuad(16*(x-1), 0, 16, 24, 112, 24)
	end

	iciclebigquad = {}
	iciclebigquad[1] = love.graphics.newQuad(0, 0, 16, 32, 48, 32)
	iciclebigquad[2] = love.graphics.newQuad(16, 0, 16, 32, 48, 32)
	icicledebrisquad = {}
	for y = 1, 4 do
		for x = 1, 2 do
			table.insert(icicledebrisquad, love.graphics.newQuad(32+8*(x-1), 8*(y-1), 8, 8, 48, 32))
		end
	end
	iciclehugequad = {}
	iciclehugequad[1] = love.graphics.newQuad(0, 0, 64, 64, 128, 64)
	iciclehugequad[2] = love.graphics.newQuad(64, 0, 64, 64, 128, 64)
	
	risingwaterquad = {}
	for s = 1, 4 do --spriteset
		risingwaterquad[s] = {}
		for i = 1, 6 do --type
			risingwaterquad[s][i] = {}
			for y = 1, 2 do --depth
				risingwaterquad[s][i][y] = {}
				for x = 1, 4 do --frame
					risingwaterquad[s][i][y][x] = love.graphics.newQuad(64*(i-1)+16*(x-1), 32*(s-1)+16*(y-1), 16, 16, 384, 128)
				end
			end
		end
	end

	spikequad = {}
	for y = 1, 4 do
		spikequad[y] = {}
		for x = 1, 6 do
			spikequad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 96, 64)
		end
	end

	helmetshellquad = {}
	for s = 1, 4 do
		helmetshellquad[s] = {}
		for i = 1, 2 do
			helmetshellquad[s][i] = {}
			for x = 1, 2 do
				helmetshellquad[s][i][x] = love.graphics.newQuad(16*(x-1)+32*(i-1), (s-1)*16, 16, 16, 64, 64)
			end
		end
	end

	flagquad = {}
	for y = 1, 4 do
		--hay aleasn, im just wondering.. what are the exxtra flag frames for?
		--gee i wonder
		--oh, don't mind me, im just predicting what people are going to say
		flagquad[y] = {}
		for x = 1, 4 do
			flagquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 16*4, 64)
		end
	end

	helmetpropellerquad = {}
	for x = 1, 4 do
		helmetpropellerquad[x] = love.graphics.newQuad(16*(x-1), 0, 16, 24, 64, 24)
	end
	helmetcannonquad = {}
	helmetcannonquad.box = love.graphics.newQuad(0, 0, 16, 16, 48, 16)
	for x = 1, 2 do
		helmetcannonquad[x] = love.graphics.newQuad(24*(x-1), 0, 24, 16, 48, 16)
	end

	clearpipequad = {}
	for x = 1, 8 do
		clearpipequad[x] = {}
		for y = 1, 5 do
			clearpipequad[x][y] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 128, 80)
		end
	end

	plantcreeperquad = {}
	plantcreeperquad.head = {}
	plantcreeperquad.head[1] = love.graphics.newQuad(0, 0, 32, 32, 128, 64)
	plantcreeperquad.head[2] = love.graphics.newQuad(0, 32, 32, 32, 128, 64)
	plantcreeperquad.head[3] = love.graphics.newQuad(32, 0, 32, 32, 128, 64)
	plantcreeperquad.head[4] = love.graphics.newQuad(32, 32, 32, 32, 128, 64)
	plantcreeperquad[1] = love.graphics.newQuad(112, 32, 16, 16, 128, 64)
	plantcreeperquad[2] = love.graphics.newQuad(64, 0, 16, 16, 128, 64)
	plantcreeperquad[3] = love.graphics.newQuad(64, 16, 24, 24, 128, 64)
	plantcreeperquad[4] = love.graphics.newQuad(88, 16, 24, 24, 128, 64)
	plantcreeperquad[5] = love.graphics.newQuad(64, 40, 24, 24, 128, 64)
	plantcreeperquad[6] = love.graphics.newQuad(88, 40, 24, 24, 128, 64)

	trackquad = {}
	for x = 1, 8 do
		trackquad[x] = {}
		for y = 1, 8 do
			trackquad[x][y] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 128, 128)
		end
	end

	local t = {
		{"r","l","d","u","rd","lu","ru","ld"},
		{"o","c"},
		{},
		{},
		{},
		{},
		{},
		{},
	}
	trackquadids = {}
	for y = 1, #t do
		for x = 1, #t[y] do
			trackquadids[t[y][x]] = {x, y}
		end
	end

	dustquad = {}
	dustquad[1] = love.graphics.newQuad(0, 0, 16, 16, 32, 16)
	dustquad[2] = love.graphics.newQuad(16, 0, 16, 16, 32, 16)

	checkpointflagquad = {}
	for y = 1, 4 do
		checkpointflagquad[y] = {}
		for x = 1, 7 do
			checkpointflagquad[y][x] = love.graphics.newQuad(32*(x-1), 32*(y-1), 32, 32, 32*7, 128)
		end
	end

	upfirequad = love.graphics.newQuad(0,0,16,16,16,16)

	grinderquad = {}
	for x = 1, 3 do
		grinderquad[x] = love.graphics.newQuad(48*(x-1), 0, 48, 48, 48*3, 48)
	end

	doorpiecequad = {}
	for y = 1, 4 do
		doorpiecequad[y] = love.graphics.newQuad(0, 16*(y-1), 16, 16, 16, 64)
	end
	doorcenterquad = {}
	for y = 1, 4 do
		doorcenterquad[y] = love.graphics.newQuad(0, 4*(y-1), 4, 4, 4, 16)
	end

	clawquad = {}
	for s = 1, 4 do
		clawquad[s] = {}
		for i = 1, 3 do
			clawquad[s][i] = love.graphics.newQuad((i-1)*48, (s-1)*48, 48, 32, 144, 192)
		end
		clawquad[s][4] = love.graphics.newQuad(0, ((s-1)*48)+32, 16, 16, 144, 192)
		clawquad[s][5] = love.graphics.newQuad(16, ((s-1)*48)+32, 16, 16, 144, 192)
	end
	--poofs
	poofquad = {}
	for y = 1, 4 do
		poofquad[y] = {}
		for x = 1, 34 do
			poofquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 512, 64)
		end
	end
end

function fixsprites(reset)
	if coinimage:getWidth() == 64 and (not reset) then
		SPRITESfixcoin = true
		coinquads = {}
		for j = 1, 4 do
			coinquads[j] = {}
			for i = 1, 3 do
				coinquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
			end
			coinquads[j][4] = coinquads[j][2]
			coinquads[j][5] = coinquads[j][1]
		end
	elseif SPRITESfixcoin then
		coinquads = {}
		for j = 1, 4 do
			coinquads[j] = {}
			for i = 1, 5 do
				coinquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
			end
		end
		SPRITESfixcoin = false
	end
	if coinblockimage:getWidth() == 64 and (not reset) then
		SPRITESfixcoinblock = true
		coinblockquads = {}
		for j = 1, 4 do
			coinblockquads[j] = {}
			for i = 1, 3 do
				coinblockquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 64, 64)
			end
			coinblockquads[j][4] = coinblockquads[j][2]
			coinblockquads[j][5] = coinblockquads[j][1]
		end
	elseif SPRITESfixcoinblock then
		coinblockquads = {}
		for j = 1, 4 do
			coinblockquads[j] = {}
			for i = 1, 5 do
				coinblockquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*16, 16, 16, 80, 64)
			end
		end
		SPRITESfixcoinblock = false
	end
	if platformimg:getWidth() == 16 and (not reset) then
		SPRITESfixplatform = true
		platformquad = {}
		for x = 1, 3 do
			platformquad[x] = love.graphics.newQuad(0, 0, 16, 8, 16, 8)
		end
		platformquad[1.5] = love.graphics.newQuad(0, 0, 8, 8, 16, 8)
		platformquad[2.5] = love.graphics.newQuad(0, 0, 8, 8, 16, 8)
	elseif SPRITESfixplatform then
		platformquad = {}
		for x = 1, 3 do
			platformquad[x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 48, 16)
		end
		platformquad[1.5] = love.graphics.newQuad((2-1)*16, 0, 8, 16, 48, 16)
		platformquad[2.5] = love.graphics.newQuad((3-1)*16+8, 0, 8, 16, 48, 16)
		SPRITESfixplatform = false
	end
	if seesawimg:getHeight() == 16 and (not reset) then
		SPRITESfixseesaw = true
		seesawquad = {}
		for s = 1, 4 do
			seesawquad[s] = {}
			for i = 1, 4 do
				seesawquad[s][i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 64, 16)
			end
		end
	elseif SPRITESfixseesaw then
		seesawquad = {}
		for s = 1, 4 do
			seesawquad[s] = {}
			for i = 1, 4 do
				seesawquad[s][i] = love.graphics.newQuad((i-1)*16, (s-1)*16, 16, 16, 64, 64)
			end
		end
		SPRITESfixseesaw = false
	end
	if pushbuttonimg:getHeight() == 16 and (not reset) then
		SPRITESfixpushbutton = true
		pushbuttonquad = {}
		for y = 1, 4 do
			pushbuttonquad[y] = {}
			for x = 1, 2 do
				pushbuttonquad[y][x] = love.graphics.newQuad(16*(x-1), 0, 16, 16, 32, 16)
			end
		end
	elseif SPRITESfixpushbutton then
		pushbuttonquad = {}
		for y = 1, 4 do
			pushbuttonquad[y] = {}
			for x = 1, 2 do
				pushbuttonquad[y][x] = love.graphics.newQuad(16*(x-1), 16*(y-1), 16, 16, 32, 64)
			end
		end
		SPRITESfixpushbutton = false
	end
	if plantimg:getHeight() == 128 and (not reset) then
		SPRITESfixplant = true
		plantimg:setWrap("clamp", "clampzero")
		plantquads = {}
		for j = 1, 4 do
			plantquads[j] = {}
			for i = 1, 2 do
				plantquads[j][i] = love.graphics.newQuad((i-1)*16, -1+(j-1)*23, 16, 24, 32, 128)
			end
		end
	elseif SPRITESfixplant then
		plantquads = {}
		for j = 1, 4 do
			plantquads[j] = {}
			for i = 1, 2 do
				plantquads[j][i] = love.graphics.newQuad((i-1)*16, (j-1)*24, 16, 24, 32, 96)
			end
		end
		SPRITESfixplant = false
	end
	if cheepcheepimg:getHeight() == 32 and (not reset) then
		SPRITESfixcheepcheep = true
		cheepcheepquad = {}
		for y = 1, 4 do
			cheepcheepquad[y] = {}
			for x = 1, 2 do
				local x2 = x
				cheepcheepquad[y][x2] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 32, 32)
				x2 = x2 + 2
				cheepcheepquad[y][x2] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 32, 32)
			end
		end
	elseif SPRITESfixcheepcheep then
		cheepcheepquad = {}
		for y = 1, 4 do
			cheepcheepquad[y] = {}
			for x = 1, 4 do
				cheepcheepquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
			end
		end
		SPRITESfixcheepcheep = false
	end
	if yoshiimage:getWidth() == 300 and (not reset) then
		SPRITESfixyoshi = true
		yoshiquad = {}
		for y = 1, 4 do
			yoshiquad[y] = {}
			for x = 1, 18 do
				if x > 8 then
					yoshiquad[y][x] = yoshiquad[y][2]
				elseif x == 12 then
					yoshiquad[y][x] = yoshiquad[y][6]
				else
					yoshiquad[y][x] = love.graphics.newQuad((x-1)*30, (y-1)*35, 30, 35, 300, 140)
				end
			end
			yoshiquad[y][19] = love.graphics.newQuad(240, (y-1)*35, 4, 4, 300, 140) --tounge
		end
	elseif SPRITESfixyoshi then
		yoshiquad = {}
		for y = 1, 4 do
			yoshiquad[y] = {}
			for x = 1, 18 do
				yoshiquad[y][x] = love.graphics.newQuad((x-1)*30, (y-1)*35, 30, 35, 570, 140)
			end
			yoshiquad[y][19] = love.graphics.newQuad(540, (y-1)*35, 4, 4, 570, 140) --tounge
		end
		SPRITESfixyoshi = false
	end
	if squidimg:getHeight() == 32 and (not reset) then
		squidquad = {}
		for y = 1, 4 do
			squidquad[y] = {}
			for x = 1, 2 do
				squidquad[y][x] = love.graphics.newQuad((x-1)*16, 0, 16, 24, 32, 32)
			end
		end
		SPRITESfixsquid = true
	elseif SPRITESfixsquid then
		squidquad = {}
		for y = 1, 4 do
			squidquad[y] = {}
			for x = 1, 2 do
				squidquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*32, 16, 24, 32, 128)
			end
		end
		SPRITESfixsquid = false
	end
	if squidbabyimg:getHeight() == 11 and (not reset) then
		squidbabyquad = {}
		for y = 1, 4 do
			squidbabyquad[y] = {}
			for x = 1, 2 do
				squidbabyquad[y][x] = love.graphics.newQuad((x-1)*7, 0, 7, 11, 14, 11)
			end
		end
		SPRITESfixsquidbaby = true
	elseif SPRITESfixsquidbaby then
		squidbabyquad = {}
		for y = 1, 4 do
			squidbabyquad[y] = {}
			for x = 1, 2 do
				squidbabyquad[y][x] = love.graphics.newQuad((x-1)*7, (y-1)*11, 7, 11, 14, 44)
			end
		end
		SPRITESfixsquidbaby = false
	end
	
	if koopalingimg:getHeight() == 294 and (not reset) then
		koopalingquad = {}
		for y = 1, 7 do
			koopalingquad[y] = {}
			for x = 1, 4 do
				koopalingquad[y][x] = love.graphics.newQuad((x-1)*40, (y-1)*36, 40, 36, 329, 294)
			end
			for x = 5, 9 do
				koopalingquad[y][x] = love.graphics.newQuad(160+(x-5)*21, (y-1)*36, 21, 17, 329, 294)
			end
			for x = 10, 13 do
				koopalingquad[y][x] = love.graphics.newQuad(265+(x-10)*16, (y-1)*36, 16, 20, 329, 294)
			end
		end
		koopalingquad[9] = {}
		for x = 1, 9 do
			koopalingquad[9][x] = love.graphics.newQuad((x-1)*36, 252, 36, 42, 329, 294)
		end
		SPRITESfixkoopaling = true
	elseif SPRITESfixkoopaling then
		koopalingquad = {}
		for y = 1, 8 do
			koopalingquad[y] = {}
			for x = 1, 4 do
				koopalingquad[y][x] = love.graphics.newQuad((x-1)*40, (y-1)*36, 40, 36, 376, 336)
			end
			for x = 5, 13 do
				koopalingquad[y][x] = love.graphics.newQuad(160+(x-5)*24, (y-1)*36, 24, 24, 376, 336)
			end
		end
		koopalingquad[9] = {}
		for x = 1, 9 do
			koopalingquad[9][x] = love.graphics.newQuad((x-1)*36, 288, 36, 42, 376, 336)
		end
		SPRITESfixkoopaling = false
	end

	if thwompimage:getWidth() == 120 and (not reset) then
		SPRITESfixthwomp = true
		thwompquad = {}
		for y = 1, 4 do
			thwompquad[y] = {}
			for x = 1, 5 do
				thwompquad[y][x] = love.graphics.newQuad((x-1)*24, (y-1)*32, 24, 32, 120, 128)
			end
			thwompquad[y][6] = thwompquad[y][3]
			thwompquad[y][7] = thwompquad[y][1]
		end
	elseif SPRITESfixthwomp then
		thwompquad = {}
		for y = 1, 4 do
			thwompquad[y] = {}
			for x = 1, 7 do
				thwompquad[y][x] = love.graphics.newQuad((x-1)*24, (y-1)*32, 24, 32, 168, 128)
			end
		end
		SPRITESfixthwomp = false
	end
	
	if risingwaterimg:getWidth() == 320 and (not reset) then
		SPRITESfixrisingwater = true
		risingwaterquad = {}
		for s = 1, 4 do --spriteset
			risingwaterquad[s] = {}
			for i = 1, 5 do --type
				risingwaterquad[s][i] = {}
				for y = 1, 2 do --depth
					risingwaterquad[s][i][y] = {}
					for x = 1, 4 do --frame
						risingwaterquad[s][i][y][x] = love.graphics.newQuad(64*(i-1)+16*(x-1), 32*(s-1)+16*(y-1), 16, 16, 320, 128)
					end
				end
			end
			--risingwaterquad[s][6][y][x] = risingwaterquad[s][2][y][x]
		end
	elseif SPRITESfixrisingwater then
		risingwaterquad = {}
		for s = 1, 4 do --spriteset
			risingwaterquad[s] = {}
			for i = 1, 6 do --type
				risingwaterquad[s][i] = {}
				for y = 1, 2 do --depth
					risingwaterquad[s][i][y] = {}
					for x = 1, 4 do --frame
						risingwaterquad[s][i][y][x] = love.graphics.newQuad(64*(i-1)+16*(x-1), 32*(s-1)+16*(y-1), 16, 16, 384, 128)
					end
				end
			end
		end
		SPRITESfixrisingwater = false
	end

	if pedestalimage:getWidth() == 160 and (not reset) then
		SPRITESfixpedestal = true
		pedestalquad = {}
		for y = 1, 4 do
			pedestalquad[y] = {}
			for x = 1, 10 do
				pedestalquad[y][x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 160, 16)
			end
			for i = 10, 1, -1 do
				pedestalquad[y][i+1] = pedestalquad[y][i]
			end
		end
	elseif SPRITESfixpedestal then
		pedestalquad = {}
		for y = 1, 4 do
			pedestalquad[y] = {}
			for x = 1, 11 do
				pedestalquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 176, 64)
			end
		end
		SPRITESfixpedestal = false
	end

	if emancesideimg:getWidth() == 10 and (not reset) then
		SPRITESfixemanceside = true
		emancesidequad = {}
		for y = 1, 4 do
			emancesidequad[y] = {}
			for x = 1, 2 do
				emancesidequad[y][x] = love.graphics.newQuad((x-1)*5, (y-1)*8, 5, 8, 10, 32)
			end
			emancesidequad[y][3] = emancesidequad[y][1]
			emancesidequad[y][4] = emancesidequad[y][1]
			emancesidequad[y][5] = emancesidequad[y][1]
			emancesidequad[y][6] = emancesidequad[y][1]
			emancesidequad[y][7] = emancesidequad[y][1]
			emancesidequad[y][8] = emancesidequad[y][1]
			emancesidequad[y][9] = emancesidequad[y][1]
			emancesidequad[y][10] = emancesidequad[y][1]
		end
	elseif SPRITESfixemanceside then
		emancesidequad = {}
		for y = 1, 4 do
			emancesidequad[y] = {}
			for x = 1, 10 do
				emancesidequad[y][x] = love.graphics.newQuad((x-1)*5, (y-1)*8, 5, 8, 50, 32)
			end
		end
		SPRITESfixemanceside = false
	end

	if emanceparticleimg:getWidth() == 1 and (not reset) then
		SPRITESfixemanceparticle = true
		emanceparticlequad = {}
		for x = 1, 6 do
			emanceparticlequad[x] = love.graphics.newQuad(0, 0, 1, 64, 1, 64)
		end
	elseif SPRITESfixemanceparticle then
		emanceparticlequad = {}
		for x = 1, 6 do
			emanceparticlequad[x] = love.graphics.newQuad((x-1), 0, 1, 64, 6, 64)
		end
		SPRITESfixemanceparticle = false
	end

	if vineimg:getWidth() == 32 and (not reset) then
		SPRITESfixvine = true
		vinequad = {}
		for i = 1, 4 do
			vinequad[i] = {}
			for j = 1, 2 do
				vinequad[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*16, 16, 16, 32, 64) 
			end
			vinequad[i][5] = vinequad[i][2]
			vinequad[i][6] = vinequad[i][2]
			vinequad[i][7] = vinequad[i][2]
			vinequad[i][8] = vinequad[i][2]
			vinequad[i][2] = vinequad[i][1]
			vinequad[i][3] = vinequad[i][1]
			vinequad[i][4] = vinequad[i][1]
		end
	elseif SPRITESfixvine then
		vinequad = {}
		for i = 1, 4 do
			vinequad[i] = {}
			for j = 1, 8 do
				vinequad[i][j] = love.graphics.newQuad((j-1)*16, (i-1)*16, 16, 16, 128, 64) 
			end
		end
		SPRITESfixvine = false
	end

	if geldispenserimg:getWidth() == 32 and (not reset) then
		SPRITESfixgeldispenser = true
		geldispenserquad = {}
		for y = 1, 4 do
			geldispenserquad[y] = {}
			for x = 1, 5 do
				geldispenserquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 160, 128)
			end
			geldispenserquad[y][6] = geldispenserquad[y][5]
		end
	elseif SPRITESfixgeldispenser then
		geldispenserquad = {}
		for y = 1, 4 do
			geldispenserquad[y] = {}
			for x = 1, 6 do
				geldispenserquad[y][x] = love.graphics.newQuad((x-1)*32, (y-1)*32, 32, 32, 192, 128)
			end
		end
		SPRITESfixgeldispenser = false
	end

	if energylauncherimage:getWidth() == 32 and (not reset) then
		SPRITESfixenergylauncher = true
		energylauncherquad = {}
		for y = 1, 2 do
			energylauncherquad[y] = {}
			for x = 1, 2 do
				energylauncherquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 32, 32)
			end
		end
		energylauncherquad[1][1] = energylauncherquad[1][1]
		energylauncherquad[1][2] = energylauncherquad[1][2]
		energylauncherquad[1][3] = energylauncherquad[1][2]
		energylauncherquad[1][4] = energylauncherquad[2][1]
		energylauncherquad[1][5] = energylauncherquad[2][2]
		energylauncherquad[1][6] = energylauncherquad[2][2]
		energylauncherquad[2] = energylauncherquad[1]
		energylauncherquad[3] = energylauncherquad[1]
		energylauncherquad[4] = energylauncherquad[1]
	elseif SPRITESfixenergylauncher then
		energylauncherquad = {}
		for y = 1, 4 do
			energylauncherquad[y] = {}
			for x = 1, 6 do
				energylauncherquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 96, 64)
			end
		end
		SPRITESfixenergylauncher = false
	end

	if groundlightimg:getWidth() == 96 and (not reset) then
		SPRITESfixgroundlight = true
		groundlightquad = {}
		for s = 1, 4 do
			groundlightquad[s] = {}
			for x = 1, 12 do
				groundlightquad[s][x] = {}
				for y = 1, 2 do
					groundlightquad[s][x][y] = love.graphics.newQuad((x-1)*16, (s-1)*32+(y-1)*16, 16, 16, 96, 128)
				end
			end
		end
	elseif SPRITESfixgroundlight then
		groundlightquad = {}
		for s = 1, 4 do
			groundlightquad[s] = {}
			for x = 1, 12 do
				groundlightquad[s][x] = {}
				for y = 1, 2 do
					groundlightquad[s][x][y] = love.graphics.newQuad((x-1)*16, (s-1)*32+(y-1)*16, 16, 16, 192, 128)
				end
			end
		end
		SPRITESfixgroundlight = false
	end

	if lasersideimg:getHeight() == 16 and (not reset) then
		SPRITESfixlaserside = true
		lasersidequad = {}
		for y = 1, 4 do
			lasersidequad[y] = love.graphics.newQuad(0, 0, 16, 16, 16, 16)
		end
	elseif SPRITESfixlaserside then
		lasersidequad = {}
		for y = 1, 4 do
			lasersidequad[y] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 16, 64)
		end
		SPRITESfixlaserside = false
	end

	if lightbridgesideimg:getHeight() == 16 and (not reset) then
		SPRITESfixlightbridgeside = true
		lightbridgesidequad = {}
		for y = 1, 4 do
			lightbridgesidequad[y] = love.graphics.newQuad(0, 0, 16, 16, 16, 16)
		end
	elseif SPRITESfixlightbridgeside then
		lightbridgesidequad = {}
		for y = 1, 4 do
			lightbridgesidequad[y] = love.graphics.newQuad(0, (y-1)*16, 16, 16, 16, 64)
		end
		SPRITESfixlightbridgeside = false
	end

	if laserdetectorimg:getHeight() == 16 and (not reset) then
		SPRITESfixlaserdetector = true
		laserdetectorquad = {}
		for y = 1, 4 do
			laserdetectorquad[y] = {}
			for x = 1, 2 do
				laserdetectorquad[y][x] = love.graphics.newQuad((x-1)*16, 0, 16, 16, 32, 16)
			end
			laserdetectorquad[y][3] = laserdetectorquad[y][1]
			laserdetectorquad[y][4] = laserdetectorquad[y][2]
		end
	elseif SPRITESfixlaserdetector then
		laserdetectorquad = {}
		for y = 1, 4 do
			laserdetectorquad[y] = {}
			for x = 1, 4 do
				laserdetectorquad[y][x] = love.graphics.newQuad((x-1)*16, (y-1)*16, 16, 16, 64, 64)
			end
		end
		SPRITESfixlaserdetector = false
	end

	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom/smbtiles.png") and (not reset) then
		--add smb tiles
		customsmbtiles = true
		local imgwidth, imgheight = smbtilesimg:getWidth(), smbtilesimg:getHeight()
		local width = math.floor(imgwidth/17)
		local height = math.floor(imgheight/17)
		local secretstart = 7
		local imgdata = love.image.newImageData(mappackfolder .. "/" .. mappack .. "/custom/smbtiles.png")
		
		for y = 1, height do
			for x = 1, width do
				local i = ((y-1)*22)+x
				if y >= secretstart then
					i = ((secretstart-1)*22) + (.01*((y*22+x)-(secretstart*22)))
				end
				tilequads[i] = nil
				tilequads[i] = quad:new(smbtilesimg, imgdata, x, y, imgwidth, imgheight)
			end
		end
		collectgarbage()
	elseif customsmbtiles then
		local imgwidth, imgheight = smbtilesimg:getWidth(), smbtilesimg:getHeight()
		local width = math.floor(imgwidth/17)
		local height = math.floor(imgheight/17)
		local secretstart = 7
		local imgdata = love.image.newImageData("graphics/" .. graphicspack .. "/smbtiles.png")
		
		for y = 1, height do
			for x = 1, width do
				local i = ((y-1)*22)+x
				if y >= secretstart then
					i = ((secretstart-1)*22) + (.01*((y*22+x)-(secretstart*22)))
				end
				tilequads[i] = nil
				tilequads[i] = quad:new(smbtilesimg, imgdata, x, y, imgwidth, imgheight)
			end
		end
		collectgarbage()
		customsmbtiles = false
	end

	if love.filesystem.exists(mappackfolder .. "/" .. mappack .. "/custom/entities.png") and (not reset) then
		for i, t in pairs(entityquads) do
			t.image = entitiesimg
		end
		customentityquads = true
	elseif customentityquads then
		for i, t in pairs(entityquads) do
			t.image = entitiesimg
		end
		customentityquads = false
	end
end
