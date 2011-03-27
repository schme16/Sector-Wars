

						--[[ 	 Support functions      ]]--

function keyAprooved(key, okay)
	for k,v in pairs(okay) do
		if v == key then
			return true
		end
	end
	return false
end

function advPrint(str, x, y, colour, font)
	local colourMode
	local r, g, b, a
	if font then
		love.graphics.setFont(font)
	end

	if colour then
		r, g, b, a = love.graphics.getColor( ) 
		colourMode = love.graphics.getColorMode( )
		love.graphics.setColorMode("modulate")
		love.graphics.setColor( colour[1], colour[2], colour[3] ,colour[4])
	end
	love.graphics.printf( str, x, y, love.graphics.getWidth(), 'left' )
	love.graphics.print(str, x, y)

	if colour then
		love.graphics.setColorMode(colourMode)
		love.graphics.setColor(r, g, b, a)
	end
	
	if font then
		love.graphics.setFont(fonts.default)
	end	
end

function getnEx (t)
  local max = 0
  for i,k in ipairs(t) do
    if type(i) == "number" and i>max then max=i end
  end
  return max
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy(getmetatable(object)))
    end
    return _copy(object)
end

function getDist(a,b)
	return a - b
end

function getBiggest(a,b)
	if(a>b) then
		return {big = a, small = b}
	else
		return {big = b, small = a}
	end
end

function rectOverlap(rect1, rect2)

Collide = false 
	if (rect2.y >= rect1.y and rect1.y + rect1.height >= rect2.y) or (rect2.y + rect2.height >= rect1.y and rect1.y + rect1.height >= rect2.y + rect2.height) or (rect1.y >= rect2.y and rect2.y + rect2.height >= rect1.y) or (rect1.y + rect1.height >= rect2.y and rect2.y + rect2.height >= rect1.y + rect1.height) then
		 if rect2.x >= rect1.x and rect1.x + rect1.width >= rect2.x then					 -- corner 1
			 Collide = true
			 end
		 if rect2.x + rect2.width >= rect1.x and rect1.x + rect1.width >= rect2.x + rect2.width then	 -- corner 2
			 Collide = true
			 end
		 if rect1.x >= rect2.x and rect2.x + rect2.width >= rect1.x then					 -- corner 3
			 Collide = true  
			 end
		 if rect1.x + rect1.width >= rect2.x and rect2.x + rect2.width >= rect1.x + rect1.width then	 -- corner 4
			 Collide = true
			 end	 
	end
	return Collide -- return whether or not collision is detected 
end

function circleOverlap(c1, c2)

	local distance = math.sqrt( math.pow(c1.x - c2.x, 2) + math.pow(c1.y - c2.y, 2) )
	local collide = false
	local num = getBiggest(c1.radius, c2.radius)
	if distance < num.big+num.small then
		collide = true
	end

	return collide
end

function getScale(img, max)
	tempScale = 100/img:getWidth()
	tempScale2 = 100/(max.width)
	width = (tempScale/tempScale2)
	
	tempScale = 100/img:getHeight()
	tempScale2 = 100/(max.height)
	height = (tempScale/tempScale2)	
	
	return  {x = width, y= height}
end

function math.round(num, idp)
	return math.abs(tonumber(string.format("%." .. (idp or 0) .. "f", num)))
end

function getPercentage(a,b)
	val = getBiggest(a,b)
	return (val.small/val.big)*100
end

function getcircleCoordinate(OriginX, OriginY, radius, degree, bool)
	if bool then
		return (OriginX + math.cos(degree) * radius), (OriginY + math.sin(degree)*radius)
	end
	
	return {x = (OriginX + math.cos(degree) * radius), y = (OriginY + math.sin(degree)*radius)}
end

function makeTransparent(x, y, r, g, b, a)
	if r == 255 and g == 0 and b == 255 then
		a = 0
	end
	return r,g,b,a
end

function makeSprite(str)
	local temp = love.image.newImageData(str)
	temp:mapPixel(makeTransparent)
	return love.graphics.newImage(temp)
end

function deltaSpeed(speed)
	return (speed * love.timer.getDelta())
end

function math.angle(x1, y1, x2, y2)
    return math.deg(math.atan2(y2-y1, x2-x1))%360
end

--seeds and initializes the math.random func
function randSeedInit()
	math.randomseed(os.time()*math.random(45763))
	math.random()
	math.random()
	math.random()
end

 randSeedInit()










--This allows users to concat the update call.     [[PLEASE NOTE THAT THIS IS STILL IN ITS INFANCY]]
updatesTable = {}
function addUpdate(tag,newFunc)
	--function love.update(dt)
		--for i,v in ipairs(updatesTable) do
		--	v.func(love.timer.getDelta( ))
		--end	
	--end

	--table.insert(updatesTable,{func = newFunc, tag = tag})	
end







--This allows users to concat the draw call.     [[PLEASE NOTE THAT THIS IS STILL IN ITS INFANCY]]
		
drawTable ={}
function addDraw(tag, newFunc)
	function love.draw()
		for i,v in ipairs(drawTable) do
			if v.running then 
				v.func()
			end
		end	
	end
	table.insert(drawTable,{func = newFunc, tag = tag, running = true})
end

function removeDraw(tag)
	for i,v in ipairs(drawTable) do
		if v.tag == tag then table.remove(i) end
	end	
end

function pauseDraw(tag)
	for i,v in ipairs(drawTable) do
		if v.tag == tag then v.running = false end
	end	
end


function unpauseDraw(tag)
	for i,v in ipairs(drawTable) do
		if v.tag == tag then v.running = true end
	end	
end










local buttons = {}
buttons.__index = buttons

function newTextButton(str, x, y, colour, font )
	return setmetatable({str = str, x=x, y=y, colour=colour, font=font}, buttons)	
end

function buttons:Draw(hitTest)
local hit = false
	if(hitTest) then
		
		rect1 = {}
		rect2 = {}
		rect1.x = self.x
		rect1.y = self.y + self.font:getHeight()/2
		rect1.width = self.font:getWidth(self.str)
		rect1.height = self.font:getHeight()
		
		
		
		rect2.x = mouse.X
		rect2.y = mouse.Y
		rect2.width = 1
		rect2.height = 1
		
		if rectOverlap(rect1, rect2) then
			hit = true
			debugVal = hit
		end
	end
	advPrint(self.str, self.x, self.y, self.colour, self.font)	
	return hit
end






