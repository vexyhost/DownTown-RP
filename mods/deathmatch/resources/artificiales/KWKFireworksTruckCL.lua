---------------------
-- Fireworks Truck -- -- Makes a truck that launches Fireworks :D
--------- by --------
------- KWKSND ------ -- Makes Multi Theft Auto more fun :D
---------------------

-- settings --
	number = 150 -- number of fireworks to launch (default = 150)
	height = 1.8 -- this is the velocity of the shell when launched (default = 1.8)
	randomness = 0.30 -- how far off vertical the fireworks can launch (default = 0.30)
	maxsize = 25 -- (default = 25) acual size of marker would be maxsize * 5 
-- settings ^^

resetdelay = number * 200
inuse = 0
function CreateFireworks(vehicle)
	if inuse == 0 then
		inuse = 1
		setTimer (function()
			delay = math.random(350,750)
			setTimer (function()
				local fx,fy,fz = getElementPosition(vehicle)
				fz = fz
				local shell = createVehicle (594,fx,fy,fz)
				if isElement(shell) then
					setElementAlpha(shell,0)
					local flair = createMarker (fx,fy,fz,"corona",1,255, 255, 255, 255)
					attachElements(flair,shell)
					local smoke = createObject(2780,0,0,0)
					setElementCollidableWith (smoke,shell,false)
					setElementAlpha(smoke,0)
					attachElements (smoke,shell)
					setElementVelocity (shell, math.random(-2,2)*randomness, math.random(-2,2)*randomness,height)
					setTimer (function(shell,flair,smoke)
						local ex,ey,ez = getElementPosition(shell)
						createExplosion(ex,ey,ez,11)
						setMarkerColor(flair,math.random(0,255),math.random(0,255),math.random(0,255),155)
						sizetime=math.random(7,maxsize)
						setTimer (function(shell,flair,smoke)
							if isElement(flair)then
								local size = getMarkerSize(flair)
								setMarkerSize(flair,size+5)
							end
							setTimer (function(shell,flair,smoke)
								if isElement(flair)then
									destroyElement(flair)
								end
								if isElement(shell) then
									destroyElement(shell)
								end
								if isElement(smoke) then
									destroyElement(smoke)
								end
							end,sizetime*100,1,shell,flair,smoke)
						end,100,sizetime,shell,flair,smoke)
					end,1400,1,shell,flair,smoke)
				end
			end,delay,1,vehicle)
		end,230,number,vehicle)
		setTimer (function()
			inuse = 0
		end,resetdelay,1)
	end
end
addEvent("ClientCreateFireworks",true)
addEventHandler( "ClientCreateFireworks", getRootElement (), CreateFireworks)
