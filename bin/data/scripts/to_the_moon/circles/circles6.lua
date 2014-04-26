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

local function add_line(position, angle, radius, color,speed)
	table.insert(lines, Line.new(position, angle, radius, color,speed))
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
	
	
	of.setLineWidth(5)
	
	--of.enableSmoothing()
	of.setBackgroundAuto(false)
	--of.background(0,0,0,10)
	
	--of.enableBlendMode(1)
	of.enableAlphaBlending()
	--of.disableBlendMode();
	
	local ct = 250
	for i=1, ct do
		--add_line(0, HALF_PI,width*i/20,nil,i/20*TWO_PI/40 + TWO_PI/120)
		--position, angle,  radius,    color,speed
		add_line(0, HALF_PI, i/ct, (i%2==0)and 0xFF0000 or 0xFFFFFF, i/ct*TWO_PI + TWO_PI/30)
	end
end

----------------------------------------------------
function update()
	dt = of.getElapsedTimef() - time
	time = of.getElapsedTimef() --seconds
	timer = timer + dt
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
	local r, p, res, step, prevx, prevy, x, y
	for i,line in ipairs(lines)do
		of.setHexColor(line.color)
		r = line.radius * R
		line.position = line.position+line.speed*dt*2--update
		p = line.position
		res = 0.14 * r * line.angle 
		step = (line.angle)/res --max speed 15, min speed 5
		prevx, prevy = math.cos(p)*r, math.sin(p)*r
		x, y = 0, 0
		for j=1,res do
			p = step + p
			x, y = math.cos(p)*r, math.sin(p)*r
			of.line(x, y, prevx, prevy)
			prevx, prevy = x, y
		end
	end
	--print(#lines)
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
	--table.insert(lines, Line.new())
end

