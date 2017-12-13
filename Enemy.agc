#include "Globals.agc"

#constant SKELETON	    = 0
#constant ENEMY_NONE	= 1

// All of the data related to ANY enemy is stored here.
TYPE Enemy
    //ENEMY_TYPE eType;
    Hitpoints as INTEGER
    Inventory as INTEGER
    Location as Coordinate
ENDTYPE

// Holds our classes Enemy data internally.
global SkeletonEnemy as Enemy

FUNCTION NME_Init()
    //objEnemy.eType = NONE;
    SkeletonEnemy.Hitpoints = 3
    SkeletonEnemy.Inventory = 0
    SkeletonEnemy.Location.BigX = 0
    SkeletonEnemy.Location.BigY = 0
    SkeletonEnemy.Location.SmallX = 0
    SkeletonEnemy.Location.SmallY = 0
ENDFUNCTION

FUNCTION NME_SetCoordinate(NewCoord as Coordinate)
    SkeletonEnemy.Location.BigX = NewCoord.BigX
    SkeletonEnemy.Location.BigY = NewCoord.BigY
    SkeletonEnemy.Location.SmallX = NewCoord.SmallX
    SkeletonEnemy.Location.SmallY = NewCoord.SmallY
ENDFUNCTION

FUNCTION NME_GetCoordinate()
    
ENDFUNCTION SkeletonEnemy.Location


