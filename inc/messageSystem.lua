message = {}
messages = {}
message.ms = 0
message.run = function()
	message.show()
	message.prune()

end

message.show = function()
	for i,v in pairs(messages) do
		advPrint(v.text, 10, 550+(19*i))
	end
end

message.prune = function()
	for i,v in pairs(messages) do
		if os.time() > v.timer then messages[i] = nil end
	end
end

message.add = function(author,text,time, send)
	table.insert(messages,{text=text, author = author,time= time,timer = os.time()+time,})
	if send then
		local object
		if server.obj then object = server.obj elseif client.obj then object = client.obj end
		object:send(table.compressSave({dataType='message', value = {author = author, text = text}}))
	end
end