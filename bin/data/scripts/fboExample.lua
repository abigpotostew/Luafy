print("Hello World!")

time = 0
bSmooth = false

fbo = of.Fbo()
shader = of.Shader()

----------------------------------------------------
function setup()
	print("script setup")

	of.setCircleResolution(50)
	--of.background(255, 255, 255, 255)
	of.setWindowTitle("fbo")
	
	of.setFrameRate(60) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	
	local fboSettings = of.Fbo.Settings()
	fboSettings.width = of.getWidth()
	fboSettings.height = of.getHeight()
	--fboSettings.colorFormats = of --??
	fbo:allocate(fboSettings)
	if not fbo:isAllocated() then 
		print("not allocated!!")
	else
		print("YEA!")
	end
end

----------------------------------------------------
function update()
	time = time + 0.033
end

----------------------------------------------------
function draw()
fbo:beginCapture()
	of.clear(255,255,255,255)
	
	
	-- CIRCLES
	-- let's draw a circle
	of.setColor(255, 130, 0)
	local radius = 50 + 10 * math.sin(time)
	of.fill()
	of.circle(100, 400, radius)
	
	-- now just an outline
	of.noFill()
	of.setHexColor(0xCCCCCC)
	of.circle(100, 400, 80)

	-- label
	of.setHexColor(0x000000)
	of.drawBitmapString("circle", 75, 500)

	-- RECTANGLES
	of.fill()
	for i=0,200 do
		of.setColor(of.random(0, 255), of.random(0, 255),
					of.random(0, 255))
		of.rect(of.random(250, 350), of.random(350, 450),
				of.random(10, 20), of.random(10, 20))
	end
	of.setHexColor(0x000000)
	of.drawBitmapString("rectangles", 275, 500)

	-- TRANSPARENCY
	of.setHexColor(0x00FF33)
	of.rect(400, 350, 100, 100)
	-- alpha is usually turned off - for speed puposes.  let's turn it on!
	of.enableAlphaBlending()
	of.setColor(255, 0, 0, 127)   -- red, 50% transparent
	of.rect(450, 430, 100, 33)
	of.setColor(255, 0, 0, math.fmod(time*10, 255))	-- red, variable transparent
	of.rect(450, 370, 100, 33)
	of.disableAlphaBlending()

	of.setHexColor(0x000000)
	of.drawBitmapString("transparency", 410, 500)

	-- LINES
	-- a bunch of red lines, make them smooth if the flag is set

	

	of.setHexColor(0xFF0000)
	for i=0,20 do
		of.line(600, 300 + (i*5), 800, 250 + (i*10))
	end

	
fbo:endCapture()
of.setColor(255,0,0,255)
fbo:draw(0,0, of.getWidth()/2, of.getHeight()/2)
of.setColor(0,255,0,255)
fbo:draw(of.getWidth()/2,0, of.getWidth()/2, of.getHeight()/2)
of.setColor(0,0,255,255)
fbo:draw(0,of.getHeight()/2, of.getWidth()/2, of.getHeight()/2)
of.setColor(255,255,255,255)
fbo:draw(of.getWidth()/2, of.getHeight()/2, of.getWidth()/2, of.getHeight()/2)

end

----------------------------------------------------
function exit()
	print("script finished")
end

-- input callbacks

----------------------------------------------------
function keyPressed(key)
	if key == string.byte("s") then
		bSmooth = not bSmooth
		if bSmooth then of.enableSmoothing()
		else of.disableSmoothing() end
	end
end

