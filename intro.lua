function intro_load()
	gamestate = "intro"
	
	introduration = 2.5
	blackafterintro = 0.3
	introfadetime = 0.5
	introprogress = 0.5
	
	screenwidth = width*16*scale
	screenheight = 224*scale
	allowskip = false
end

function intro_update(dt)
	allowskip = true
	if introprogress < introduration+blackafterintro then
		introprogress = introprogress + dt
		if introprogress > introduration+blackafterintro then
			introprogress = introduration+blackafterintro
		end
		
		if introprogress > 0.5 and playedwilhelm == nil then
			if math.random(300) == 1 then
				playsound(babysound)
			elseif math.random(300) == 1 then
				playsound(checkpointsound)
			else
				playsound(stabsound)
			end
			
			playedwilhelm = true
		end
		
		if introprogress == introduration + blackafterintro then
			menu_load()
		end
	end
end

function intro_draw()
	local logoscale = scale
	if logoscale <= 1 then
		logoscale = 0.5
	else
		logoscale = 1
	end
	if introprogress >= 0 and introprogress < introduration then
		local a = 255
		if introprogress < introfadetime then
			a = introprogress/introfadetime * 255
		elseif introprogress >= introduration-introfadetime then
			a = (1-(introprogress-(introduration-introfadetime))/introfadetime) * 255
		end
		
		love.graphics.setColor(255, 255, 255, a)
		
		if introprogress > introfadetime+0.3 and introprogress < introduration - introfadetime then
			local y = (introprogress-0.2-introfadetime) / (introduration-2*introfadetime) * 206 * 5
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, logoscale, logoscale, 142, 150)
			love.graphics.setScissor(0, screenheight/2+150*logoscale - y, screenwidth, y)
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, logoscale, logoscale, 142, 150)
			love.graphics.setScissor()
		elseif introprogress >= introduration - introfadetime then
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, logoscale, logoscale, 142, 150)
		else
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, logoscale, logoscale, 142, 150)
		end
		
		local a2 = math.max(0, (1-(introprogress-.5)/0.3)*255)
		love.graphics.setColor(150, 150, 150, a2)
		properprint("loading ace...", love.graphics.getWidth()/2-string.len("loading ace...")*4*scale, 20*scale)
		love.graphics.setColor(50, 50, 50, a2)
		properprint(loadingtext, love.graphics.getWidth()/2-string.len(loadingtext)*4*scale, love.graphics.getHeight()/2+165*logoscale)

		love.graphics.setColor(255,255,255, a2)
		for i = 1, 8 do
			love.graphics.rectangle("fill", ((i*10)-5)*scale, ((height*16)-10)*scale, 5*scale, 5*scale)
		end
		--love.graphics.rectangle("fill", 0, (height*16-3)*scale, (width*16)*scale, 3*scale)
	end
end

function intro_mousepressed()
	if not allowskip then
		return
	end
	stabsound:stop()
	menu_load()
end

function intro_keypressed()
	if not allowskip then
		return
	end
	stabsound:stop()
	menu_load()
end