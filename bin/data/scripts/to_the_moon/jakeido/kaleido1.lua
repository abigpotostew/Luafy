

local time = 0
local bSmooth = false

local opal = of.Image()
local eyes_img = of.Image()
local ballet_img = of.Image()
local ballet_img2 = of.Image()

local shader = of.Shader()

local target = of.TARGET.CURRENT

local vbo_mesh

local error = nil
----------------------------------------------------
function setup()
	width = 800
	height = 800
	h_width = width/2
	h_height = height/2

	of.setCircleResolution(50)
	--of.background(255, 255, 255, 255)
	of.setWindowTitle("kaleido")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	
	opal:loadImage("scripts/to_the_moon/jakeido/opal.jpg")
   eyes_img:loadImage("scripts/to_the_moon/jakeido/eyes.jpg")
   ballet_img:loadImage("scripts/to_the_moon/jakeido/ballet.jpg")
   ballet_img2:loadImage("scripts/to_the_moon/jakeido/ballet2.jpg")
   eyes_img=nil
   eyes_img = ballet_img2

	of.setWindowShape(width, height)
	
   of.setTextureWrap(of.Texture.WRAP.MIRRORED_REPEAT,of.Texture.WRAP.MIRRORED_REPEAT)

	shader:setUniform2i('resolution', width, height)
	
   --Load correct shader
	if target == of.TARGET.RASPBERRYPI then
      shader:load('scripts/to_the_moon/jakeido/es2/kaleidoscope')
	elseif of.isGLProgrammableRenderer() then
		shader:load('scripts/to_the_moon/jakeido/gl3/kaleidoscope')
	else
      shader:load('scripts/to_the_moon/jakeido/gl2/kaleidoscope')
   end
	
	shader:setUniform2f('resolution', width, height)
	shader:setUniform2f('mouse', h_width, h_height)
	
	if not shader:isLoaded() then
		--og.Log()
	end


	vbo_mesh = of.VboMesh()
	vbo_mesh:setUsage(of.PRIMITIVE.TRIANGLES)
	vbo_mesh:addVertex(0,0,0)
	vbo_mesh:addVertex(width,0,0)
	vbo_mesh:addVertex(width,height,0)
	vbo_mesh:addVertex(0,height,0)
	vbo_mesh:addTexCoord(0, 0)
	vbo_mesh:addTexCoord(0, 10)
	vbo_mesh:addTexCoord(10, 10)
	vbo_mesh:addTexCoord(0, 10)

end

----------------------------------------------------
function update()
	time = of.getElapsedTimef()
end

----------------------------------------------------
function draw()
	of.clear(255,255,255,255)
	of.setColor(255,255,255)
	
	if not shader:isLoaded() then
		return
	end


	shader:beginShader()

	shader:setUniform2f('mouse',of.getMouseX(),of.getMouseY())
	shader:setUniform1f('time', of.getElapsedTimef())
	shader:setUniform2f('resolution', width, height)
	
		eyes_img:draw(0,0,width,height) --this binds the texture and draws a plane with correct tex coords.

	shader:endShader()

end

----------------------------------------------------
function exit()
	--print("script finished")
end

-- input callbacks

----------------------------------------------------
function keyPressed(key)
end

function mouseMoved(x, y)
	
end

