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

local objs = {}
local polys = {}

local ct = 0
local max_ct = 50
local minvel = 0.007
local maxvel = 0.017


local function map(value, in_from, in_to, out_from, out_to)
    return out_from+((value - in_from)/(in_to - in_from))*(out_to - out_from)
end

----------------------------------------------------
function setup()
	of.setWindowShape(900, 900)
	
	width = of.getWidth()
	height = of.getHeight()
	h_width = width/2
	h_height = height/2
	hw_ratio = height / width
	
	
	
	math.randomseed(os.time())
	
	of.setWindowTitle("circles1")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	of.setPolyMode(of.POLY.WINDING_NONZERO)
	
	of.enableSmoothing()
end

----------------------------------------------------
function update()
	local dt = of.getElapsedTimef() - time
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
--fbo:beginCapture()
	of.clear(255,255,255,255)
	of.setColor(0,0,0,255)
	local zoom = norm_sin(time,100,1)
	local count = norm_sin(time, 1, 100)
	
	
	
	of.pushMatrix()
	of.translate(h_width, h_height)
	
	local i_n, r
	for i=1, count do
		i_n = i/count
		i_n = i_n*i_n
		of.circle(0, 0, i_n*width)
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

