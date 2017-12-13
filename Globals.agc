// Droppable items that the player can pick up to provide 
// temporary effects.
#constant HEALTH_POTION           1
#constant INVINCIBILITY_POTION    2
#constant INVISIBILITY_POTION     3
#constant GOLD                    4
#constant BOMB                    5

// Player states that they can be in. These might need to be in logicmanager.c though...
#constant PLAYER_NORMAL			0
#constant PLAYER_ATTACKING		1
#constant PLAYER_HIT			2
#constant PLAYER_DEAD			3

// Plyaer inventory related defines, a max of 16 in game items.
#constant CLOTH_ARMOR       0x0001
#constant LEATHER_ARMOR     0x0002
#constant CHAIN_ARMOR       0x0004
#constant PLATE_ARMOR       0x0008
#constant DAGGER            0x0010
#constant STEEL_SWORD       0x0020
#constant LONGSWORD         0x0040
#constant LIGHTSWORD        0x0080
//#constant XXX               0x0100
//#constant XXX               0x0200
//#constant XXX               0x0400
//#constant XXX               0x0800

// Defines for our tile types.
#constant EMPTY	      0
#constant FLOOR1      1
#constant FLOOR2      2
#constant FLOOR3      3
#constant DOOR		  4
#constant STAIRS      5
#constant TABLE       6
#constant SHELF       7
#constant BARREL      8
#constant WALL_UP     9
#constant WALL_DOWN   10
#constant WALL_LEFT   11
#constant WALL_TOP    12
#constant WALL_MIDDLE 13
#constant WALL_RIGHT  14
#constant WALL_SINGLE 15

#constant HUD_CORNER  40
#constant HUD_HORIZ   41
#constant HUD_VERT    42

// Collision detection defines
#constant TILE_SIZE		8

// Video related defines
#constant SCREEN_W        30
#constant SCREEN_H        28
#constant HUD_H           6
#constant MAP_X_OFFSET    3
#constant MAP_Y_OFFSET    7

// Directional defines
#constant D_UP			0
#constant D_DOWN		1
#constant D_LEFT		2
#constant D_RIGHT		3
#constant D_NONE	  	4

// Boolean constants
#constant TRUE			1
#constant FALSE			0

// Object type that holds a "thing" that will appear somewhere on the map.
TYPE MapObject
	X as INTEGER
	Y as INTEGER
	ObjectType as INTEGER
ENDTYPE

// Holds the X/Y coordinates of a player, enemy, or other object that
// need's pixel perfect accuracy
TYPE Coordinate
	SmallX AS INTEGER
	SmallY AS INTEGER
	BigX AS INTEGER
	BigY AS INTEGER
ENDTYPE


///****************************************************************************
/// Generates random numbers starting at and including ucMin up to and 
/// including ucMax, and returns the number.
///****************************************************************************
FUNCTION GLB_RandomNum(Min as INTEGER, Max as INTEGER)
	result as INTEGER 
	result = Mod(Min + Random(0, 255) , ((Max - Min)+1))
ENDFUNCTION result


FUNCTION GLB_MoveCoordinate(coord as Coordinate, scX as INTEGER, scY as INTEGER)
	scTempX AS INTEGER 
	scTempX = coord.SmallX
	scTempY AS INTEGER
	scTempY = coord.SmallY
	
	scTempX = scTempX + scX
	scTempY = scTempY + scY
	
	if (scTempX => TILE_SIZE)
		coord.BigX = coord.BigX + 1
		coord.SmallX = scTempX - TILE_SIZE
	else
		if (scTempX < 0)
			coord.BigX = coord.BigX - 1
			coord.SmallX = TILE_SIZE + scTempX
		else
			coord.SmallX = scTempX
		endif
	endif
	
	if (scTempY => TILE_SIZE)
		coord.BigY = coord.BigY + 1
		coord.SmallY = scTempY - TILE_SIZE
	else
		if (scTempY < 0)
			coord.BigY = coord.BigY - 1
			coord.SmallY = TILE_SIZE + scTempY
		else
			coord.SmallY = scTempY
		endif
	endif

ENDFUNCTION coord


///****************************************************************************
/// This function takes a COORDINATE and a MapObj and tests to see if they are
/// colliding. If they are, it returns true, otherwise, returns false.
///****************************************************************************
FUNCTION GLB_CoordinateToObjectCollision(coord as Coordinate , mapobj as MapObject )
	result as INTEGER = FALSE
	
    // First, we check to see if our coordinate and map object are close enough to 
    // merrit check the individual pixels of the coordinate and object.
    if((coord.BigX <= (mapobj.X+1)) AND (coord.BigX >= (mapobj.X-1)) AND (coord.BigY <= (mapobj.Y+1)) AND (coord.BigY >= (mapobj.Y-1)))
       
        // Now, generate actual X and Y coordinates before checking them.
        uiTX as INTEGER 
        uiTX = (coord.BigX * 8) + coord.SmallX + 4
        uiTY as INTEGER 
        uiTY = (coord.BigY * 8) + coord.SmallY + 4
        uiDX as INTEGER 
        uiDX = (mapobj.X * 8) + 4
        uiDY as INTEGER 
        uiDY = (mapobj.Y * 8) + 4
        
        // If the coordinate and the object are within 9-ish pixels, they're
        // colliding.
        if(((uiTX + 9) >= uiDX) AND (uiTX <= (uiDX + 9)) AND ((uiTY + 9) >= uiDY) AND (uiTY <= (uiDY + 9)))
            result = TRUE
        else
            result = FALSE
        endif
    else
        result = FALSE
    endif
    
ENDFUNCTION result

FUNCTION GLB_SetTile(x as INTEGER, y as INTEGER, t as INTEGER)
ENDFUNCTION

FUNCTION SetTile(a as INTEGER, b as INTEGER, c as INTEGER)
ENDFUNCTION

FUNCTION GLB_PrintString(a as INTEGER, b as INTEGER, c as STRING)
ENDFUNCTION
