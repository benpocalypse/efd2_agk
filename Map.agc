#include "Globals.agc"

#constant MAPWIDTH	24 // The actual width of the map
#constant MAPHEIGHT	18 // The actual height of the map

// Defined storage for our 4 tiles
#constant MT_EMPTY    0
#constant MT_FLOOR    1
#constant MT_WALL_TOP 2
#constant MT_WALL_MID 3

// Defines for our door
#constant MT_EXIT     0
#constant MT_ENTRANCE 1

// Array size defines
#constant MAX_OBSTACLES   5
#constant MAX_ITEMS       5

// Our map data storage array
global objMap as MapObject[MAPWIDTH, MAPHEIGHT] 

// Our entry and exit door objects.
global objEntrance as MapObject
global objExit as MapObject
global objObstacles as MapObject[MAX_OBSTACLES]
global objItems as MapObject[MAX_ITEMS]

///****************************************************************************
/// Initializes our map structure to contain all empty tiles initially.
///****************************************************************************
FUNCTION MAP_InitializeMap()
    // Empty our map...
    for i = 0 to MAPWIDTH
        for j = 0 to MAPHEIGHT
            objMap[i, j].ObjectType = MT_EMPTY
        next j
    next i

    // And our obstacles...
    for i = 0 to MAX_OBSTACLES
        objObstacles[i].ObjectType = EMPTY
        objObstacles[i].X = 0
        objObstacles[i].Y = 0
    next i

    // and finally our items.
    for i = 0 to  MAX_ITEMS
        objItems[i].ObjectType = EMPTY
        objItems[i].X = 0
        objItems[i].Y = 0
    next i
ENDFUNCTION

///****************************************************************************
/// This function takes care of actually generating the 'maze' and fills it
/// with the appropriate tiles. The argument just tells us which type of 
/// random room we're going to generate.
///****************************************************************************
FUNCTION MAP_GenerateMap(ucRoomType as INTEGER)
    // 2 randomly placed rooms connected by tunnels.
    if(ucRoomType = 0)
        ucWidth as INTEGER = 0
        ucWidth2 as INTEGER = 0
        ucHeight as INTEGER = 0
        ucHeight2 as INTEGER = 0
        
        ucRoomOnePosition as INTEGER 
        ucRoomOne = GLB_RandomNum(0,1)
        ucRoomTwoPosition as INTEGER 
        ucRoomTwo = GLB_RandomNum(0,1)

        // First, decide the room width/height.
        ucWidth = GLB_RandomNum(9, 14)
        ucHeight = GLB_RandomNum(10, 15)
        
        // Draw room 1 first.
        // Draw the left, right, top, and then bottom walls.
        MAPi_DrawLine(0, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)), 0, ucHeight + (ucRoomOnePosition*(MAPHEIGHT-ucHeight-1)), MT_WALL_TOP)
        MAPi_DrawLine(ucWidth, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)), ucWidth, ucHeight + (ucRoomOnePosition*(MAPHEIGHT-ucHeight-1)), MT_WALL_TOP)
        MAPi_DrawLine(1, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)), ucWidth - 1, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)), MT_WALL_MID)
        MAPi_DrawLine(0, ucHeight + (ucRoomOnePosition*(MAPHEIGHT-ucHeight-1)), ucWidth, ucHeight + (ucRoomOnePosition*(MAPHEIGHT-ucHeight-1)), MT_WALL_MID)

        // Finally, fill the floor of room 1 with 1 of our 3 floor tile types.
        MAPi_FloodFill(ucWidth/2,(ucRoomOnePosition*(MAPHEIGHT-(ucHeight/2)))+1, MT_FLOOR)


        // Now draw room 2.     
        // First, decide the room width/height.
        ucWidth2 = GLB_RandomNum(6, 21-ucWidth)
        ucHeight2 = GLB_RandomNum(9, 16)

        // Draw the left, right, top, and then bottom walls.
        MAPi_DrawLine(MAPWIDTH-ucWidth2, (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2)), MAPWIDTH-ucWidth2, ucHeight2 + (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2-1)), MT_WALL_TOP)
        MAPi_DrawLine(MAPWIDTH-1, (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2)), MAPWIDTH-1, ucHeight2 + (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2-1)), MT_WALL_TOP)
        MAPi_DrawLine(MAPWIDTH-ucWidth2+1, (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2)), MAPWIDTH-2, (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2)), MT_WALL_MID)
        MAPi_DrawLine(MAPWIDTH-ucWidth2, ucHeight2 + (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2-1)), MAPWIDTH-1, ucHeight2 + (ucRoomTwoPosition*(MAPHEIGHT-ucHeight2-1)), MT_WALL_MID)

        // Finally, fill the floor of room 2 with 1 of our 3 floor tile types.
        MAPi_FloodFill(MAPWIDTH-(ucWidth2/2),(ucRoomTwoPosition*(MAPHEIGHT-(ucHeight2/2)))+1, MT_FLOOR)

        // Now lets connect the two rooms with a hallway...

        // If both rooms are on the same level..
        if(ucRoomOnePosition = ucRoomTwoPosition)
        //...then lets just run a straight hallway between them.
            // Draw the top.
            MAPi_DrawLine(ucWidth, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2) - 1, MAPWIDTH-ucWidth2, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2) - 1, MT_WALL_MID)
                     
            // Draw the floor.
            MAPi_DrawLine(ucWidth, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2), MAPWIDTH-ucWidth2, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2), MT_FLOOR)
            
            // Now draw the bottom.
            MAPi_DrawLine(ucWidth+1, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2) + 1, MAPWIDTH-ucWidth2-1, (ucRoomOnePosition*(MAPHEIGHT-ucHeight)) + (ucHeight/2) + 1, MT_WALL_MID)

            MAPi_AddDoor(D_UP, TRUE)
            MAPi_AddDoor(D_DOWN, FALSE)
        else
        //...we need to make a connecting hallway with a bend.
            // If room 1 is on the top...
            if(ucRoomOnePosition = 0)
            // Then draw a right elbow.
                MAPi_DrawLine((ucWidth/2)-1, ucHeight, (ucWidth/2)-1, MAPHEIGHT-2, MT_WALL_TOP)
                MAPi_DrawLine((ucWidth/2)-1, MAPHEIGHT-1, MAPWIDTH-ucWidth2, MAPHEIGHT-1, MT_WALL_MID)
                
                MAPi_DrawLine((ucWidth/2), ucHeight, (ucWidth/2)+1, MAPHEIGHT-2, MT_FLOOR)
                MAPi_DrawLine((ucWidth/2), MAPHEIGHT-2, MAPWIDTH-ucWidth2, MAPHEIGHT-2, MT_FLOOR)
                
                MAPi_DrawLine((ucWidth/2)+1, ucHeight, (ucWidth/2)+1, MAPHEIGHT-3, MT_WALL_TOP)
                MAPi_DrawLine((ucWidth/2)+1, MAPHEIGHT-3, MAPWIDTH-ucWidth2, MAPHEIGHT-3, MT_WALL_MID)

                MAPi_AddDoor(D_UP, TRUE)
                MAPi_AddDoor(D_RIGHT, FALSE)
            else
            //...finally, room 2 must be on top.
                MAPi_DrawLine((ucWidth/2)-1, MAPHEIGHT-ucHeight-1, (ucWidth/2)-1, 0, MT_WALL_TOP)
                MAPi_DrawLine((ucWidth/2), 0, MAPWIDTH-ucWidth2, 0, MT_WALL_MID)
                
                MAPi_DrawLine((ucWidth/2), MAPHEIGHT-ucHeight, (ucWidth/2), 1, MT_FLOOR)
                MAPi_DrawLine((ucWidth/2), 1, MAPWIDTH-ucWidth2, 1, MT_FLOOR)
                
                MAPi_DrawLine((ucWidth/2)+1, MAPHEIGHT-ucHeight-1, (ucWidth/2)+1, 2, MT_WALL_TOP)
                MAPi_DrawLine((ucWidth/2)+2, 2, MAPWIDTH-ucWidth2-1, 2, MT_WALL_MID)

                MAPi_AddDoor(D_RIGHT, TRUE)
                MAPi_AddDoor(D_LEFT, FALSE)
            endif
        endif
    endif

    // One big room, with multiple obstacles.
    if(ucRoomType = 1)
        ucWidth = GLB_RandomNum(18, MAPWIDTH-1)
        ucHeight = GLB_RandomNum(14, MAPHEIGHT-1)
        ucDoor as INTEGER
        ucDoor = GLB_RandomNum(D_UP, D_RIGHT)
        
        // Draw the walls.
        MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2), (MAPHEIGHT/2) - (ucHeight/2), (MAPWIDTH/2) - (ucWidth/2), (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_TOP)
        MAPi_DrawLine((MAPWIDTH/2) + (ucWidth/2), (MAPHEIGHT/2) - (ucHeight/2), (MAPWIDTH/2) + (ucWidth/2), (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_TOP)
        MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2), (MAPHEIGHT/2) + (ucHeight/2), (MAPWIDTH/2) + (ucWidth/2), (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_MID)
        MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2) + 1, (MAPHEIGHT/2) - (ucHeight/2), (MAPWIDTH/2) + (ucWidth/2) - 1, (MAPHEIGHT/2) - (ucHeight/2), MT_WALL_MID)

        // Fill the floor.
        MAPi_FloodFill(MAPWIDTH/2,MAPHEIGHT/2, MT_FLOOR)

        // And add the doors.
        ucDoor2 as INTEGER
        ucDoor2 = GLB_RandomNum(D_UP, D_RIGHT)
        
        while(ucDoor = ucDoor2)
            ucDoor2 = GLB_RandomNum(D_UP, D_RIGHT)
        endwhile
        
        MAPi_AddDoor(ucDoor, TRUE)
        MAPi_AddDoor(ucDoor2, FALSE)
    endif

    // A long skinny room, with doors at opposite ends.
    if(ucRoomType = 2)
        if(GLB_RandomNum(0,1) = 0)
            ucHeight = GLB_RandomNum(8, 11)
            
            // Draw the walls.
            MAPi_DrawLine(0, (MAPHEIGHT/2) - (ucHeight/2), 0, (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_TOP)
            MAPi_DrawLine(MAPWIDTH-1, (MAPHEIGHT/2) - (ucHeight/2), MAPWIDTH-1, (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_TOP)
            MAPi_DrawLine(0, (MAPHEIGHT/2) + (ucHeight/2), MAPWIDTH-1, (MAPHEIGHT/2) + (ucHeight/2), MT_WALL_MID)
            MAPi_DrawLine(1, (MAPHEIGHT/2) - (ucHeight/2), MAPWIDTH-2, (MAPHEIGHT/2) - (ucHeight/2), MT_WALL_MID)

            // Fill the floor.
            MAPi_FloodFill(MAPWIDTH/2,MAPHEIGHT/2, MT_FLOOR)

            // And add the doors.
            MAPi_AddDoor(D_LEFT, TRUE)
            MAPi_AddDoor(D_RIGHT, FALSE)
        else
            ucWidth = GLB_RandomNum(8, 11)
            
            // Draw the walls.
            MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2), 0, (MAPWIDTH/2) - (ucWidth/2), MAPHEIGHT-2, MT_WALL_TOP)
            MAPi_DrawLine((MAPWIDTH/2) + (ucWidth/2), 0, (MAPWIDTH/2) + (ucWidth/2), MAPHEIGHT-2, MT_WALL_TOP)
            MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2)+1, 0, (MAPWIDTH/2) + (ucWidth/2)-1, 0, MT_WALL_MID)
            MAPi_DrawLine((MAPWIDTH/2) - (ucWidth/2), MAPHEIGHT-1, (MAPWIDTH/2) + (ucWidth/2), MAPHEIGHT-1, MT_WALL_MID)

            // Fill the floor.
            MAPi_FloodFill(MAPWIDTH/2,MAPHEIGHT/2, MT_FLOOR)

            // And add the doors.
            MAPi_AddDoor(D_UP, TRUE)
            MAPi_AddDoor(D_DOWN, FALSE)
        endif
    endif
    
    // FIXME - Change below to use map tiles, not "objects."
    //         I'll do this after I add enemies I believe.
    // Now pepper our room with 'stuff.'
    //AddObstacles(MAX_OBSTACLES);
ENDFUNCTION


///****************************************************************************
/// Draws the current map structure in the center of the screen to allow room
/// for the HUD to be drawn as well.
///****************************************************************************
FUNCTION MAP_DrawMyMap()
    // Each time we draw a map, randomly pick one of the 3 types of floors
    // to add a little variety to our maps.
    ucFloor as INTEGER
    ucFloor = GLB_RandomNum(1,3)
    
	for j = 0 to MAPHEIGHT
		for i = 0 to MAPWIDTH
		    ucTile as INTEGER
		    ucTile = MAP_TileIs(i,j)
		    
		    select(ucTile)
		        case MT_FLOOR
    		        GLB_SetTile(i+MAP_X_OFFSET, j+MAP_Y_OFFSET, ucFloor)
		            endcase
		        case MT_WALL_TOP
		            GLB_SetTile(i+MAP_X_OFFSET, j+MAP_Y_OFFSET, WALL_TOP)
		            endcase
		        case MT_WALL_MID
		            GLB_SetTile(i+MAP_X_OFFSET, j+MAP_Y_OFFSET, WALL_MIDDLE)
		            endcase
		        case default
		            GLB_SetTile(i+MAP_X_OFFSET, j+MAP_Y_OFFSET, EMPTY)
		            endcase
		    endselect
		next i
	next j
	
ENDFUNCTION


///****************************************************************************
/// This function draws all non-tile objects in the map class on the map.
/// FIXME - Is this really how we should handle this?
///****************************************************************************
FUNCTION MAP_DrawObjects()
    GLB_SetTile(objEntrance.X+MAP_X_OFFSET, objEntrance.Y+MAP_Y_OFFSET, objEntrance.ObjectType)
    GLB_SetTile(objExit.X+MAP_X_OFFSET, objExit.Y+MAP_Y_OFFSET, objExit.ObjectType)

    for i = 0 to MAX_OBSTACLES
        if (objObstacles[i].ObjectType > 0)
            GLB_SetTile(objObstacles[i].X+MAP_X_OFFSET, objObstacles[i].Y+MAP_Y_OFFSET, objObstacles[i].ObjectType)
        endif
    next i
ENDFUNCTION

///****************************************************************************
/// Returns the location of either the entrance or exit of the map.
///****************************************************************************
FUNCTION MAP_GetDoor(bEntrance as INTEGER)
	objReturn as MapObject
	
    if (bEntrance = MT_ENTRANCE)
        objReturn = objEntrance
    else
        objReturn = objExit
    endif
ENDFUNCTION objReturn


///****************************************************************************
/// This function allows outside classes to see which tiles are at which X/Y
/// coordinate to allow for things like collision detection.
///****************************************************************************
FUNCTION MAP_TileIs(X as INTEGER, Y as INTEGER)
	ucReturn as INTEGER
	
	if((X > 0) and (Y > 0))
		temp as INTEGER
		temp = objMap.length

		if((X < MAPWIDTH) and (Y < MAPHEIGHT))
			ucReturn =  objMap[X, Y].ObjectType
		else
			ucReturn = 0
		endif
	endif
ENDFUNCTION ucReturn

///****************************************************************************
/// This function allows outside classes to see which objects are at which X/Y
/// coordinate to allow for things like collision detection.
///****************************************************************************
FUNCTION MAP_ObjectIs(X as INTEGER, Y as INTEGER)
	
	ucReturn as INTEGER
	
    for i = 0 to MAX_OBSTACLES
        if ((objObstacles[i].X = X) and (objObstacles[i].Y = Y))
            ucReturn = objObstacles[i].ObjectType
        endif
    next i

    for i = 0 to MAX_ITEMS
        if ((objItems[i].X = X) and (objItems[i].Y = Y))
            ucReturn = objItems[i].ObjectType
        endif
    next i
ENDFUNCTION ucReturn

///****************************************************************************
/// Implements Bresenham's line drawing algorithm to efficiently draw lines
/// from one point to another in any direction.
///****************************************************************************
FUNCTION MAPi_DrawLine(StartX as INTEGER, StartY as INTEGER, EndX as INTEGER, EndY as INTEGER, Tile as INTEGER) 
	
	distance as INTEGER
    xerr  as INTEGER = 0
	yerr as INTEGER = 0
	delta_x as INTEGER
	delta_y as INTEGER
    incx as INTEGER
    incy as INTEGER

    /// Compute an x and y delta.
    delta_x = EndX - StartX
    delta_y = EndY - StartY

    // Compute the direction of the incrementation in the x direction
    // An increment of 0 means either a horizontal or vertical line.
    if (delta_x > 0)
		incx = 1
    else 
		if (delta_x = 0) 
			incx = 0
		else 
			incx = -1
		endif
	endif

	// Compute the direction of the incrementation in the y direction
    // An increment of 0 means either a horizontal or vertical line.
    if (delta_y > 0)
		incy = 1
    else 
		if (delta_y = 0)
			incy = 0
		else
			incy = -1
		endif
	endif

    /// Determine which direction is the greater incrementation.
    delta_x = abs(delta_x)
    delta_y = abs(delta_y)

    if (delta_x > delta_y) 
		distance = delta_x
    else
		distance = delta_y
	endif

    /// Now, finally draw our line.
    for t = 0 to (distance + 1)
		MAPi_Draw(StartX, StartY, Tile)
        
        xerr = xerr + delta_x
        yerr = yerr + delta_y

        if(xerr > distance)
            xerr = xerr -distance
            StartX = StartX + incx
		endif
        
        if (yerr > distance)
            yerr = yerr -distance
            StartY = StartY + incy
        endif
    next t
ENDFUNCTION


///****************************************************************************
/// Sets the tile at x/y to the passed in Type. This uses some tricky math
/// to work with our compressed map structure.
///****************************************************************************
FUNCTION MAPi_Draw(X as INTEGER, Y as INTEGER, ObjectType as INTEGER)
    objMap[X, Y].ObjectType = ObjectType
ENDFUNCTION


///****************************************************************************
/// Fills the specified x,y empty space with the destination tile until a 
/// non-empty tile is encountered.
///****************************************************************************
FUNCTION MAPi_FloodFill(X as INTEGER, Y as INTEGER, ObjectType as INTEGER)
   LeftNum as INTEGER
   RightNum as INTEGER
   InLine as INTEGER = 1
 
   /// Search to the left, filling along the way.
   LeftNum = X
   RightNum = X

   while(ucInLine = 1)
		MAPi_Draw(LeftNum, Y, ObjectType)
		LeftNum = LeftNum - 1
		
		if (LeftNum < 0)
			InLine = 0
		else
			if (MAP_TileIs(LeftNum, Y) = MT_EMPTY)
				InLine = 1
			else
				InLine = 0
			endif
		endif
   endwhile

   LeftNum = LeftNum + 1

   /// Search to the right, filling along the way.
   ucInLine = 1

   while(ucInLine = 1)
     MAPi_Draw(RightNum, Y, ObjectType)
     RightNum = RightNum + 1
     
     if (RightNum > MAPWIDTH-1)
		 InLine = 0
	 else
		 if (MAP_TileIs(RightNum,y) = MT_EMPTY)
			 InLine = 1
		 endif
	 endif
     //ucInLine = (ucRight > MAPWIDTH-1) ? 0 : (MAP_TileIs(ucRight,y) == MT_EMPTY)
   endwhile

   RightNum = RightNum - 1

   /// Fill the top and bottom.
	for i = LeftNum to RightNum
  
		if (Y > 0 and (MAP_TileIs(i, y-1) = MT_EMPTY))
			MAPi_FloodFill(i, Y - 1, ObjectType)
		endif

		if (Y < MAPHEIGHT-1 and (MAP_TileIs(i, Y+1) = MT_EMPTY))
			MAPi_FloodFill(i, Y + 1, ObjectType)
		endif
	next i
	
ENDFUNCTION

///****************************************************************************
/// This function adds doors to our map based on the type of map we've 
/// generated. Essentially, we want the entrance and exit to a room to be
/// fairly far apart to force the player to navigate our maze.
///****************************************************************************
FUNCTION MAPi_AddDoor(Direction as INTEGER, Entrance as INTEGER)
    // If our entry door is to be on the top, scan left to right, top to bottom for a spot
    // to add it.
    if (Direction = D_UP)
        for j = 0 to MAPHEIGHT
            for i = 0 to MAPWIDTH
                if ((MAP_TileIs(i, j) = MT_WALL_TOP) or (MAP_TileIs(i, j) = MT_WALL_MID))
                    if (Entrance = TRUE)
                        objEntrance.X = i+GLB_RandomNum(3, 7)
                        objEntrance.Y = j
                        objEntrance.ObjectType = DOOR
                    else
                        objExit.X = i+GLB_RandomNum(3,7)
                        objExit.Y = j
                        objExit.ObjectType = DOOR
                    endif
                    
                    return
                endif       
            next i
        next j
	endif

    // If our door is to be on the bottom, start in the lower right hand corner, and count
    // right to left, bottom to top.
    if (Direction = D_DOWN)
        for j = (MAPHEIGHT-1) to 0
            for i = (MAPWIDTH-1) to 0
                if ((MAP_TileIs(i, j) = MT_WALL_TOP) or (MAP_TileIs(i, j) = MT_WALL_MID))
                    if (Entrance = TRUE)
                        objEntrance.X = i-GLB_RandomNum(1,4)
                        objEntrance.Y = j
                        objEntrance.ObjectType = DOOR
                    else
                        objExit.X = i-GLB_RandomNum(1,4)
                        objExit.Y = j
                        objExit.ObjectType = DOOR
                    endif

                    return
                endif
            next i
        next j
    endif
    
    // If our door is to be on the right, start in the lower right hand corner, and count
    // bottom to top, right to left.
    if (Direction = D_RIGHT)
        for i = (MAPWIDTH-1) to 0
            for j = (MAPHEIGHT-1) to 0
                if((MAP_TileIs(i, j) = MT_WALL_TOP) or (MAP_TileIs(i, j) = MT_WALL_MID))
                    if (Entrance = TRUE)
                        objEntrance.X = i
                        objEntrance.Y = j-GLB_RandomNum(3,6)
                        objEntrance.ObjectType = DOOR
                    else
                        objExit.X = i
                        objExit.Y = j-GLB_RandomNum(3,6)
                        objExit.ObjectType = DOOR
                    endif
                    
                    return
                endif
            next j
        next i
    endif

    // If our door is to be on the left, start in the lower left hand corner, and count
    // bottom to top, left to right.
    if (Direction = D_LEFT)
        for i = 0 to MAPWIDTH
            for j = (MAPHEIGHT-1) to 0
                if ((MAP_TileIs(i, j) = WALL_TOP) or (MAP_TileIs(i, j) = MT_WALL_MID))
                    if (Entrance = TRUE)
                        objEntrance.X = i
                        objEntrance.Y = j-GLB_RandomNum(2,4)
                        objEntrance.ObjectType = DOOR
                    else
                        objExit.X = i
                        objExit.Y = j-GLB_RandomNum(2,4)
                        objExit.ObjectType = DOOR
                    endif
                
                    return
                endif
            next j
        next i
    endif
ENDFUNCTION


///****************************************************************************
/// This function adds obstacles to our map based on how many we want. The idea
/// is that we randomly sprinkle obstacles around our map.
/// FIXME - this funtion needs to be made more robust to allow for more functionality.
///****************************************************************************
FUNCTION AddObstacles(Number as INTEGER)
	
    // First, clear out our old obstacles.
    for i = 0 to MAX_OBSTACLES
        objObstacles[i].X = 0
        objObstacles[i].Y = 0
        objObstacles[i].ObjectType = EMPTY
    next i

    // Now, populate a new set of random obstacles, up to the number requested.
    // FIXME - Right now, obstacles can block a narrow path, ensure space on the
    //         sides exists.
    if (Number <= MAX_OBSTACLES)
        for i = 0 to Number
            objObstacles[i].X = GLB_RandomNum(0, MAPWIDTH)
            objObstacles[i].Y = GLB_RandomNum(0, MAPHEIGHT)

            while not(MAP_TileIs(objObstacles[i].X, objObstacles[i].Y) = MT_FLOOR)
                objObstacles[i].X = GLB_RandomNum(0, MAPWIDTH)
                objObstacles[i].Y = GLB_RandomNum(0, MAPHEIGHT)
            endwhile

            objObstacles[i].ObjectType = WALL_SINGLE
        next i
    endif
ENDFUNCTION


///****************************************************************************
/// This function adds items to our map based on how many we want. The idea
/// is that we randomly sprinkle items around our map.
/// FIXME - This function doesn't work...items are 1's hot notation.
///****************************************************************************
FUNCTION AddItems(Number as INTEGER)
    // First, clear out our old obstacles.
    for i = 0 to MAX_OBSTACLES
        objItems[i].X = 0
        objItems[i].Y = 0
        objItems[i].ObjectType = EMPTY
    next i

    // Now, populate a new set of random obstacles, up to the number requested.
    if (Number < MAX_OBSTACLES)
        for i = 0 to Number
            objItems[i].X = GLB_RandomNum(0, MAPWIDTH)
            objItems[i].Y = GLB_RandomNum(0, MAPHEIGHT)

            while not(MAP_TileIs(objItems[i].X, objItems[i].Y) = MT_FLOOR)
                objItems[i].X = GLB_RandomNum(0, MAPWIDTH)
                objItems[i].Y = GLB_RandomNum(0, MAPHEIGHT)
            endwhile

            objItems[i].ObjectType = EMPTY
        next i
    endif
ENDFUNCTION
