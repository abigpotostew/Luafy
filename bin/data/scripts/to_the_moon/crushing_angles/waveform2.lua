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
local polys = {}

local ct = 0
local max_ct = 7
local minvel = 0.009
local maxvel = 0.03


local function map(value, in_from, in_to, out_from, out_to)
    return out_from+((value - in_from)/(in_to - in_from))*(out_to - out_from)
end

--position (0..1), velocity, ceiling, angle, y is position after p>1
local function new_obj(_p)
	local out = 
	 { p = _p or 0,
	   v = math.random(),
	   c = 0,
   	   y = 0} 
	   out.a = math.tan( out.v*SIXTH_PI + HALF_PI + SIXTH_PI )
	   out.v = out.v*(maxvel-minvel)+minvel
	   out.c = x_at_top(hw_ratio, out.a, 0)
	   if math.random() > 0.5 then
		   out.color = 0x000000
		else out.color = 0xFFFFFF end
		   
	return out
end 
local function sort_func(a, b) --a & b are objs
	return a.p < b.p
end

local function new_poly(x1, y1, x2, y2, x3, y3, x4, y4, hex_color)
	return { 4, x1, y1, x2, y2, x3, y3, x4, y4, hex_color }
end
local function new_tri(x1, y1, x2, y2, x3, y3, hex_color)
	return { 3, x1, y1, x2, y2, x3, y3, hex_color }
end 

----------------------------------------------------
function setup()
	width = of.getWidth()
	height = of.getHeight()
	h_width = width/2
	h_height = height/2
	hw_ratio = height / width
	
	of.setWindowTitle("yikes2")
	
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
	
	polys = {}
	for i=2, ct do
		if objs[i].c > objs[i-1].c then
			table.insert(polys, new_poly(math.min(objs[i].p*h_width,h_width), --x1
										 0,
										 objs[i-1].p*h_width, --x2
										 0,
										 objs[i-1].c*h_width, --x3
										 -h_height,
										 objs[i].c*h_width, --x4
										 -h_height,
										 objs[i].color --color
										 ))
		end
	end
	
	if ct < max_ct and math.random()>.1 then
		ct = ct + 1
		objs[ct] = new_obj()
	end
		
end

----------------------------------------------------
function draw()
--fbo:beginCapture()
	--of.clear(0,255,255,255)
	of.clear(0,00,0,30)
	of.noFill()

	of.setHexColor(0xFFFFFF)
	--of.drawBitmapString('hey', 75, 500)
	
	of.pushMatrix()
	of.translate(0, of.getHeight()/2)

	local x1, x2, y1, y2
	for i=1, ct do
		if objs[i].p <=1 then
			x1, x2, y2 = objs[i].p*h_width, objs[i].c*h_width, -h_height
			
			--left
			of.line(x1, 0, x2, y2)
			of.line(x1, 0, x2, -y2)
			
			--right
			x1 = width - x1
			x2 = width - x2
			of.line(x1, 0, x2, y2)
			of.line(x1, 0, x2, -y2)
		else
			x1, y1, x2, y2 = h_width, -objs[i].d*h_height, objs[i].c*h_width, -h_height
			--left
			of.line(x1, y1, x2, y2)
			of.line(x1, -y1, x2, -y2)
			--right
			x1 = width - x1
			x2 = width - x2
			of.line(x1, y1, x2, y2)
			of.line(x1, -y1, x2, -y2)
		end
		
	end
	
	for i=1, #polys do
		local num_verts = polys[i][1]
		--of.setHexColor(polys[i][num_verts*2+1])
		of.beginShape()
		for j=2, num_verts, 2 do
			--of.vertex(polys[i][j], polys[i][j+1])
		end
		of.endShape()
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

