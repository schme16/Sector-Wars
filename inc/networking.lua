
------------------------------Server FUNCTIONS--------------------------------

server = {}
clientSlot = {}
local port = 9090
server.load = function()
	server.obj = lube.server(1)
	server.obj:Init(port)
	server.obj:setPing(true, 5, "ping")
	server.obj:setHandshake("Hi")
	server.obj:setCallback(server.rcvCallback, server.objectconnCallback, server.disconnCallback)
	message.add('SERVER', 'Game has started!', 4, true)
end

server.objectconnCallback = function(ip,port)
	local newPlayerID = game.getAvailableID()
	clientSlot[ip] = newPlayerID
	players[newPlayerID].AI = false
	server.obj:send(table.compressSave({dataType='ID', value = clientSlot[ip],}), ip)
	message.add('SERVER', 'A new player is joining...', 4, true)
	
end

server.rcvCallback = function(rawData, ip, port)
	data = table.compressLoad(rawData)

	if data then
		if data.dataType == 'getMap' then
			server.obj:send(table.compressSave({dataType='planets', value = planets,}), ip)
		end
		
		if data.dataType == 'getPlayers' then
			server.obj:send(table.compressSave({dataType='players', value = players,}), ip)
		end
		
		if data.dataType == 'getShips' then
			server.obj:send(table.compressSave({dataType='ships', value = ships,}), ip)
		end
		
		if data.dataType == 'shipData' then
			shipProcessor(data.value)
		end
	end
end

server.disconnCallback = function(ip, port)
	players[clientSlot[ip]].AI = true
	message.add('SERVER', 'Player '..clientSlot[ip]..' has Left!', 4, true)
	clientSlot[ip] = nil
end

server.update = function()
	local dt = love.timer.getDelta()
	server.obj:update(dt)
	server.obj:checkPing(dt)
end
















------------------------------[Client Functions]--------------------------------


client = {}

function client.load(hostname)
	client.obj = lube.client(1)
	client.obj:Init(port)
	client.obj:setPing(true, 5, "ping")
	client.obj:setHandshake("Hi")
	if client.obj:connect(hostname, port, true) == nil then
	else 
		client.load(hostname)
	end
	client.obj:setCallback(rcvCallback)
end

rcvCallback = function(rawData)
	data = table.compressLoad(rawData)
	if data then
		print(data.dataType)
		if data.dataType == 'players' then
			players = deepcopy(data.value)
		end

		if data.dataType == 'planets' then
			planets = data.value
		end
		
		if data.dataType == 'ships' then
			ships = data.value
		end	
		
		if data.dataType == 'shipData' then
			shipProcessor(data.value)
		end		
		
		if data.dataType == 'ID' then
			client.connected = true
			localPlayer = data.value
		end
		
		if data.dataType == 'message' then message.add(data.value.author, data.value.text, 4) end
	end
	
end

client.update = function(dt)
local dt = love.timer.getDelta()
	client.obj:doPing(dt)
	client.obj:update(dt)
end








------------------------------http FUNCTIONS--------------------------------

httpFuncs ={}

httpFuncs.fetchServers = function(url)
	if not gOveride then
		local filename = 'servers.lua'
		local url = string.format('http://%s/', game.server)
		httpFuncs.download(url, filename, true)	
	end
end

httpFuncs.download = function (url, filename, requireIt)
	if not gOveride then
		gOveride = true
		if love.filesystem.exists(filename) then
			love.filesystem.remove(filename)		
		end
		
		local new_file = love.filesystem.newFile( filename )	
		new_file:open('w')
		local lsink = ltn12.sink.file( new_file )
		local f, e, h = http.request{
			url = url,
			sink = lsink,
			step = httpFuncs.filePump
		}
		new_file:close() 
		if love.filesystem.exists( filename ) then
		gOveride = false
			chunk = love.filesystem.load( filename )
			chunk()
			return true
		end		
	end
end

httpFuncs.filePump = function( source, sink )
	love.run( gOveride )
	local chunk, src_err = source()
	local ret, snk_err = sink(chunk, src_err)
	return chunk and ret and not src_err and not snk_err, src_err or snk_err
end








shipProcessor = function(data)
	if type(data) == 'table' then
		local sendAmountBackup = players[data.playerNum].sendAmount
		players[data.playerNum].sendAmount = data.sendAmount
		game.sendShips(data.planetNum, data.playerNum, true, data.returnSelected)
		players[data.playerNum].sendAmount = sendAmountBackup
	end

end

function syncShips(data)
	local object
	if server.obj then object = server.obj elseif client.obj then object = client.obj end
	object:send(table.compressSave({dataType='shipData', value = data}))

end

function table.compressSave(t)
	return table.tSave(t)
end

function table.compressLoad(t)
	return table.tLoad(t)
end











