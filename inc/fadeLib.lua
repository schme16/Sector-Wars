fadeLib = {}

local transitions = {}

function fadeLib:fadeOut( func, time, linger)
	if not(playing) then local playing = false end
	table.insert(transitions,{fade = 'out', time = time, func=func, alpha = 0, finished = false, linger = linger,})
end	

function fadeLib:fadeIn( func, time, linger)
	table.insert(transitions,{fade = 'in',  time = time, func=func, alpha = 255, finished = false, linger = linger, })	
end	

function fadeLib:Draw(self)

	local r, g, b, a = love.graphics.getColor( ) 
	
--fade out
	if not self.finished then
		if self.fade == 'out' then
			if self.alpha < 254	 then
				self.alpha = self.alpha + 255/(self.time*love.timer.getFPS())
			else
				self.func()
				self.func = function() end
				self.finished = true
			end

			
--fade in			
		elseif self.fade == 'in' then
				if self.alpha > 0 then
					self.alpha = self.alpha - 255/(self.time*love.timer.getFPS())
				else
					self.func()
					self.func = function() end
					self.finished = true
				end

--Finished				
		elseif self.finished and not self.linger then
			self.finished = true
		end
	end	
	if not (self.finished) or self.linger then
		love.graphics.setColor(0,0,0,self.alpha)
			love.graphics.rectangle('fill', 0,0, love.graphics.getWidth(), love.graphics.getHeight())
			
		love.graphics.setColor(r, g, b, a)
	end
	return self.finished
end


function fadeLib:Update()
	for i,v in pairs(transitions) do
		if type(v)=='table' then
			if v.finished and not(v.linger) then
				table.remove(transitions,i)
				v = nil
				
			end	
			
			if v then
				fadeLib:Draw(v)
			end
		end

	end

end

addDraw('Fade Library',fadeLib.Update)