
// Project: Escape from Dungeon 
// Created: 2017-05-03

#include "GObject.agc"
#include "Globals.agc"
#include "Player.agc"
#include "Map.agc"

FirstObject AS GObject

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "Escape from Dungeon" )
SetWindowSize( 1024, 768, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1024, 768 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

FirstObject = GObject_Init(FirstObject, 5, 5, 1)

do
	Print (FirstObject.BigX)
	Print (GLB_RandomNum(0,255))
    Print (ScreenFPS())
    Sync ()
loop
