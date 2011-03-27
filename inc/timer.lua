timerFunctions = {}
local timers = {}

function timerFunctions:add(tag,time, func, loop)
	table.insert(timers, {tag = tag, time = time, func = func, timeAdded = os.time(), loop = loop, timeDif = false, running = true})
end

function timerFunctions:update()
	for i,v in pairs(timers) do
		if v.running then
			if (v.timeAdded+v.time) < os.time() then
				if type(v.func) == 'function' then v.func() end
				if v.loop then 
					v.timeAdded = os.time()
				else
					table.remove(timers, i)
				end
			end
		else
			v.timeAdded = (os.time() - v.timeDif)
		end
	end
end

function timerFunctions:pause(tag)
	for i,v in ipairs(timers) do
		if v.tag == tag then v.running = false v.timeDif = os.time() - v.timeAdded  end
	end	
end

function timerFunctions:unpause(tag)
	for i,v in ipairs(timers) do
		if v.tag == tag then v.running = true v.timeDif =false  end
	end	
end


function timerFunctions:remove(tag)
	for i,v in ipairs(timers) do
		if v.tag == tag then table.remove(timers,i) end
	end	
end


addDraw('Timers',timerFunctions.update)