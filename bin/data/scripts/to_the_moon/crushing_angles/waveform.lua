time = 0
bSmooth = false

local hw_ratio = 1
local width, height = 0, 0
local h_width, h_height = 0, 0

--returns x when line is at top of screen
local function x_at_top(r, a, x)
    return r/a + x
end

--when p > 1, returns the y value where it intesects the line x = 1
local function y_past_1(a, x)
    return a*(1-x)
end


local mouse = {x=0,y=0}

TWO_PI = math.pi * 2
HALF_PI = math.pi/2
SIXTH_PI = math.pi/6 --30 deg
THRD_PI = math.pi/3 --60 deg

local objs = {}

local ct = 0
local max_ct = 7
local minvel = 0.009
local maxvel = 0.03


local function map(value, in_from, in_to, out_from, out_to)
    return out_from+((value - in_from)/(in_to - in_from))*(out_to - out_from)
end

--position (0..1), velocity, ceiling, angle, y is position after p>1
local function get_obj(_p)
	local out = 
	 { p = _p or 0,
	   v = math.random(),
	   c = 0,
   	   y = 0 } 
	   out.a = math.tan( out.v*SIXTH_PI + HALF_PI + SIXTH_PI )
	   out.v = out.v*(maxvel-minvel)+minvel
	   out.c = x_at_top(hw_ratio, out.a, 0)
	return out
end 
local function sort_func(a, b) --a & b are objs
	return a.p < b.p
end



----------------------------------------------------
function setup()
	width = of.getWidth()
	height = of.getHeight()
	h_width = width/2
	h_height = height/2
	hw_ratio = height / width
	
	of.setWindowTitle("yikes")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps

end

----------------------------------------------------
function update()
	time = time + 0.033
	
	local i = 1
	while i <= ct do
		if objs[i].p > 1 then
			if objs[i].d > hw_ratio then
				objs[i] = objs[ct] --swap
				ct = ct - 1
			end
		end
		objs[i].p = objs[i].p + objs[i].v
		objs[i].c = objs[i].c + objs[i].v
		if objs[i].p > 1 then
			objs[i].d = y_past_1(objs[i].a, objs[i].p)
		end
		i = i + 1
	end
	
	table.sort(objs, sort_func) --sort by positions
		
	for i=1, ct do
		
	end
	
	if ct < max_ct and math.random()>.1 then
		ct = ct + 1
		objs[ct] = get_obj()
	end
		
end

----------------------------------------------------
function draw()
--fbo:beginCapture()
	of.clear(0,255,255,255)
	of.noFill()

	of.setHexColor(0x000000)
	of.drawBitmapString('hey', 75, 500)
	
	of.pushMatrix()
	of.translate(0, of.getHeight()/2)

	for i=1, ct do
		if objs[i].p <=1 then
			of.circle(objs[i].p*h_width, 0, 10)
			of.line(objs[i].p*h_width, 0, objs[i].c*h_width, -h_height)
			of.line(objs[i].p*h_width, 0, objs[i].c*h_width, h_height)
		else
			of.line(h_width, objs[i].d, objs[i].c*h_width, -h_height)
			of.line(h_width, objs[i].d, objs[i].c*h_width, h_height)
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
end

function mouseMoved(x, y)
	mouse.x = x
	mouse.y = y
end

