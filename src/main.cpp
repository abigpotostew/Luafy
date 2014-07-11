/*
 * Copyright (c) 2011 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/ofxLua for documentation
 *
 */
#include "ofMain.h"
#include "ofApp.h"
#include "ofAppGlutWindow.h"

#ifdef USE_PROGRAMMABLE_GL
// tig: using the programmable GL renderer is more fun, since we can use GLSL 150 =)
// define USE_PROGRAMMABLE_GL in testApp.h to run this example in OpenGL 3.2 if your
// system provides it...
#include "ofGLProgrammableRenderer.h"
#endif

//========================================================================
int main() {

#ifdef USE_PROGRAMMABLE_GL
	ofPtr<ofBaseRenderer> renderer(new ofGLProgrammableRenderer(false));
	ofSetCurrentRenderer(renderer, false);
#endif
    
    ofAppGlutWindow window;
	ofSetupOpenGL(&window, 1024, 768, OF_WINDOW);

	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp(new ofApp());
}
