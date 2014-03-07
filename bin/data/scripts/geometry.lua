time = 0
bSmooth = false

--fbo = of.Fbo()
--shader = of.Shader()

local length = 0
local sides = 6
local innerCircles = 10
local radius
local minR
local rstep

local mouse = {x=0,y=0}

TWO_PI = math.pi * 2

----------------------------------------------------
function setup()

	of.setCircleResolution(50)
	--of.background(255, 255, 255, 255)
	of.setWindowTitle("geometry")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	
	-- local fboSettings = of.Fbo.Settings()
-- 	fboSettings.width = of.getWidth()
-- 	fboSettings.height = of.getHeight()
-- 	--fboSettings.colorFormats = of --??
-- 	fbo:allocate(fboSettings)
-- 	if not fbo:isAllocated() then 
-- 		print("not allocated!!")
-- 	else
-- 		print("YEA!")
-- 	end
	length = math.min(of.getWidth(), of.getHeight())
	radius = length/2
	minR = radius*0.5
	rstep = minR / innerCircles
end


----------------------------------------------------
function update()
	time = time + 0.033
end

----------------------------------------------------
function draw()
--fbo:beginCapture()
	of.clear(0,255,255,255)
	of.noFill()
	
	of.pushMatrix()
	of.translate(of.getWidth()/2, of.getHeight()/2)
	local a = 0
	local a_step = 1/sides*TWO_PI
	for i=1, sides do
		of.pushMatrix()
		of.translate(math.cos(a)*radius, math.sin(a)*radius)
		local r = radius
		for j=1, innerCircles do
			of.setColor(255*(j/innerCircles*0.5+0.5),165,1.0)
			--of.setColor(0,0,0,1)
			of.circle(0,0,r)
			r = r - rstep
		end
		of.popMatrix()
		a = a + a_step
	end
	of.popMatrix()
	
	
	
-- fbo:endCapture()
-- of.setColor(255,0,0,255)
-- fbo:draw(0,0, of.getWidth()/2, of.getHeight()/2)
-- of.setColor(0,255,0,255)
-- fbo:draw(of.getWidth()/2,0, of.getWidth()/2, of.getHeight()/2)
-- of.setColor(0,0,255,255)
-- fbo:draw(0,of.getHeight()/2, of.getWidth()/2, of.getHeight()/2)
-- of.setColor(255,255,255,255)
-- fbo:draw(of.getWidth()/2, of.getHeight()/2, of.getWidth()/2, of.getHeight()/2)

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

function mouseMoved(x, y)
	mouse.x = x
	mouse.y = y
end

