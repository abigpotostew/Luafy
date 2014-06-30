

local time = 0
local bSmooth = false

local opal = of.Image()
local shader = of.Shader()
local plane

local target = of.TARGET.CURRENT

local error = nil
----------------------------------------------------
function setup()
	print("script setup")
	width = 1440
	height = 900
	h_width = width/2
	h_height = height/2

	of.setCircleResolution(50)
	--of.background(255, 255, 255, 255)
	of.setWindowTitle("kaleido")
	
	of.setFrameRate(30) -- if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps
	--shader.load('vert', 'frag')
	local opalPath = "scripts/to_the_moon/jakeido/opal.jpg"
	local oversoulPath = "images/oversoul.jpg"
	opal:loadImage(oversoulPath)
	of.setWindowShape(width, height)
	
	local tex = opal:getTextureReference()
	--of.setTextureWrapST(of.WRAP.REPEAT, of.WRAP.REPEAT)
	of.setTextureWrapRepeat()
	--tex:setTextureWrap(of.WRAP.REPEAT, of.WRAP.REPEAT)

	shader:setUniform2i('resolution', width, height)
	
	--plane = of.planePrimitive()
	--plane:set(width,height,10,10)
	--plane:mapTextCoords(0,0, opal:getWidth(), opal:getHeight())
	
	--shader:setUniformTexture('tex0', opal:getTextureReference(), 0)
	if target == of.TARGET.OSX then
		shader:load('scripts/to_the_moon/jakeido/gl2/pass.vert.glsl',
			 		'scripts/to_the_moon/jakeido/gl2/kaleidoscope.frag.glsl')
		--shader:load('scripts/to_the_moon/jakeido/gl2/shader.vert',
		--			 'scripts/to_the_moon/jakeido/gl2/shader.frag')
	end
	
	if target == of.TARGET.RASPBERRYPI then
		shader:load('scripts/to_the_moon/jakeido/es2/pass.vert.glsl',
			 		'scripts/to_the_moon/jakeido/es2/kaleidoscope.frag.glsl')
		--shader:load('scripts/to_the_moon/jakeido/es2/shader.vert',
		--			 		'scripts/to_the_moon/es2/jakeido/shader.frag')
	end
	
	shader:setUniform2f('resolution', width, height)
	shader:setUniform2f('mouse', h_width, h_height)
	
	if not shader:isLoaded() then
		--og.Log()
	end
end

----------------------------------------------------
function update()
	time = time + 0.033
end

----------------------------------------------------
function draw()
	of.clear(255,255,255,255)
	of.setColor(255,255,255)
	
	if not shader:isLoaded() then
		return
	end

	--opal:bind()
	
	--shader:setUniformTexture("tex0", opal:getTextureReference(), 1);
	--opal:getTextureReference():bind()
	shader:beginShader()
	
	shader:setUniform2f('mouse',of.getMouseX(),of.getMouseY())
	shader:setUniform1f('time', time)
	shader:setUniform2f('resolution', width, height)
	
		opal:draw(0,0,opal:getWidth(),opal:getHeight()) --this binds the texture and draws a plane with correct tex coords.

		of.beginShape()

	shader:endShader()
	--opal:getTextureReference():unbind()
	
	--opal:draw(h_width,h_height,h_width,h_height)
	
	--opal:unbind()
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

