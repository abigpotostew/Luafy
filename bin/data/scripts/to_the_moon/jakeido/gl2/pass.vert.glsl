#version 120

// this is something we're creating for this shader
varying vec2 texCoordVarying;

// this is coming from our C++ code
uniform vec2 mouse;
//uniform vec2 resolution;

void main()
{
	vec2 texcoord = vec2(gl_MultiTexCoord0.x , gl_MultiTexCoord0.y );
	//gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0 + vec4(mouse.xy, .0, .0);
	
    // here we move the texture coordinates
    texCoordVarying = vec2(texcoord.x - mouse.x, texcoord.y - mouse.y);

    // send the vertices to the fragment shader
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}