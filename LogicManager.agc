#include "Player.agc"
//#include "Input.agc"
#include "Map.agc"
#include "Player.agc"
//#include "Enemy.agc"


// Allows the Logic Manager class to access our sprite tiles
//#include "data/sprites.inc"

// Player sprite related defines
#constant PLAYER_SPRITE       0
#constant PLAYER_IDLE         0
#constant PLAYER_RUN1         1
#constant PLAYER_RUN2         0
#constant PLAYER_RUN3         2
#constant PLAYER_RUN4         0
#constant PLAYER_RUN_FRAMES   4

// Enemy sprite related defines
#constant ENEMY1_SPRITE       1
#constant ENEMY1_IDLE         3
#constant ENEMY1_RUN1         4
#constant ENEMY1_RUN2         3
#constant ENEMY1_RUN3         5
#constant ENEMY1_RUN4         3
#constant ENEMY_RUN_FRAMES    4

// This just defines how long we delay on each frame to achieve "smooth" animation
#constant FRAME_COUNTER       2

// This defines a delay counter to prevent the Logic Manager from processing 
// too quickly, and having everything run too fast.
#constant LOGIC_DELAY         3

// Logic related defines
#constant MAX_PLAYER_VELOCITY 3
#constant LOGIC_PLAYER_DELAY  3


// These variables are used to animate the player
global PlayerRunFrame as INTEGER
global PlayerRun as INTEGER[PLAYER_RUN_FRAMES]

// These variables are used to animate the enemies.
global EnemyRunFrame as INTEGER
global EnemyRun as INTEGER[ENEMY_RUN_FRAMES]

// These variables are used to control the Logic Manager class itself.
global Running as INTEGER
global ExitReached as INTEGER

// This variable helps us space our frames out
global Delay as INTEGER


///****************************************************************************
/// Simply initializes all of our Logic related variables to a default state.
///****************************************************************************
FUNCTION LGC_Init()
    Running = FALSE
    ExitReached = FALSE

	// FIXME - this will need to be changed to AGK specifics
    // Set our Uzebox specific sprite structures to sensible defaults.
    //sprites[PLAYER_SPRITE].tileIndex = PLAYER_IDLE;
    //sprites[PLAYER_SPRITE].x = OFF_SCREEN;
    //sprites[PLAYER_SPRITE].y = OFF_SCREEN;
    //sprites[PLAYER_SPRITE].flags = 0U;

    //sprites[ENEMY1_SPRITE].tileIndex - ENEMY1_IDLE;
    //sprites[ENEMY1_SPRITE].x = OFF_SCREEN;
    //sprites[ENEMY1_SPRITE].y = OFF_SCREEN;    
    //sprites[ENEMY1_SPRITE].flags = 0U;

    // Now set up our player animation variables
    PlayerRunFrame = PLAYER_IDLE
    PlayerRun[0] = PLAYER_RUN1
    PlayerRun[1] = PLAYER_RUN2
    PlayerRun[2] = PLAYER_RUN3
    PlayerRun[3] = PLAYER_RUN4

    EnemyRunFrame = ENEMY1_IDLE
    EnemyRun[0]   = ENEMY1_RUN1
    EnemyRun[1]   = ENEMY1_RUN2
    EnemyRun[2]   = ENEMY1_RUN3
    EnemyRun[3]   = ENEMY1_RUN4

    // Put our player next to the entry door. This is somewhat of a hack,
    // because the map must first be generated for this to work, and that
    // is outside the responsibility of the logic manager class.
    PLY_SetCoordinate(SetPlayerStartLocation())

    // FIXME - this isn't what we want to do, just for testing purposes
    NME_SetCoordinate(SetPlayerStartLocation())
ENDFUNCTION


///****************************************************************************
/// This function handles, sequentially, all of the things the logic manager
/// class is tasked with handling. This includes checking input during gameply,
/// managing player state, doing player collision detection, and drawing 
/// the player.
///****************************************************************************
FUNCTION LGC_ManageLogic()
    Delay as INTEGER = 0
        
    if((Delay = LOGIC_DELAY) and (Running = TRUE))
        ProcessInput()
		ProcessPlayerState()
        ProcessUpdatePlayer()
        DrawPlayer()
        DrawEnemies()
        Delay = 0
    endif
    
    Delay = Delay + 1
ENDFUNCTION


///****************************************************************************
/// Simple outside getter to see if the player is at the exit door.
///****************************************************************************
FUNCTION LGC_ExitReached()
	ReturnValue as INTEGER
    ReturnValue = ExitReached
ENDFUNCTION ReturnValue


///****************************************************************************
/// Outside setter function that will enable the processing of the logic
/// manager's functionality.
///****************************************************************************
FUNCTION LGC_Start()
    Running = TRUE
ENDFUNCTION


///****************************************************************************
/// Outside setter function that will disable the processing of the logic
/// manager's functionality.
///****************************************************************************
FUNCTION LGC_Stop()
    Running = FALSE
ENDFUNCTION


///****************************************************************************
/// This function looks at what button the player is pressing, and then sets up
/// the direction and speed with which the player wants to move. Keep in mind
/// we don't actually move at all yet, just get ready to do so.
///****************************************************************************
FUNCTION ProcessInput()

    // FIXME - Pressing diagonal directions currently just makes the player run
    //         slowly. We need to handle this by just keeping them going in the
    //         same direction they were, without allowing them to travel in a
    //         diagonal direction.
	
	
	// If the player hits attack, then stop them, and update their state.
	// Also, destructively break out of this function so we don't let the player
	// move during an attack. We'll see if this is a good idea or not...
	if((INPUT_GetButton(IN_A) = TRUE) or (PLY_GetState() = PLAYER_ATTACKING))
		PLY_SetVelocity(0)
		PLY_SetDirection(D_NONE)
		PLY_SetState(PLAYER_ATTACKING)
		return
	endif
	
    // If the player presses up...
    if(INPUT_GetButton(IN_UP) = TRUE)
    //...and we were going up before...
        if(PLY_GetDirection() = D_UP)
        // then speed up!
            if(PLY_GetVelocity() < MAX_PLAYER_VELOCITY)
                Vel as INTEGER
                Vel = PLY_GetVelocity()
                Vel = Vel + 1
                PLY_SetVelocity(Vel)
            endif
        else
        //...otherwise, start going up.
            PLY_SetDirection(D_UP)
            PLY_SetVelocity(1)
        endif
    endif
    
    // If the player presses left...
    if(INPUT_GetButton(IN_LEFT) = TRUE)
    //...and we were going left before...
        if(PLY_GetDirection() = D_LEFT)
        // then speed up!
            if(PLY_GetVelocity() < MAX_PLAYER_VELOCITY)
                Vel = PLY_GetVelocity()
                Vel = Vel + 1
                PLY_SetVelocity(Vel)
            endif
        else
        //...otherwise start going left.
            PLY_SetDirection(D_LEFT)
            PLY_SetVelocity(1)
        endif
    endif
    
    // If the player presses right...
    if(INPUT_GetButton(IN_RIGHT) = TRUE)
    //...and we were going right before...
        if(PLY_GetDirection() = D_RIGHT)
        // then speed up!
            if(PLY_GetVelocity() < MAX_PLAYER_VELOCITY)
                Vel = PLY_GetVelocity()
                Vel = Vel + 1
                PLY_SetVelocity(Vel)
            endif
        else
        //...otherwise start going right.
            PLY_SetDirection(D_RIGHT)
            PLY_SetVelocity(1)
        endif
    endif
    
    // If the player presses down...
    if(INPUT_GetButton(IN_DOWN) = TRUE)
    //...and we were going right before...
        if(PLY_GetDirection() = D_DOWN)
        // then speed up!
            if(PLY_GetVelocity() < MAX_PLAYER_VELOCITY)
                Vel = PLY_GetVelocity()
                Vel = Vel + 1
                PLY_SetVelocity(Vel)
            endif
        else
        //...otherwise start going down.
            PLY_SetDirection(D_DOWN)
            PLY_SetVelocity(1)
        endif
    endif
    
    // And finally, if the player isn't pushing anything,
    // then coast to a stop slowly.
    if(INPUT_GetButton(IN_NONE) = TRUE)
		Vel = PLY_GetVelocity()
        
        if(Vel = 0)
            PLY_SetDirection(D_NONE)
        else
			Vel = Vel - 1
            PLY_SetVelocity(Vel)
        endif
    endif
ENDFUNCTION


///****************************************************************************
/// This handles the state of the player, and decides what actions can be
/// performed based on that.
///****************************************************************************
FUNCTION ProcessPlayerState()
	
	select(PLY_GetState())
		case PLAYER_NORMAL
			Delay = Delay + 1
			if(Delay >=  LOGIC_PLAYER_DELAY)
				PLY_SetState(PLAYER_NORMAL)
			endif
			endcase
			
		case PLAYER_ATTACKING
			endcase
			
		case default
			endcase
	endselect
ENDFUNCTION


///****************************************************************************
/// This function only checks for collisions between the player and the map, 
/// and then adjusts the players position accordingly. This has nothing to do
/// with collisions between the player and enemies or items, only to do with
/// moving the player around the map correctly.
///****************************************************************************
FUNCTION ProcessUpdatePlayer()
    CurrentCoord as Coordinate
    CurrentCoord = PLY_GetCoordinate()
    
    NewCoord as Coordinate
    NewCoord = PLY_GetCoordinate()
    
    ExitDoor as MapObject
    ExitDoor = MAP_GetDoor(MT_EXIT)

    // Move our new coord right
    if(PLY_GetDirection() = D_RIGHT)
        NewCoord = GLB_MoveCoordinate(CurrentCoord, PLY_GetVelocity(), 0)
    endif
    
    // Move our new coord left.
    if(PLY_GetDirection() = D_LEFT)
        NewCoord = GLB_MoveCoordinate(CurrentCoord, -PLY_GetVelocity(), 0)
    endif

    // Move our new coord up.
    if(PLY_GetDirection() = D_UP)
        NewCoord = GLB_MoveCoordinate(CurrentCoord, 0, -PLY_GetVelocity())
    endif

    // Move our new coord down.
    if(PLY_GetDirection() = D_DOWN)
        NewCoord = GLB_MoveCoordinate(CurrentCoord, 0, PLY_GetVelocity())
    endif
    
    // Now, before we "correct" the movement based on collisions, let's check to
    // see if the player has reached the exit door.
    if(GLB_CoordinateToObjectCollision(NewCoord, ExitDoor) = TRUE)
        ExitReached = TRUE
        return
    endif
    
    // Now, we look at our new coord, and decide if it's inside a wall. If it is,
    // then we move it back outside the wall, and stop the player.
     
    // First check left.
    if((MAP_TileIs(CurrentCoord.BigX-1, CurrentCoord.BigY) > MT_FLOOR) or (MAP_TileIs(CurrentCoord.BigX-1, CurrentCoord.BigY) < MT_FLOOR))
        // If we've moved into a wall, then fix our location and stop us.
        if(NewCoord.BigX = (CurrentCoord.BigX-1))
            NewCoord.BigX = NewCoord.BigX + 1
            NewCoord.SmallX = 0
            
            PLY_SetDirection(D_NONE)
            PLY_SetVelocity(0)
		endif
    endif
    
    // Now check right.
    if((MAP_TileIs(CurrentCoord.BigX+1, CurrentCoord.BigY) > MT_FLOOR) or (MAP_TileIs(CurrentCoord.BigX+1, CurrentCoord.BigY) < MT_FLOOR))
        // If we've moved into a wall, then fix our location and stop us.
        if((NewCoord.BigX = CurrentCoord.BigX) and (NewCoord.SmallX > 0))
            NewCoord.SmallX = 0
            
            PLY_SetDirection(D_NONE)
            PLY_SetVelocity(0)
        endif
    endif
    
    // Now check up.
    if((MAP_TileIs(CurrentCoord.BigX, CurrentCoord.BigY-1) > MT_FLOOR) or (MAP_TileIs(CurrentCoord.BigX, CurrentCoord.BigY-1) < MT_FLOOR))
        // If we've moved into a wall, then fix our location and stop us.
        if(NewCoord.BigY = (CurrentCoord.BigY-1))
            NewCoord.BigY = NewCoord.BigY + 1
            NewCoord.SmallY = 0
            
            PLY_SetDirection(D_NONE)
            PLY_SetVelocity(0)
        endif
    endif
    
    // Now check down.
    if((MAP_TileIs(CurrentCoord.BigX, CurrentCoord.BigY+1) > MT_FLOOR) or (MAP_TileIs(CurrentCoord.BigX, CurrentCoord.BigY+1) < MT_FLOOR))
        // If we've moved into a wall, then fix our location and stop us.
        if((NewCoord.BigY = CurrentCoord.BigY) and (NewCoord.SmallY > 0))
            NewCoord.SmallY = 0
            
            PLY_SetDirection(D_NONE)
            PLY_SetVelocity(0)
        endif
    endif
    
    // And finally, update our player location    
    PLY_SetCoordinate(NewCoord)
ENDFUNCTION


///****************************************************************************
/// This is a helper function that will place the player next to the entrance
/// door. All it does is get the location of the entrance, and check the four
/// tiles adjacent to see if they're open floor.
///****************************************************************************
FUNCTION SetPlayerStartLocation()
	ReturnValue as Coordinate
	
    // Start by getting the location of our entry door.
    TempMapLocation as MapObject
    TempMapLocation = MAP_GetDoor(TRUE)
    
    TempCoord as Coordinate
    TempCoord.BigX = 0
    TempCoord.BigY = 0
    TempCoord.SmallX = 0
    TempCoord.SmallY = 0

    // Then find a spot next to the entry door that is open (aka is floor)
    if(MAP_TileIs(TempMapLocation.X+1, TempMapLocation.Y) = MT_FLOOR)
        TempCoord.BigX = TempMapLocation.X+1
        TempCoord.BigY = TempMapLocation.Y

        ReturnValue = TempCoord
        return
    endif

    if(MAP_TileIs(TempMapLocation.X-1, TempMapLocation.Y) = MT_FLOOR)
        TempCoord.BigX = TempMapLocation.X-1
        TempCoord.BigY = TempMapLocation.Y

        ReturnValue = TempCoord
        return
    endif

    if(MAP_TileIs(TempMapLocation.X, TempMapLocation.Y+1) = MT_FLOOR)
        TempCoord.BigX = TempMapLocation.X
        TempCoord.BigY = TempMapLocation.Y+1

		ReturnValue = TempCoord
        return
    endif

    if(MAP_TileIs(TempMapLocation.X, TempMapLocation.Y-1) = MT_FLOOR)
        TempCoord.BigX = TempMapLocation.X
        TempCoord.BigY = TempMapLocation.Y-1

        ReturnValue = TempCoord
        return
    endif

    ReturnValue = TempCoord

ENDFUNCTION ReturnValue


///****************************************************************************
/// All this helper function does is update the Player's sprite to the 
/// appropriate X/Y location on the screen, to reduce function clutter. It
/// also handles animation in the case of the player running.
///****************************************************************************
FUNCTION DrawPlayer()
    // This keeps track of which frame of animation the player sprite
    // is currently using.
    AnimDelay as INTEGER = 0

    // First get our players coordinate within the map (which is going to be 
    // centered in the middle of the screen.)
    TempCoord as Coordinate
    TempCoord = PLY_GetCoordinate()

	
    // Then put our player sprite where it is supposed to be, by offsetting it's
    // position the correct amount.
    // FIXME - Make this AGK specific
    //sprites[PLAYER_SPRITE].x = (((objTempCoord.ucBigX + MAP_X_OFFSET)*TILE_SIZE) + objTempCoord.scSmallX);
    //sprites[PLAYER_SPRITE].y = (((objTempCoord.ucBigY + MAP_Y_OFFSET)*TILE_SIZE) + objTempCoord.scSmallY);
    
    // If we're not moving, set our sprite to the idle state.
    if(PLY_GetDirection() = D_NONE)
        //sprites[PLAYER_SPRITE].tileIndex = PLAYER_IDLE;
    else
    //...otherwise, we're running, so let's animate.
        // Here we just try to determine which way to flip the player sprite.
        if(PLY_GetDirection() = D_LEFT)
            //sprites[PLAYER_SPRITE].flags = SPRITE_FLIP_X;
        endif

        if(PLY_GetDirection() = D_RIGHT)
            //sprites[PLAYER_SPRITE].flags = 0;
        endif

        // If we're running, we just loop our running animations.
        // This is just used to ensure we only change animation frames every
        // 150mS by delaying our animation updates.
        AnimDelay = AnimDelay + 1
        
        if(Mod(AnimDelay, FRAME_COUNTER) = 0)
            //sprites[PLAYER_SPRITE].tileIndex = ucPlayerRun[(ucPlayerRunFrame++)%(PLAYER_RUN_FRAMES)];        
        endif
    endif
ENDFUNCTION


FUNCTION DrawEnemies()
    // This keeps track of which frame of animation the player sprite
    // is currently using.
    AnimDelay as INTEGER = 0

    // First get our players coordinate within the map (which is going to be 
    // centered in the middle of the screen.)
    TempCoord as Coordinate
    TempCoord = NME_GetCoordinate()

    // Then put our player sprite where it is supposed to be, by offsetting it's
    // position the correct amount.
    // FIXME - Make this AGK specific
    //sprites[ENEMY1_SPRITE].x = (((objTempCoord.ucBigX + MAP_X_OFFSET)*TILE_SIZE) + objTempCoord.scSmallX);
    //sprites[ENEMY1_SPRITE].y = (((objTempCoord.ucBigY + MAP_Y_OFFSET)*TILE_SIZE) + objTempCoord.scSmallY);
    
    //sprites[ENEMY1_SPRITE].tileIndex = ENEMY1_IDLE;    


    /*
    // If we're not moving, set our sprite to the idle state.
    if(PLY_GetDirection() == NO_DIR)
    {
        sprites[PLAYER_SPRITE].tileIndex = PLAYER_IDLE;
    }
    else
    {//...otherwise, we're running, so let's animate.
        // Here we just try to determine which way to flip the player sprite.
        if(PLY_GetDirection() == LEFT)
        {
            sprites[PLAYER_SPRITE].flags = SPRITE_FLIP_X;
        }

        if(PLY_GetDirection() == RIGHT)
        {
            sprites[PLAYER_SPRITE].flags = 0;
        }

        // If we're running, we just loop our running animations.
        // This is just used to ensure we only change animation frames every
        // 150mS by delaying our animation updates.
        if((ucAnimDelay++)%(FRAME_COUNTER) == 0)
        {
            sprites[PLAYER_SPRITE].tileIndex = ucPlayerRun[(ucPlayerRunFrame++)%(PLAYER_RUN_FRAMES)];        
        }
    }

    */
ENDFUNCTION



