function love.conf(t)
	t.title = "Planet Conquest"
	t.author = "Shane Gadsby"
	t.email = "schme16@gmail.com"
	t.console = false
	t.modules.joystick = false   -- Enable the joystick module (boolean)
	t.modules.physics = false    -- Enable the physics module (boolean)
	t.screen.vsync = false       -- Enable vertical sync (boolean)
	t.screen.fsaa = 2           -- The number of FSAA-buffers (number)
	t.screen.height = 768       -- The window height (number)
	t.screen.width = 1024       -- The window height (number)
end