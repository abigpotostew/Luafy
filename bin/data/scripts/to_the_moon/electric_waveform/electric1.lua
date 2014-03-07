local tween = require('tween')
local Vec2 = require('lib.vector2')
local time = 0
local timer = 0
local bSmooth = false

local states = {TWEENING=0, IDLE=1}
local state = states.TWEENING

local hw_ratio = 1
local width, height = 0, 0
local h_width, h_height = 0, 0

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

local current_shape_idx = 0
local current_shape = nil
local shapes = {}
local shape_names = {}
local points = {}
local points_to_remove = 0
local point_ct = 0
local tween_time = 1.4
local idle_time = 0.5
local curr_shape_name = nil

local function map(value, in_from, in_to, out_from, out_to)
    return out_from+((value - in_from)/(in_to - in_from))*(out_to - out_from)
end

-------------------------------------------------------------------------------
-- Points
-------------------------------------------------------------------------------
local function point(_x, _y)
	return {x=_x or 0, y=_y or 0}
end

local function add_point(_x, _y)
	table.insert(points, point(_x, _y))
	point_ct = point_ct + 1
end

local function delete_point_at(index, offset)
	--points_to_remove = points_to_remove + 1
	table.remove(points)
	point_ct = point_ct - 1
end


-------------------------------------------------------------------------------
-- Shapes
-------------------------------------------------------------------------------
local function create_shapes()
	shapes.vertical = {
		point(h_width, h_height - h_height/2),
		point(h_width, h_height 			),
		point(h_width, h_height + h_height/2)
	}
	shapes.horizontal = {
		point(h_width - h_width/2, h_height),
		point(h_width - h_width/4, h_height),
		point(h_width 			 , h_height),
		point(h_width + h_width/4, h_height),
		point(h_width + h_width/2, h_height),
	}
	shapes.circle = {}
	for i = 1, 10 do
		local a = TWO_PI/10*i
		table.insert( shapes.circle, point(h_width+200*math.cos(a), h_height + 200*math.sin(a) ) )
	end
	shapes.hexagon = {}
	for i = 1, 6 do
		local a = TWO_PI/6*i
		table.insert( shapes.hexagon, point(h_width+200*math.cos(a), h_height + 200*math.sin(a) ) )
	end
	shapes.grid = {}
	local step = (math.min(width,height)-100)/7
	for i = 1, 7 do
		for j = 1, 7 do
			table.insert( shapes.grid, point(50 + i*step, 50 + j*step ) )
		end
	end
	for k, _ in pairs(shapes) do
		table.insert(shape_names, k)
	end
end

local function start_next_shape()
	current_shape_idx = current_shape_idx + 1
	if current_shape_idx > #shape_names then current_shape_idx = 1 end
	

	curr_shape_name = shape_names[current_shape_idx]
	current_shape = shapes[curr_shape_name]
	local shape_point_ct = #current_shape
	
	--add new points underneath existing points
	if point_ct < shape_point_ct then
		if point_ct == 0 then
			add_point(h_width, h_height)
		end
		local prev_pt_ct = point_ct
		while point_ct < shape_point_ct do
			add_point (points[point_ct%prev_pt_ct+1].x, points[point_ct%prev_pt_ct+1].y)
		end
	end
	
	local ease_type = 'inOutSine'
	
	--Tween required points to new shape
	-- for i=1, shape_point_ct do
-- 		tween.start( tween_time, points[i], current_shape[i], ease_type )
-- 	end
	for i=1, point_ct do
		if i <= shape_point_ct then
			tween.start( tween_time, points[i], current_shape[i], ease_type )
		else
			tween.start( tween_time, points[i], current_shape[i%shape_point_ct+1], ease_type, delete_point_at, i, i-shape_point_ct-1)
		end
	end
	
	tween.start(tween_time + idle_time, {a=0},{a=1}, 'linear', start_next_shape)
end

----------------------------------------------------
function setup()
	of.enableSmoothing()
	of.setWindowShape(800,600)
	width = of.getWidth()
	height = of.getHeight()
	h_width = width/2
	h_height = height/2
	hw_ratio = height / width
	
	of.setWindowTitle("electric")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps

	create_shapes()
	
	start_next_shape()
end



----------------------------------------------------
function update()
	local dt = of.getElapsedTimef() - time
	time = of.getElapsedTimef() --seconds
	timer = timer + dt
	tween.update(dt)
	-- if points_to_remove then
-- 		print('points #', #points)
-- 		print('removing #', points_to_remove)
-- 		for i=1, points_to_remove do
-- 			table.remove(points)
-- 		end
-- 		points_to_remove = 0
-- 	end
end

----------------------------------------------------
function draw()
	of.clear(0,255,255,255)
	of.noFill()

	of.setHexColor(0x000000)
	--of.drawBitmapString(curr_shape_name .. ", " .. point_ct, 10, height-15)
	
	for i = 1, point_ct do
		of.circle(points[i].x, points[i].y, 10)
	end
	
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

