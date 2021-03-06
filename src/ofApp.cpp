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
#include "ofApp.h"

#include "StringBuilder.h"

//--------------------------------------------------------------
void ofApp::setup() {
    
#ifdef TARGET_OPENGLES
    // While this will will work on normal OpenGL as well, it is
    // required for OpenGL ES because ARB textures are not supported.
    // If this IS set, then we conditionally normalize our
    // texture coordinates below.
    ofEnableNormalizedTexCoords();
#endif
    ofDisableArbTex();
    
	ofSetVerticalSync(true);
    ofSetEscapeQuitsApp(false);
    
    
    //file browser gui
    gui = new ofxUIScrollableCanvas();
    max_gui_width = OFX_UI_GLOBAL_CANVAS_WIDTH;
    ofAddListener(gui->newGUIEvent,this,&ofApp::guiEvent);
    
    
	// scripts to run
    scripts.push_back("scripts/dragScript.lua");
    
    reset_directory_gui();
    
    
    //console gui
    guiConsole = new ofxUIScrollableCanvas();
    guiConsole->setSnapping(false);
    ofAddListener(gui->newGUIEvent,this,&ofApp::guiConsoleEvent);
    
    //Redirect all log output to gui console
    ofSetLoggerChannel(ofPtr<ofGUILoggerChannel>(new ofGUILoggerChannel(this)));
	ofSetLogLevel("ofxLua", OF_LOG_NOTICE);
    
    //Set position and size of console GUI
    windowResized(ofGetWidth(), ofGetHeight());
    
    
	currentScript = 0;
	
	// listen to error events
	lua.addListener(this);
	
    
    reloadScript();
    
    
    ofLogNotice()<<"Test Msg words words yellow sadfhjasdk fAUGSDLASKHJ"<<endl;
    ofLogNotice()<<"This is a super long test message. I really want an avocado and a beach. Got one? Gosh I don't think this could be any long. I want pizza!!!!!! I want pizza! HUWAAW ahsdhakjsh "<<endl;
    
}

//--------------------------------------------------------------
void ofApp::update() {
	// call the script's update() function
	lua.scriptUpdate();
}

//--------------------------------------------------------------
void ofApp::draw() {
	// call the script's draw() function
	lua.scriptDraw();
}

//--------------------------------------------------------------
void ofApp::exit() {
	// call the script's exit() function
	lua.scriptExit();
	
	// clear the lua state
	lua.clear();
    
    delete gui;
    delete guiConsole;
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key) {
    
    if ( key == OF_KEY_ESC ){
        if ( gui->isVisible() ){
            gui->toggleVisible();
            gui->clearWidgets();
        }else{
            reset_directory_gui();
        }
        
        guiConsole->toggleVisible();
    }
	
	lua.scriptKeyPressed(key);
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y) {
	lua.scriptMouseMoved(x, y);
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button) {
	lua.scriptMouseDragged(x, y, button);
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button) {
	lua.scriptMousePressed(x, y, button);
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button) {
	lua.scriptMouseReleased(x, y, button);
}

template <typename T>
T minimum(T a, T b) {
    return (a <= b) ? a : b;
}

template <typename T>
T maximum(T a, T b) {
    return (a >= b) ? a : b;
}

void ofApp::windowResized(int w, int h){
    if ( gui && guiConsole ){
        int padding = 10;
        int position = max_gui_width+padding;
        int width = maximum<int>(w - max_gui_width-padding, 150);
        guiConsole->setPosition(position, 0);
        guiConsole->setWidth( width );
        guiConsole->setHeight(h);
        auto widgets = guiConsole->getWidgets();
        for(int i=0;i < widgets.size(); ++i){
            //widgets[i]->windowResized(width, h-2*padding);
        }
    }
}

//--------------------------------------------------------------
// ofxLua error callback
void ofApp::errorReceived(string& error) {
	//ofLogNotice() << "got a script error: " << msg;
    
    addConsoleMessage(error);
}

//--------------------------------------------------------------
void ofApp::reloadScript() {
	// exit, reinit the lua state, and reload the current script
	lua.scriptExit();
	lua.init(true);
	lua.bind<ofxLuaBindings>(); // rebind
    
    //Clear the gui console
    guiConsole->clearWidgets();
    
    //add the current script path to the lua path so require works correctly
    string fullpath = ofFilePath::getAbsolutePath(ofToDataPath(scripts[currentScript]));
	string folder = ofFilePath::getEnclosingDirectory(fullpath);
    string new_path("package.path = '");
    new_path.append(folder);
    new_path.append("?.lua;' .. package.path;");
    lua.doString(new_path);
    
    lua.bind<ofPrintWrapper>();
    
    lua.doString("print = function (...) local msg=''; local arg={...}; "\
                 "for i,v in ipairs(arg) do "\
                 "msg = msg .. tostring(v) ..'\t' end; "\
                 "of.printToGUI(msg); end"
                 );
    
    ofResetElapsedTimeCounter();
	lua.doScript(scripts[currentScript]);
	lua.scriptSetup();
}

void ofPrintWrapper::bind(ofxLua& _lua){
    using namespace luabind;
    
    module(_lua, "of")	// create an "of" table namespace
    [
     // bind a function
     def("printToGUI", &ofPrintWrapper::lua_print)
     ];
}

void ofApp::add_to_gui(string path){
    ofDirectory dir(path);
    if (!dir.isDirectory())
        return;
    
    //list all lua files, add gui for these
    dir.allowExt("lua");
    dir.listDir();
    for(int i = 0; i < dir.size(); ++i){
        string lua_file = dir.getPath(i);
        directory_map.insert(pair<string,string>(lua_file, path));
        int w = gui->addButton(lua_file, false)->getPaddingRect()->getWidth();
        if(w > max_gui_width)max_gui_width=w;
    }
    
    //list all directories and recursively appl this func
    dir = ofDirectory(path);
    dir.listDir();
    for(int i = 0; i < dir.size(); ++i){
        add_to_gui(dir.getPath(i));
    }
}

void ofApp::build_directory_gui(){
    string path = "./scripts/";
    gui->addLabel("./scripts/");
    add_to_gui(path);
}

void ofApp::reset_directory_gui(){
    build_directory_gui();
    gui->setVisible(true);
    gui->autoSizeToFitWidgets();
    windowResized(ofGetWidth(), ofGetHeight());
}

void ofApp::guiEvent(ofxUIEventArgs &e){
    string name = e.widget->getName();
	int kind = e.widget->getKind();
    if ( kind == OFX_UI_WIDGET_BUTTON && e.getButton()->getValue() == 0){
        scripts.clear();
        scripts.push_back(name);
        reloadScript();
    }
}

void ofApp::guiConsoleEvent(ofxUIEventArgs &e){
    
}

void ofApp::addConsoleMessage(const string& message){
    guiConsole->addTextArea("", message, OFX_UI_FONT_SMALL);
}

//--------------------------------------------------
void ofGUILoggerChannel::log(ofLogLevel level, const string & module, const string & message){
	// print to cerr for OF_LOG_ERROR and OF_LOG_FATAL_ERROR, everything else to cout
	
    StringBuilder m;
    m.append("[").append(ofGetLogLevelName(level, true)).append("] ");
    if(module != ""){
        m.append(module).append(": ");
    }
    m.append(message);
    app->addConsoleMessage(m.str());
}

void ofGUILoggerChannel::log(ofLogLevel level, const string & module, const char* format, ...){
	//TODO: this isn't supported yet by the gui console
    va_list args;
	va_start(args, format);
	log(level, module, format, args);
	va_end(args);
}

void ofGUILoggerChannel::log(ofLogLevel level, const string & module, const char* format, va_list args){
	//thanks stefan!
	//http://www.ozzu.com/cpp-tutorials/tutorial-writing-custom-printf-wrapper-function-t89166.html
	FILE* out = level < OF_LOG_ERROR ? stdout : stderr;
	fprintf(out, "[%s] ", ofGetLogLevelName(level, true).c_str());
	if(module != ""){
		fprintf(out, "%s: ", module.c_str());
	}
	vfprintf(out, format, args);
	fprintf(out, "\n");
    //TODO: this isn't supported yet
}
