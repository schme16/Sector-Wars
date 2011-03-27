
	--[[ 	Graphical User Interface (GUI) functions     ]]--

	
	gui = {
		showMenu = true,
		menu = 'mainMenu',
		menuStage = 1,
	}

	images = {
		ship = love.graphics.newImage('img/ship.png'),
		starfield = love.graphics.newImage('img/starfield.gif'),
		artPlanet = love.graphics.newImage('img/Art_Planet.jpg'),
		planets = {
				love.graphics.newImage('img/planets/planet1.png'),
				love.graphics.newImage('img/planets/planet2.png'),
				love.graphics.newImage('img/planets/planet3.png'),
				love.graphics.newImage('img/planets/planet4.png'),
				love.graphics.newImage('img/planets/planet5.png'),
		},
}
	
	colours = {
		white = {255,255,255,255},
		black = {0,0,0,255},
		yellow = {255,255,0,255},
		green = {0,255,0,255},
		blue = {0,0,255,255},
		red = {255,0,0,255},
		menu = {200,200,200,255},
		grey = {200,200,200,255},
		HUD = {255,255,255,80},
	}
	
	fonts = {
		default = love.graphics.newFont( 'fonts/Designer-Notes.ttf', 20 ),
		shipCount = love.graphics.newFont( 'fonts/Designer-Notes.ttf', 12 ),
		hybrid = love.graphics.newFont( 'fonts/hybrid_o.ttf', 50 ),
		menu = love.graphics.newFont( 'fonts/Future Is Back.ttf', 60 ),
		general = love.graphics.newFont( 'fonts/Future Is Back.ttf', 15 ),
		HUD = love.graphics.newFont( 'fonts/Future Is Back.ttf', 100 ),
	}

	buttons = {
		newGame = newTextButton('New Game', 50, 0, colours['menu'], fonts.menu ),
		continue = newTextButton('Continue', 50, 0, colours['menu'], fonts.menu ),
		
		joinGame = newTextButton('Join Game', 50, 120, colours['menu'], fonts.menu ),
		highScores = newTextButton('High Scores', 50,240, colours['menu'], fonts.menu ),
		endGame = newTextButton('End Game', 50, 120, colours['menu'], fonts.menu ),
		exitButton = newTextButton('Exit', 10, love.graphics.getHeight()-100, colours['menu'], fonts.menu ),
	}

	
	
function gui:run()
	if gui.showMenu then
		if type(gui[gui.menu]) == "function" then
			gui[gui.menu]()
		else
			gui.close();
		end
	end

end
addDraw("This is the GUI",gui.run)


gui.close = function()
		gui.showMenu = false
		gui.menuStep = 1
end


gui.open = function()
		gui.showMenu = true
end

gui.mainMenu = function(inGame)
	love.graphics.draw(images.starfield, 0,0)
	
	if not inGame then
		if buttons.newGame:Draw(true) and mouse.newPress['l'] then
			fadeLib:fadeOut( function() game.state = 'newServer' gui.close() game:reset() fadeLib:fadeIn( function() end, 0.25) end, 0.25)		
		end
		if buttons.joinGame:Draw(true) and mouse.newPress['l'] then
			fadeLib:fadeOut( function() game.state = 'joinServer' gui.close() game:reset() fadeLib:fadeIn( function() end, 0.5) end, 0.5)		
		end
		if buttons.highScores:Draw(true) and mouse.newPress['l'] then
			fadeLib:fadeOut( function() gui.menu = 'highScores' fadeLib:fadeIn( function()  end, 0.5) end, 0.5) 
		end	
	else
		if buttons.continue:Draw(true) and mouse.newPress['l'] then
			fadeLib:fadeOut( function() game.state = 'running' gui.close() aiFunctions:unpause() fadeLib:fadeIn( function() end, 0.5) end, 0.5)		
		end
		if buttons.endGame:Draw(true) and mouse.newPress['l'] then
			fadeLib:fadeOut( function() gui.menu = 'mainMenu' game.reset() fadeLib:fadeIn( function() end, 0.5) end, 0.5)
		end	
	
	end
	

	if buttons.exitButton:Draw(true) and mouse.newPress['l'] then
		fadeLib:fadeOut( function() love.event.push('q') end, 1,true)
	end	


	local str = 'Ver: ' .. system.version
	advPrint(str, (love.graphics.getWidth()-fonts.general:getWidth(str))-5, (love.graphics.getHeight()-fonts.general:getHeight())-10, colours.white, fonts.general )
	

end 

gui.inGameMenu = function()
	gui.mainMenu(true)
end 

gui.highScores = function()

	if keyboard.newPress['escape'] then
			fadeLib:fadeOut( function() gui.menu = 'mainMenu' fadeLib:fadeIn( function()  end, 0.5) end, 0.5) 
	end 
	
	if love.filesystem.exists("HighScores.sav") then
		fileData = love.filesystem.read( "HighScores.sav" )
		highscores = table.load(fileData) 
	else
		love.filesystem.write("HighScores.sav", table.save(highscores))
	end
	
	

	love.graphics.draw(images.artPlanet, 0,0)	
	advPrint(table.save(highscores),200,200, colours.menu, fonts.hybrid)
	advPrint("ESC = Main Menu", 0, 18, colours.black)

end 

gui.HUD = function()

	if players[localPlayer] then
		advPrint(players[localPlayer].sendAmount, love.graphics.getWidth()-fonts.HUD:getWidth(players[localPlayer].sendAmount), 0, colours.HUD, fonts.HUD )
		advPrint("ESC = Main Menu", 0, 18, colours.menu)
		local selected = game.returnSelected(localPlayer)
		if selected then
			gui.planetInfo(selected)
		end
	end

end

gui.planetInfo = function(sel)

	local info = {}
	info.ships = 0
	for k,v in pairs(sel) do
		info.ships = game.sanitizeShipCount((info.ships + planets[v.planetNum].shipCount)*(players[localPlayer].sendAmount/100))
	end
	
	
	
	advPrint('Fleet Count: '.. info.ships.." ", 300, 18, colours.menu)
	
	
	


end






















