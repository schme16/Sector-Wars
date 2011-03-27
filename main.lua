require 'inc/tablePersistence.lua'
require 'inc/supportFunctions.lua'
require 'inc/timer.lua'
require 'inc/input.lua'
require 'inc/vector.lua'
require 'inc/camera.lua'
require 'inc/TEsound.lua'
require 'inc/LUBE.lua'
require 'inc/networking.lua'
require 'inc/messageSystem.lua'
require 'inc/debug.lua'
require 'inc/game.lua'
require 'inc/gui.lua'
require 'inc/fadeLib.lua'
require 'inc/TLibCompress.lua'
require 'inc/Tserial.lua'
require 'inc/AI.lua'

--Globals

	system = {
		debug = false,
		version = 'rev15',
	}


function love.load()

	love.graphics.setColorMode("replace")
	love.graphics.setColor(0,0,0, 255)
	love.graphics.setBackgroundColor( game.bgColour[1], game.bgColour[2], game.bgColour[3], game.bgColour[4] )



--Now lets init the file system stuff
	if (love.filesystem.exists("HighScores.sav")) then
		fileData = love.filesystem.read( "HighScores.sav" )
		highscores = table.load(fileData)
	else
		local t = {}
		
		love.filesystem.write("HighScores.sav", table.save(t))
	end

end

	function love.keypressed(key)
		keyboard.newPress[key] = true
	end
		
	function love.mousepressed(x,y,key)
	if key == 'wd' then key = 'wheelDown' end
	if key == 'wu' then key = 'wheelUp' end
		mouse.newPress[key] = true
	end

	function love.keyreleased(key)
		keyboard.newPress[key] = false
	end
		
	function love.mousereleased(x,y,key)
		mouse.newPress[key] = false
	end	
	

function love.update(dt)
	if server.obj then server.update(dt) end
	if client.obj then client.update(dt) end

	game.dt = dt
		
	local ms = (1000 / 60) - (dt * 1000)
    if ms > 0 then
		love.timer.sleep(ms)
	end 
	
end
--addUpdate('!!!!!!!mainUpdate!!!!!!!!',love.update)








addDraw('inputUpdate',input.update)









