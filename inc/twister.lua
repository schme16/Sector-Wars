-- Create a length 624 array to store the state of the generator
-- Downside here is that I'm having the bit library turn things to and from bits left and right when they are plenty of times it would be easier to keep it in bit state. Too lazy...
local twisterarray = {}
for i=0, 623 do
twisterarray[i] = 0
end

local index = 0
 
--since we don't do trailing 0's here
--gets the last numofbits amount of bits in a number
local function lastbits(number, numofbits, keepinbitform)

--Mersenne twister
--Ported to pure lua by Lap
local temptbl = bit.tobits(number)
local newtbl = {}
local maxits = #temptbl
local precedingzeros = 0

	if numofbits > maxits then 
	precedingzeros = numofbits - maxits
	numofbits = maxits
	end

	for x = maxits - numofbits + 1,maxits do
		table.insert(newtbl,temptbl[x])
	end

	
	if keepinbitform == nil then
	return bit.tonumb(newtbl)
	else
		for i = 1, precedingzeros do
		table.insert(newtbl,1, 0)
		end
	return newtbl
	end
end
 
-- Initialize the generator from a seed
 function initializeGenerator(seed)
     twisterarray[0] = seed
     for i = 1, 623 do-- loop over each other element
	 twisterarray[i] = lastbits((1812433253 * (bit.bxor(twisterarray[i-1],bit.brshift(twisterarray[i-1],30)) + i)),32)
         --twisterarray[i] = last 32 bits of(1812433253 * (twisterarray[i-1] xor (right shift by 30 bits(twisterarray[i-1]))) + i) -- 0x6c078965
	end
 end
 -- Extract a tempered pseudorandom number based on the index-th value,
 -- calling generateNumbers() every 624 numbers
 local function extractNumber()
     if index == 0 then
     generateNumbers()
     end
	 
     local y = twisterarray[index]
	 y = bit.bxor(y, bit.brshift(y,11))
     --y = y xor (right shift by 11 bits(y))
	 y = bit.bxor(y, (bit.band(bit.blshift(y,7),2636928640)))
     --y = y xor (left shift by 7 bits(y) and (2636928640)) -- 0x9d2c5680
	 y = bit.bxor(y, (bit.band(bit.blshift(y,15),4022730752)))
     --y = y xor (left shift by 15 bits(y) and (4022730752)) -- 0xefc60000
	 y = bit.bxor(y, bit.brshift(y,18))
     --y = y xor (right shift by 18 bits(y))
     
     index = (index - 1)%624
     return y
 end

 -- Generate an array of 624 untempered numbers
local function generateNumbers()
    for i = 0, 623 do
	local bittbl = bit.tobits(twisterarray[i])
	local mergetbl = lastbits(twisterarray[(i+1)%624],31,true)
	table.insert(mergetbl,1,bittbl[#bittbl])
	local y = bit.tonumb(mergetbl)
		--local y = bittbl[table.Count(bittbl)] + lastbits(twisterarray[(i+1)%624],31)
        --y = 32nd bit of(twisterarray[i]) + last 31 bits of(twisterarray[(i+1) mod 624]
         twisterarray[i] = bit.bxor(twisterarray[(i + 397)%624],bit.brshift(y,1))
        if (y % 2) ~= 0 then -- y is odd 
        twisterarray[i] = bit.bxor(twisterarray[i],2567483615) -- 0x9908b0df
		end
	end
end

function twisterPercent()
return extractNumber() / 4294967296
end

function twisterNumber(x,y)

local minnum = 1
local maxnum
local range
	if y == nil then
	maxnum = x
	range = maxnum - 1
	else
	minnum = x
	maxnum = y
	range = maxnum - minnum
	end

return math.floor(range * randomPercent() + 0.5)
end