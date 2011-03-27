	input = {}
	
	mouse = {
		last = {l = false, m = false, r = false, wd = false, wu = false, x1 = false, x2 = false},
		X = love.mouse.getX(),
		Y = love.mouse.getY(),
		down = {l = false, m = false, r = false, wd = false, wu = false, x1 = false, x2 = false,},
		newPress = {l = false, m = false, r = false, wd = false, wu = false, x1 = false, x2 = false,},
	}
	
	keyboard = {
		last = {escape = false,up = false, down = false, left = false, right = false, a=false,b=false,c=false,d=false,e=false,f=false,g=false,h=false,i=false,j=false,k=false,l=false,m=false,n=false,o=false,p=false,q=false,r=false,s=false,t=false,u=false,v=false,w=false,x=false,y=false,z=false,["1"]=false,["2"]=false,["3"]=false,["4"]=false,["5"]=false,["6"]=false,["7"]=false,["8"]=false,["9"]=false,["0"]=false,f1=false,f2=false,f3=false,f5=false,f6=false,f7=false,f8=false,f9=false,f10=false,f11=false,f12=false,rshift=false,lalt=false,ralt=false,lctrl=false,["rctrl"]=false,[" "]=false,["return"]=false,},
		down = {escape = false,up = false, down = false, left = false, right = false, a=false,b=false,c=false,d=false,e=false,f=false,g=false,h=false,i=false,j=false,k=false,l=false,m=false,n=false,o=false,p=false,q=false,r=false,s=false,t=false,u=false,v=false,w=false,x=false,y=false,z=false,["1"]=false,["2"]=false,["3"]=false,["4"]=false,["5"]=false,["6"]=false,["7"]=false,["8"]=false,["9"]=false,["0"]=false,f1=false,f2=false,f3=false,f5=false,f6=false,f7=false,f8=false,f9=false,f10=false,f11=false,f12=false,rshift=false,lalt=false,ralt=false,lctrl=false,["rctrl"]=false,[" "]=false,["return"]=false,}, 
		newPress = {escape = false,up = false, down = false, left = false, right = false, a=false,b=false,c=false,d=false,e=false,f=false,g=false,h=false,i=false,j=false,k=false,l=false,m=false,n=false,o=false,p=false,q=false,r=false,s=false,t=false,u=false,v=false,w=false,x=false,y=false,z=false,["1"]=false,["2"]=false,["3"]=false,["4"]=false,["5"]=false,["6"]=false,["7"]=false,["8"]=false,["9"]=false,["0"]=false,f1=false,f2=false,f3=false,f5=false,f6=false,f7=false,f8=false,f9=false,f10=false,f11=false,f12=false,rshift=false,lalt=false,ralt=false,lctrl=false,["rctrl"]=false,[" "]=false,["return"]=false,},
	}

	function input.update() 

		mouse.X = love.mouse.getX()
		mouse.Y = love.mouse.getY()
		mouse.newPress = {l = false, m = false, r = false, ["wheelDown"] = false, ["wheelUp"] = false, x1 = false, x2 = false,}
		keyboard.newPress = {escape = false,up = false, down = false, left = false, right = false, a=false,b=false,c=false,d=false,e=false,f=false,g=false,h=false,i=false,j=false,k=false,l=false,m=false,n=false,o=false,p=false,q=false,r=false,s=false,t=false,u=false,v=false,w=false,x=false,y=false,z=false,["1"]=false,["2"]=false,["3"]=false,["4"]=false,["5"]=false,["6"]=false,["7"]=false,["8"]=false,["9"]=false,["0"]=false,f1=false,f2=false,f3=false,f5=false,f6=false,f7=false,f8=false,f9=false,f10=false,f11=false,f12=false,rshift=false,lalt=false,ralt=false,lctrl=false,["rctrl"]=false,[" "]=false,["return"]=false,}
		
		
	end
	

	
	
		

		
	
	
	
	
	
	
	
	
	