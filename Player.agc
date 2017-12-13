#include "Globals.agc"

// All of the data related to the player is stored  here.
TYPE Player
    HealthAndState as INTEGER
    TotalHealth as INTEGER
    TotalGold as INTEGER
    Inventory as INTEGER // BITFIELD...MASKABLE, ORABLE(16 items total)
    ScreensPassed as INTEGER
    VelocityAndDirection as INTEGER
    objLocation as Coordinate
ENDTYPE

// Holds our classes Player data internally.
global objPlayer as Player

///****************************************************************************
/// Simply initializes all of our Player related variables to a sane default
/// state. This is the same as performing a reset.
///****************************************************************************
FUNCTION PLY_Init()
    objPlayer.HealthAndState = 0x30
    objPlayer.TotalHealth = 3
    objPlayer.TotalGold = 0
    objPlayer.Inventory = 0
    objPlayer.ScreensPassed = 0
    objPlayer.VelocityAndDirection = D_NONE
    objPlayer.objLocation.BigX = 0
    objPlayer.objLocation.BigY = 0
    objPlayer.objLocation.SmallX = 0
    objPlayer.objLocation.SmallY = 0
ENDFUNCTION

///****************************************************************************
/// Checks to see if the player currently has an item in their inventory, by
/// using some tricky math that stores 16 items in a single unsigned int.
///****************************************************************************
FUNCTION PLY_IsCarrying(Item as INTEGER)
	result as INTEGER
    result = ((objPlayer.Inventory && Item) AND Item)
ENDFUNCTION result

///****************************************************************************
/// Simply adds gold to the player's stash.
///****************************************************************************
FUNCTION PLY_GiveGold(NewGold as INTEGER)
    objPlayer.TotalGold = objPlayer.TotalGold + NewGold

    // FIXME - Add a check here to see if the player has picked up more than X
    //         gold, and if so, increment their total health.	
ENDFUNCTION


///****************************************************************************
/// Adds health to the player's current health, and make's sure we don't
/// accidentally go over the total.
///****************************************************************************
FUNCTION PLY_GiveHealth(Health as INTEGER)
	/*
	unsigned char ucTempHealth = (objPlayer.ucHealthAndState & 0xF0) >> 4;

    if(ucTempHealth < (objPlayer.ucTotalHealth - ucHealth))
    {
        objPlayer.ucHealthAndState += (ucHealth << 4);
    }
    else
    {
        objPlayer.ucHealthAndState = (objPlayer.ucHealthAndState & 0x0F) + (objPlayer.ucTotalHealth << 4);
    }*/

ENDFUNCTION

///****************************************************************************
/// Takes away health from the player, being sure to not go into the negative.
///****************************************************************************
FUNCTION PLY_TakeHealth(Health as INTEGER)
	result as INTEGER
	/*
	unsigned char ucTempHealth = (objPlayer.ucHealthAndState & 0xF0) >> 4;

    if(ucHealth > ucTempHealth)
    {
        objPlayer.ucHealthAndState = (objPlayer.ucHealthAndState & 0x0F);
    }
    else
    {
        objPlayer.ucHealthAndState -= (ucHealth << 4);
    }
	 */
ENDFUNCTION result

///****************************************************************************
/// Increments the number of Screens the player has passed so far.
///****************************************************************************
FUNCTION PLY_PassedScreen()
    objPlayer.ScreensPassed = objPlayer.ScreensPassed + 1
ENDFUNCTION


///****************************************************************************
/// Simple getter for the current Player Health.
///****************************************************************************
FUNCTION PLY_GetHealth()
	result as INTEGER
    result = (objPlayer.HealthAndState && 0xF0) >> 4
ENDFUNCTION result

///****************************************************************************
/// Simple getter for the Total Player Health.
///****************************************************************************
FUNCTION PLY_GetTotalHealth()
	result as INTEGER
    result = objPlayer.TotalHealth
ENDFUNCTIOn result


///****************************************************************************
/// Simple getter for the number of screens passed.
///****************************************************************************
FUNCTION PLY_GetScreensPassed()
	result as INTEGER
    result = objPlayer.ScreensPassed
ENDFUNCTION result


///****************************************************************************
/// Getter for the Player's velocity that gets the value from a single 8 bit
/// variable along with the players direction.
///****************************************************************************
FUNCTION PLY_GetVelocity()
	result as INTEGER
    result = ((objPlayer.VelocityAndDirection && 0xF0) >> 4)
ENDFUNCTION result


///****************************************************************************
/// Setter for the Player's velocity that stores the value in a single 8 bit
/// variable along with the players direction.
///****************************************************************************
FUNCTION PLY_SetVelocity(Vel as INTEGER)
    objPlayer.VelocityAndDirection = objPlayer.VelocityAndDirection && 0x0F
    objPlayer.VelocityAndDirection = objPlayer.VelocityAndDirection || (Vel << 4)
ENDFUNCTION


///****************************************************************************
/// Getter for the Player's direction that gets the value from a single 8 bit
/// variable along with the players velocity.
///****************************************************************************
FUNCTION PLY_GetDirection()
	result as INTEGER
    result = objPlayer.VelocityAndDirection && 0x0F
ENDFUNCTION result


///****************************************************************************
/// Setter for the Player's direction that stores the value in a single 8 bit
/// variable along with the players velocity.
///****************************************************************************
FUNCTION PLY_SetDirection(Dir AS INTEGER)
    objPlayer.VelocityAndDirection = objPlayer.VelocityAndDirection && 0xF0
    objPlayer.VelocityAndDirection = objPlayer.VelocityAndDirection || Dir
ENDFUNCTION


///****************************************************************************
/// Simple getter for the player's current location.
///****************************************************************************
FUNCTION PLY_GetCoordinate()
	result as Coordinate
    result = objPlayer.objLocation
ENDFUNCTION result


///****************************************************************************
/// Simple setter for the players current location.
///****************************************************************************
FUNCTION PLY_SetCoordinate(objNewCoord as Coordinate)
    objPlayer.objLocation.BigX = objNewCoord.BigX
    objPlayer.objLocation.BigY = objNewCoord.BigY
    objPlayer.objLocation.SmallX = objNewCoord.SmallX
    objPlayer.objLocation.SmallY = objNewCoord.SmallY
ENDFUNCTIOn

///****************************************************************************
/// Simple getter for the player's current 'state'.
///****************************************************************************
FUNCTION PLY_GetState()
	result as INTEGER
	result = objPlayer.HealthAndState && 0x0F
ENDFUNCTION result

///****************************************************************************
/// Simple setter for the player's current 'state'.
///****************************************************************************
FUNCTION PLY_SetState(State as INTEGER)
	objPlayer.HealthAndState = (objPlayer.HealthAndState && 0xF0) + State
ENDFUNCTION
