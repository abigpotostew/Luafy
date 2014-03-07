/*
 * Copyright (c) 2012 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/ofxLua for documentation
 *
 */
#pragma once

#include "ofMain.h"

#include "ofxLua.h"
#include "ofxLuaBindings.h"	// the OF api -> lua binding

#include "ofxUI.h"

#include <map>

class ofApp : public ofBaseApp, ofxLuaListener {

	public:

		// main
		void setup();
		void update();
		void draw();
        void exit();
    
        void dragEvent(ofDragInfo dragInfo);
		
		// input
		void keyPressed(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		
		// ofxLua error callback
		void errorReceived(string& msg);
		
		// script control
		void reloadScript();
		void nextScript();
		void prevScript();
		
		ofxLua lua;
		vector<string> scripts;
		int currentScript;
        bool hasError;
        std::string error;
    
    ofxUICanvas *gui;
	void guiEvent(ofxUIEventArgs &e);
    
private:
    
    void build_directory_gui();
    void add_to_gui(string path);
    map<string,string> directory_map;
    void reset_directory_gui();
};
