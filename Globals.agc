TYPE Coordinate
	SmallX AS INTEGER
	SmallY AS INTEGER
	BigX AS INTEGER
	BigY AS INTEGER
ENDTYPE

FUNCTION GLB_MoveCoordinate(coord as Coordinate, scX, scY)
	signed char scTempX = coord.scSmallX;
    signed char scTempY = coord.scSmallY;
    
    scTempX += scX;
    scTempY += scY;

    // If we've wrapped into the next tile..
    if(scTempX >= TILE_SIZE)
    {// then increment our big tile location.
        coord.ucBigX += 1U;
        coord.scSmallX = scTempX - TILE_SIZE;        
    }
    else
    {    
        if(scTempX < 0)
        {
            coord.ucBigX -= 1U;
            coord.scSmallX = TILE_SIZE + scTempX;
        }
        else
        {
            coord.scSmallX = scTempX;
        }
    }

    if(scTempY >= TILE_SIZE)
    {
        coord.ucBigY += 1U;
        coord.scSmallY = scTempY - TILE_SIZE;
    }
    else
    {
        if(scTempY < 0)
        {
            coord.ucBigY -= 1U;
            coord.scSmallY = TILE_SIZE + scTempY;
        }
        else
        {
            coord.scSmallY = scTempY;
        }
    }
    
    return coord;
ENDFUNCTIOn
