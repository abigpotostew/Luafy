franklinBook = of.Font()

----------------------------------------------------
function setup()
	-- this load font loads the non-full character set
	-- (ie ASCII 33-128), at size "32"
	franklinBook:loadFont("fonts/frabk.ttf", 32)

end

----------------------------------------------------
function draw()
of.background(255, 255, 255)
	of.setHexColor(0x00FF00)
	franklinBook:drawString("Drag Lua Script Here!!", 100, 100)

end
