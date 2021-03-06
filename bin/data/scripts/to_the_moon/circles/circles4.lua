local tween = require('tween')
time, timer = 0,0
bSmooth = false
lines = false

local hw_ratio = 1
local width, height = 0, 0
local h_width, h_height = 0, 0

local mouse = {x=0,y=0}

TWO_PI = math.pi * 2
HALF_PI = math.pi/2
SIXTH_PI = math.pi/6 --30 deg
THRD_PI = math.pi/3 --60 deg

local function binomial()
	return math.random()-math.random()
end

local lines = {}

local Line = {}
Line.new = function(position, angle, radius, color,speed)
	return { position = position or math.random()*TWO_PI, 
			 angle = angle or math.random(TWO_PI/2), --ANGLE on circle
			 radius = radius or math.random(), --[0..1]
			 color = color or math.random(4294967296), --32bit color
			 speed = speed or binomial()/TWO_PI, --angle velocity
		   }
end


local function map(value, in_from, in_to, out_from, out_to)
    return out_from+((value - in_from)/(in_to - in_from))*(out_to - out_from)
end



----------------------------------------------------
function setup()
	
	width = 900
	height = 900
	of.setWindowShape(width, height)
	
	h_width = width/2
	h_height = height/2
	hw_ratio = height / width
	

	of.setCircleResolution(50)
	math.randomseed(os.time())
	of.setWindowTitle("circles1")
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	of.setPolyMode(of.POLY.WINDING_NONZERO)
	of.noFill()
	
	local fboSettings = of.Fbo.Settings()
	fboSettings.width = width
	fboSettings.height = height
	fboSettings.internalFormat =of.Fbo.INTERNAL_FORMAT.GL_RGBA16
	
	fbo = of.Fbo()
	fbo:allocate(fboSettings)
	if not fbo:isAllocated() then 
		print("fbo not allocated!!")
	end
	
	of.setLineWidth(5)
	
	--of.enableSmoothing()
	of.setBackgroundAuto(false)
	--of.background(0,0,0,10)
	
	--of.enableBlendMode(1)
	of.enableAlphaBlending()
	--of.disableBlendMode();
	

	fbo:beginFbo();
	of.clear(0,0,0,255);
	fbo:endFbo();
	
	arc = of.Path()
	arc:setCircleResolution(48)
	arc:arc(h_width,h_height, 100, 100, 0, 180)
	arc:setFilled(false)
end

----------------------------------------------------
function update()
	dt = of.getElapsedTimef() - time
	time = of.getElapsedTimef() --seconds
	timer = timer + dt
	
	-- if(time%5 == 0)then
-- 		table.insert(lines, Line.new())
-- 	end
end



--k required sin
--s optional scale
--o optional base offset
--example: norm_sin(k, 90, 10) returns value from [10..100]
local function norm_sin(k,s,o)
	return ((math.sin(k)+1)/2)*(s or 1) + (o or 0)
end
local function norm_cos(k,s,o)
	return ((math.cos(k)+1)/2)*(s or 1) + (o or 0)
end

----------------------------------------------------
function draw()
	
	of.clear(0,0,0)
	of.pushMatrix()
	of.translate(h_width,h_height)
	local R = width
	for i,line in ipairs(lines)do
		of.setHexColor(line.color)
		local r = line.radius * R
		line.position = line.position+line.speed*dt*2--update
		local p = line.position
		local res = 0.04 * r * line.angle 
		local step = (line.angle)/res --max speed 15, min speed 5
		local prevx, prevy = math.cos(p)*r, math.sin(p)*r
		local x, y = 0, 0
		for j=1,res do
			p = step + p
			x, y = math.cos(p)*r, math.sin(p)*r
			of.line(x, y, prevx, prevy)
			prevx, prevy = x, y
		end
	end
	of.popMatrix()
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
	if key == string.byte('l') then
		lines = not lines
	end
end

function mouseMoved(x, y)
	mouse.x = x
	mouse.y = y
end

function mousePressed(x,y)
	table.insert(lines, Line.new())
end

