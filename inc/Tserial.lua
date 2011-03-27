-- Taehl's serializer v1

-- Usage: loadstring("tablename="..TSerialize(table))
function table.tSave(t)
	assert(type(t) == "table", "Can only TSerialize tables.")
	if not t then return nil end
	local s = "{"
	for k, v in pairs(t) do
		if type(k) == "string" then k = k
		elseif type(k) == "number" then k = "["..k.."]"
		else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
		end
		if type(v) == "string" then v = "\""..v.."\""			
		elseif type(v) == "table" then v = table.tSave(v)
		elseif type(v) == "boolean" then v = v and "true" or "false"
		elseif type(v) == "userdata" then v = ("%q"):format(tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end

function table.tLoad(t)
	if t then
		local f, err = loadstring("return "..t)
		local success, ret = pcall(f) -- call the string without erroring
		
		if success then	
			return ret
		else
			return false
		end
	end
	
end