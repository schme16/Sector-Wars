
	
	game = {
		state = 'menu',
		bgColour = {0,0,0,255},
		startShipCount = 100,
	}
	
	ships = {}
	
	

	
	
function game:run() --calls the game state 
	if game.state == 'running' then
		if cam then cam:draw(function() game[game.state]() end ) else game[game.state]() end
	else
		game[game.state]()
	end
end
addDraw('The games run func',game.run)


function game:wait() 
	--This function is deliberatly empty
end


--General playing
function game:running()

	if keyboard.newPress["a"] then
		aiFunctions:run()
	end
	
	if keyboard.newPress["escape"] and not gui.showMenu then
		fadeLib:fadeOut( function() game.state = 'wait' aiFunctions:pause() gui.menu = "inGameMenu"  gui.open() gui.menu = "inGameMenu"  fadeLib:fadeIn( function() end, 0.5) end, 0.5)
	elseif keyboard.newPress["escape"] and gui.showMenu then
		gui.close()
	end 
	
	if mouse.newPress["wheelDown"] and players[localPlayer].sendAmount > 1 then
		players[localPlayer].sendAmount = players[localPlayer].sendAmount - 5
	elseif mouse.newPress["wheelUp"] and players[localPlayer].sendAmount < 100 then		
		players[localPlayer].sendAmount = players[localPlayer].sendAmount + 5
	end	
	
	local mouseOverPlanet = game.returnMouseOver()


	if mouse.newPress['r'] and mouseOverPlanet then
		game.sendShips( mouseOverPlanet, localPlayer )
	end

	for k,v in pairs(players) do
		if game.getShipCount(v.playerNum) < 1 then
			game.endGame()
		end
	end
	
	--draws the players
	game.draw()
	message.run()
end


--clears current game data
function game:reset()
	teams = {} --Each of the teams
	players = false --Each of the players
	planets = false --A list of planets
	ships = {}	--A list of `ships`
	localPlayer = false --The local player 
	server.obj = false
	client.obj = false
	messages = {}
	aiFunctions:remove()
end


--Main menu/in-game Menu
function game:menu()


end


function game:endGame()

	

end


function game:newServer()

	game:reset()
	numPlanets = 32 --math.random(30,40) [forty seems to be as many as can be send at present without breaking the network functions, to be safe I've set it lower]
	local i = 0
	breakNum = 0
	planets = {}
	--first
	while i < numPlanets  do
		local plan = game.createPlanet(13,22)
		if plan then
			table.insert(planets,plan)
		end
		i = #planets
	end
	
	players = {}
	--now we'll build the players
		game.addPlayer({name = 'Player 1', colour = colours.green, shipCount = 0, sendAmount = 75, AI = false})
		game.addPlayer({name = 'Player 2', colour = colours.blue, shipCount = 0, sendAmount = 75, AI = true})
		--game.addPlayer({name = 'Player 3', colour = colours.red, shipCount = 0, sendAmount = 75, AI = true})
		--game.addPlayer({name = 'Player 4', colour = colours.yellow, shipCount = 0, sendAmount = 75, AI = true})
	
	
	--LocalPlayer is ALWAYS `Player 1`
	localPlayer = 1
	

	
	
	if not server.obj then server.load() game.state = "running" aiFunctions:init() end

end


function game:joinServer()
	love.graphics.draw(images.starfield, 0,0)
	advPrint('Please Wait...', 250, 250, {255,255,255,255}, fonts.menu)
	if client and not client.connected then
		advPrint('Connecting to Server: Connecting', 250, 365, {255,255,255,255}, fonts.general)
	else	
		advPrint('Connecting to Server: Connected', 250, 365, {255,255,255,255}, fonts.general)
	end
	
	if not client.obj then
		client.load('localhost')
		
		else
			if localPlayer and players and planets and client.obj then 
				game.state = "running"
			else
			client.obj:send(table.compressSave({dataType='getShips', value = ''}))
			
			if not planets then
				if client.obj then 
					client.obj:send(table.compressSave({dataType='getMap', value = ''}))
				end
				advPrint('Map: Loading', 250, 400, {255,255,255,255}, fonts.general)
			else	
				advPrint('Map: Loading - Done', 250, 400, {255,255,255,255}, fonts.general)
			end
				
				if not players then
					if client.obj then 
						client.obj:send(table.compressSave({dataType='getPlayers', value = ''}))
					end		
					advPrint('Player List: Loading', 250, 440, {255,255,255,255}, fonts.general)
				else	
					advPrint('Player List: Loading - Done', 250, 440, {255,255,255,255}, fonts.general)
				end	
			end
		end

	
end


function game:draw()
	love.graphics.draw(images.starfield, 0,0)
	game.planetUpdates()
	game.shipUpdate()
	gui.HUD()

end


function game.shipUpdate()
	

	local circ = {};
	local toCirc = {};
	local rise = 1;
	local run = 1;
	local distance = 1;
	local deg = 1
	local r, g, b, a = love.graphics.getColor( ) 	
	
	for i,v in pairs(ships) do
		if not v.toDegree then v.toDegree = (math.random(-360,360)) end
		
		v.x = (v.x) + v.run
		v.y = (v.y) + v.rise
		v.radius = 2
		
		if v.x and v.y and planets[v.to].x and planets[v.to].y and circleOverlap(v, planets[v.to]) then
			if planets[v.to].shipCount  < 1 then game.assignPlanet(v.to, v.owner) end
			
			local shipCount = planets[v.to].shipCount
			
			if planets[v.to].owner == v.owner then 
				planets[v.to].shipCount = planets[v.to].shipCount + v.shipCount
			else
				if planets[v.to].shipCount - v.shipCount < 1 then 
					planets[v.to].shipCount = (v.shipCount - planets[v.to].shipCount)
					game.assignPlanet(v.to, v.owner)
				else
					planets[v.to].shipCount = planets[v.to].shipCount - v.shipCount
				end
			end

			if planets[v.to].shipCount < 1 and not planets[v.to].owner == false then planets[v.to].owner = false end
			
			ships[i] = nil
			end	

			
		tempColor = players[v.owner].colour
		love.graphics.setColorMode("modulate")		
		love.graphics.setColor(tempColor[1], tempColor[2], tempColor[3], tempColor[4])
		
		love.graphics.draw(images.ship, v.x, v.y, v.angle )
		--love.graphics.circle('line', v.x, v.y, 3, 100)
		love.graphics.setColorMode("replace")
		love.graphics.setColor(r,g,b,a)
	end
end


function game.planetUpdates()

	--save the current set colour
	local r, g, b, a = love.graphics.getColor( ) 	
	
	
		for i,v in pairs(planets) do
			v.rotation = math.round(v.rotation + (0.05/v.radius), 3)
		if v.owner then
			v.shipCount = v.shipCount + (love.timer.getDelta()*(v.growthRate/1.5))
		end
		
		if not (v.owner == localPlayer) then
			v.selected = false
		end
		
		
	--drawing the selectors and selections
		if circleOverlap({x = mouse.X, y = mouse.Y, radius = 1}, {x = v.x, y = v.y, radius = v.radius}) and mouse.newPress['l'] and v.owner == localPlayer then
			if love.keyboard.isDown('rctrl') then
				if v.selected == localPlayer or love.keyboard.isDown('lctrl') then
					v.selected = false
				else
					v.selected = localPlayer
				end
			else
				if v.selected == localPlayer then
					v.selected = false
				else
					for k,d in pairs(planets) do
						d.selected = false
					end
					v.selected = localPlayer
				end
			end
		end
		if v.selected == localPlayer then
			love.graphics.setColor(colours.white[1], colours.white[2], colours.white[3], colours.white[4])
			love.graphics.circle('fill', v.x, v.y, v.radius+6, 150)
		end	


		if v.owner then
			love.graphics.setColorMode("modulate")
			love.graphics.setColor( players[v.owner].colour[1], players[v.owner].colour[2], players[v.owner].colour[3], players[v.owner].colour[4] ) 
		end	
		planetImg = images.planets[v.imgIndex]
		
		--This scales the planets to the correct size
		scale = getScale(planetImg, {width = v.radius*2, height = v.radius*2})
		
		
		love.graphics.draw(planetImg, v.x, v.y, v.rotation, scale.x, scale.y, planetImg:getWidth()/2, planetImg:getHeight()/2)
		love.graphics.circle('line', v.x, v.y, v.radius, 100)

		advPrint(game.sanitizeShipCount(v.shipCount), v.x-(fonts.shipCount:getWidth(game.sanitizeShipCount(v.shipCount))-(v.radius/3)), v.y-(fonts.shipCount:getHeight()), colours.white, fonts.shipCount  )
		love.graphics.setColorMode("replace")
		love.graphics.setColor(r,g,b,a)
	end

end








game.deselectAll = function()
	for ind,val in pairs(planets) do
		val.selected = false
	end
end

game.createPlanet = function(small, big)
	image = math.random(1,#images.planets)
	radius = math.random(small, big)
	x = math.random((radius+5), love.graphics.getWidth()-(radius+5))
	y = math.random((radius+5),  love.graphics.getHeight()-(radius+5))
	
	for i,v in pairs(planets) do
		if circleOverlap({x=x,y=y,radius=radius},v ) then
			return false
		end
	end

	return {imgIndex = image, x = x, y = y, radius = radius, growthRate = game.calculateShipGrowth(radius), selected = false, owner=false, rotation = 0, shipCount = radius,}
end

game.addPlayer = function(playerData, num)
	local playerNum
	local bool = false
	
	if num then playerNum = num else playerNum = #players+1 end
	playerData.playerNum = playerNum
	players[playerNum] = playerData
	players[playerNum].playerPriority = {}
	while not bool do
		bool = game.createPlanet(22,22)
	end
	bool.owner = playerNum
	bool.shipCount = game.startShipCount
	table.insert(planets,bool)
	
end

game.removePlayer = function(playerNum)
	players[playerNum] = nil
	tempTable = {}
	for k,v in pairs(players) do
		tempTable[#tempTable] = v
	end
	players = tempTable
	tempTable = nil
end

game.assignPlanet = function(planetNumber, playerNumber)
	planets[planetNumber].owner = playerNumber
end

game.getPlayerStats = function(playerNum)
	stats = {}
	if players[playerNum] then
		player = players[playerNum]
		stats.shipCount = player.shipCount
		tempCount = 0
		for i,v in pairs(planets) do
			if v.owner == playerNum then
				tempCount = tempCount +1
			end
		end
		stats.planetCount = tempCount
		
		return stats
	else
		return false
	end
end

game.calculateShipGrowth = function(radius)
	local fullSpeed = (35)
	local rate = (radius / fullSpeed)

	return ( rate ) 
end

game.sanitizeShipCount = function(num)	return math.floor(math.round(num))	end

game.returnMouseOver = function()
	for k,v in pairs(planets) do
		c1 = {}
		c1.x = mouse.X
		c1.y = mouse.Y
		c1.radius = 1
		c2 = v
		if c2.x and c2.y and circleOverlap(c1, c2) then
			return k
		end
		
	end
	return false
end

game.returnSelected = function(playerNum)
	local tempArray = {}

	for k,v in pairs(planets) do
		if v.selected == playerNum and v.owner == playerNum then
			table.insert(tempArray,{planetNum = k})
		end
	end

	if #tempArray > 0 then return tempArray else return false end
end

game.returnAllPlanets = function(playerNum)
	local tempArray = {}
	for k,v in pairs(planets) do
		if v.owner == playerNum then
			table.insert(tempArray,{planetNum = k})
		end
	end

	if #tempArray > 0 then return tempArray else return false end
end

game.getShipCount = function(playerNum)
	local tempCount = 0
	for k,v in pairs(planets) do
		if v.owner == playerNum then
			tempCount = tempCount + game.sanitizeShipCount(game.sanitizeShipCount(v.shipCount))
		end
	end

	for i,v in pairs(ships) do
		if v.owner == playerNum then
			tempCount = tempCount + 1
		end
	end
	
	return game.sanitizeShipCount(tempCount)
end

game.sendShips = function( planetNum, playerNum, skipSync, planetList, percentage )
	if not percentage then percentage = players[playerNum].sendAmount end
	local returnSelected
		if planetList then returnSelected = planetList  else returnSelected = game.returnSelected(playerNum) end
	local fromCirc = {}
	local toCirc = {}
	local deg = 25
	local maxShips = 25
	local distance
	local run
	local rise 
	local x 
	local y 
	local tempCount
	local index
	local beingSent
						
						
		if type(returnSelected) == "table" and planetNum and playerNum and returnSelected then
			for i,d in pairs(returnSelected) do
				index = d.planetNum
				d = planets[d.planetNum]

				tempCount = game.sanitizeShipCount(((percentage*0.01)*d.shipCount))
				if tempCount < maxShips then maxShips = tempCount else maxShips = maxShips end
				
				for i = 1, maxShips do	
				if index == planetNum then break end
					if tempCount > 0 then
						fromCirc = getcircleCoordinate(d.x, d.y, d.radius, math.random(-360,360))
						toCirc = getcircleCoordinate(planets[planetNum].x, planets[planetNum].y, planets[planetNum].radius/1.5, math.random(-360,360))
						
						distance = math.sqrt((planets[planetNum].x - d.x)^2 + (planets[planetNum].y - d.y)^2)
						run = ((toCirc.x - fromCirc.x))/distance
						rise = ((toCirc.y - fromCirc.y))/distance
						beingSent = tempCount/maxShips

						d.shipCount = d.shipCount - beingSent
						
						deg = math.rad(math.angle(toCirc.x, toCirc.y, fromCirc.x, fromCirc.y))
						table.insert(ships,{owner = d.owner, to = planetNum, from = index, shipCount=beingSent, angle = deg, rise = rise, run = run, x = fromCirc.x, y = fromCirc.y})
					end

				end
			end
			
			if not skipSync and tempCount > 0 then
				local temp = {}
				temp.planetNum = planetNum
				temp.playerNum = playerNum
				temp.returnSelected = returnSelected
				temp.sendAmount = players[playerNum].sendAmount
				--syncShips( temp )
			end
			
	end
end

game.getAvailableID = function()
	for i,v in pairs(players) do 
		if v.AI then  return i end
	end
end




























	