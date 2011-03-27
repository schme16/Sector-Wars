aiFunctions = {}


function aiFunctions:init()
	for i,v in ipairs(players) do
		timerFunctions:add('AI', math.random(3,10), function() aiFunctions:update(i) end,true)	
	end
end

function aiFunctions:pause()
	timerFunctions:pause('AI')
end

function aiFunctions:unpause()
	timerFunctions:unpause('AI')
end

function aiFunctions:remove()
	timerFunctions:remove('AI')
end

function aiFunctions:update(AI)
	local priorityTable	
	local enemy	
	local enemyPlanets 	
	local AIPlanets		
	local priority = false	
	
	if AI and players[AI].AI then
		AIPlanets = game.returnAllPlanets(AI)
		if AIPlanets then
			for k,d in ipairs(AIPlanets) do
				for c,m in ipairs(players) do
					enemyPlanets = game.returnAllPlanets(m.playerNum)
					if not(m.playerNum == AI) and enemyPlanets then
					
						enemy = players[m.playerNum]
						priorityTable = aiFunctions:getPlanetPriority(d.planetNum,AI)
						if priorityTable then
							priority = priorityTable.priority
							priorityPlanetNum = priorityTable.planetNum
							percentage = aiFunctions:shipSendPercentage(d.planetNum, priorityPlanetNum)
						end
					end
				end
				if priority and priorityPlanetNum and percentage then
					game.sendShips(priorityPlanetNum , AI, false, {planetNum = d})
					priority = false
				end						
			end	

		end
	end
end
	
function aiFunctions:getPlanetPriority(planetFrom, exclude)
	
	--localize the priority table
	local priorityTable = {}
	
	--localize the `planet` index lookup table	
	local planetNumber = {}
	
	--localize the current players priority index
	local playerPriority
	
	--localize the priority placeholder, this is used as a temp variable for the loop bellow	
	local priority 
	
		--step through all the planets
		for i,v in ipairs(planets) do 
			
			--only step through planets NOT owned by the AI calling this function.
			--Current AI index is in variable `exclude`
			if not( v.owner == exclude ) then
			
			
				--check each players relative priority index
				if players[exclude].playerPriority[v.owner] then 
					playerPriority = players[exclude].playerPriority[v.owner] 
				else 
					playerPriority = 0 
				end 
				
				 --Distance + current occupied foreces + Player Priority index
				priority = ((game.getDistance(planetFrom, i) + v.shipCount) + playerPriority)
				
				table.insert(priorityTable, priority) --insert into a table for later sorting
				
				planetNumber[priority] = i --update the planet index lookup tabe
			end
			priority = 0 --reset priority
		end
		
		--sort the table
		table.sort(priorityTable) 
		
		--get a random number between 1 and 5
		local random = math.random(1,5) 
		
		--send back a planet index randomly from the top 5 priority planets		
		return {planetNum = planetNumber[priorityTable[random]], priority = priorityTable[random]} 
end
	
function aiFunctions:getSpecificPlanetPriority(planetNum) --This need a complete rewrite, as it is not returning relevanty 
	local priorityTable
	local planetLookupTable
	local temp
	for k,d in ipairs(planets) do

		temp = aiFunctions:calculatePiority(game.getDistance(planetFrom, i), v.shipCount,playerPriority)
		
		--insert into a table for later sorting
		table.insert(priorityTable, temp) 
		
		--update the planet index lookup tabe
		planetLookupTable[temp] = k
	end
	
	table.sort(priorityTable)
	
	return priorityTable[1]
end

function aiFunctions:calculatePiority(distance, shipCount, priorityOffset)
	return distance + shipCount + priorityOffset
end

function game.getDistance(planetFrom, planetTo)
	planetX = planets[planetFrom]
	planetY = planets[planetTo]
	return math.sqrt((planetX.x - planetY.x)^2 + (planetX.y - planetY.y)^2)	
end

function aiFunctions:shipSendPercentage(planetFrom, planetTo)
	--local avgPriority = aiFunctions:getSpecificPlanetPriority(planetFrom)
	local planetFrom = planets[planetFrom]
	local planetTo = planets[planetTo]
	if planetFrom and planetTo then
		local percentage = ((100/((planetFrom.shipCount/planetTo.shipCount)/game.getTotalPlanetsOwned(planetFrom.owner)))+5)
		if percentage > 100 then percentage = 100 end
		return percentage
	end

end
	
function game.getTotalPlanetsOwned(playerNum)
	local total = 0
	for i,v in ipairs(planets) do
		if v.owner == playerNum then
			total = total + 1
		end
	end
	if total then return total else return 1 end
end
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	