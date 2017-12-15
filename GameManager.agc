#include "Globals.agc"
#include "LogicManager.agc"
#include "Player.agc"
#include "Enemy.agc"
#include "Input.agc"
#include "Map.agc"

// Include our tile data
// FIXME - AGK specific stuff
//#include "data/sprites.inc"
//#include "data/tileset.inc"


// Internal type definitions
#constant eGAME_INIT 		= 0
#constant eGAME_TITLESCREEN	= 1
#constant eGAME_CUTSCENE	= 2
#constant eGAME_PLAYLEVEL	= 3
#constant eGAME_GAMEOVER	= 4
#constant eGAME_CREDITS		= 5
#constant eGAME_UNKNOWN		= 6

// Private class variables
global CurrentState as INTEGER
global RequestedState as INTEGER

// Private strings for our game to be printed.
global sLife as STRING = "Life:"
global sKeys as STRING = "Keys:"
global sGold as STRING = "Gold:"
global sPressStart as STRING = "Press Start!"
global sTitle as STRING = "Escape From"
global sBensoft as STRING = ";2013 Bentricity"
global sTiles as STRING = "Oryx Lo-Fi, oryxdesignlab.com"
global sEnding1 as STRING = "Sorry this game is incomplete."
global sEnding2 as STRING = "Thanks for playing!"


FUNCTION GAME_ManageGame()

	Print (ScreenFPS())
	Print (CurrentState)
	
    if((RequestedState > CurrentState) or (RequestedState < CurrentState))
        ModeExit(CurrentState)
        ModeEntry(RequestedState)
        CurrentState = RequestedState
    endif

    select(CurrentState)
        case eGAME_INIT
            ProcessInit()
            endcase

        case eGAME_TITLESCREEN
            ProcessTitlescreen()
            endcase

        case eGAME_CUTSCENE
            ProcessCutscene()
            endcase

        case eGAME_PLAYLEVEL
            ProcessPlaylevel()
            endcase

        case eGAME_GAMEOVER
            ProcessGameover()
            endcase

        case eGAME_CREDITS
            ProcessCredits()
            endcase

        case eGAME_UNKNOWN
            endcase
    endselect
ENDFUNCTION


FUNCTION ModeEntry(State as INTEGER)
    select(State)
        case eGAME_INIT
            endcase

        case eGAME_TITLESCREEN
            GAME_DrawTitleScreen()
            endcase

        case eGAME_CUTSCENE
            endcase

        case eGAME_PLAYLEVEL
            MAP_InitializeMap()
            MAP_GenerateMap(GLB_RandomNum(0,2))
            MAP_DrawMyMap()
            MAP_DrawObjects()
            GAME_DrawHud()
            LGC_Init()
            LGC_Start()
            endcase

        case eGAME_GAMEOVER
            endcase

        case eGAME_CREDITS
            endcase

        case eGAME_UNKNOWN
            endcase

        case default
            endcase
    endselect
ENDFUNCTION


FUNCTION ModeExit(State as INTEGER)
    select(State)
        case eGAME_INIT
            endcase

        case eGAME_TITLESCREEN
            GAME_DrawBlankScreen()
            endcase

        case eGAME_CUTSCENE
            endcase

        case eGAME_PLAYLEVEL
            endcase

        case eGAME_GAMEOVER
            endcase

        case eGAME_CREDITS
            endcase

        case eGAME_UNKNOWN
            endcase

        case default
            endcase
    endselect
ENDFUNCTION


FUNCTION ProcessInit()
    //ClearVram()
    //SetTileTable(efd2_tiles)
    //SetSpritesTileTable(efd2_sprites)
    //SetSpriteVisibility(TRUE)
    PLY_Init()
    NME_Init()
    LGC_Init()
    LGC_Start()
    RequestedState = eGAME_TITLESCREEN
ENDFUNCTION

FUNCTION ProcessTitlescreen()
    Time as INTEGER = 0
    
    while((INPUT_GetButton(IN_START) > TRUE) and (INPUT_GetButton(IN_START) < TRUE))
        Time = TIME + 1
    endwhile
	// We seed our random number here, because it relies on the randomness of
	// the player pressing start after they've been to the title screen.
    SetRandomSeed(Time)
	
    if(INPUT_GetButton(IN_START) = TRUE)
        RequestedState = eGAME_PLAYLEVEL
    endif
ENDFUNCTION

FUNCTION ProcessCutscene()
	
ENDFUNCTION

FUNCTION ProcessPlaylevel()
    if(PLY_GetScreensPassed() = 5)
        RequestedState = eGAME_CREDITS
    else
        LGC_ManageLogic()
    
        if(LGC_ExitReached() = TRUE)
            MAP_InitializeMap()
	        MAP_GenerateMap(GLB_RandomNum(0,2))
	        MAP_DrawMyMap()
	        MAP_DrawObjects()

            GAME_ScreenPassed()
        endif
    endif
ENDFUNCTION

FUNCTION ProcessGameover()
	
ENDFUNCTION


FUNCTION ProcessCredits()
    GAMEi_ShowCredits()

    if(INPUT_GetButton(IN_START) = TRUE)
        RequestedState = eGAME_INIT
    endif
ENDFUNCTION


FUNCTION GAME_Init()
    CurrentState = eGAME_UNKNOWN
    RequestedState = eGAME_INIT
ENDFUNCTION


FUNCTION GAME_DrawBlankScreen()
	// FIXME - Put in AGK specific call
    //Fill(0,0, 30, 28, 0)
ENDFUNCTION


FUNCTION GAME_ScreenPassed()
    LGC_Init()
    LGC_Start()
    PLY_PassedScreen()
ENDFUNCTION


FUNCTION GAME_DrawHud()
    // Draw HUD text
    GLB_PrintString(2, 2, sLife)
    GLB_PrintString(2, 3, sKeys)
    GLB_PrintString(2, 4, sGold)
    
    // Draw player hearts.
    for i = 0 to PLY_GetTotalHealth()
        if(i <= PLY_GetHealth())
            SetTile(7+i, 2, 43)
        else
            SetTile(7+i, 2+i, 44)
        endif
    next i

    GAMEi_DrawStaticHUD()
ENDFUNCTION


///****************************************************************************
/// This function draws the part of the HUD that are static and down't change
/// include the border, and player portrait.
///****************************************************************************
FUNCTION GAMEi_DrawStaticHUD()
    // Draw the vertical lines.
    for i=2 to 27
        SetTile(1,i,HUD_VERT)
    next i
        
    for i=2 to 27
        SetTile(27,i,HUD_VERT)
    next i
    
    // Now draw the corners.
    SetTile(1,  1, HUD_CORNER)
    SetTile(27, 1, HUD_CORNER)
    SetTile(1,  5, HUD_CORNER)
    SetTile(27, 5, HUD_CORNER)
    SetTile(1, 26, HUD_CORNER)
    SetTile(27,26, HUD_CORNER)
    
    // Draw the horizontal lines.
    for i=2 to 27
        SetTile(i,1,HUD_HORIZ)
    next i
    
    for i=2 to 27
        SetTile(i,5,HUD_HORIZ)
    next i
    
    for i=2 to 27
        SetTile(i,26,HUD_HORIZ)
    next i

    // And now the hero portrait.
    // FIXME - replace with AGK equivalent
    //DrawMap2(24,2, hero_portrait)
ENDFUNCTION


FUNCTION GAMEi_ShowCredits()
    GAME_DrawBlankScreen()
    GLB_PrintString(0, 14, sEnding1)
    GLB_PrintString(5, 15, sEnding2)
ENDFUNCTION


///****************************************************************************
/// This function draws our titlescreen, which is completely static.
///****************************************************************************
FUNCTION GAME_DrawTitleScreen()
#constant VERT_START 4

    //FadeIn(4, FALSE)
    
    // First, a box.
    for i = 1 to 29
        SetTile(i, VERT_START - 2, 41)
        SetTile(i, VERT_START + 9, 41)
    next i
    
    SetTile(0, VERT_START-2, 40)
    SetTile(29, VERT_START-2, 40)
    SetTile(0, VERT_START+9, 40)
    SetTile(29, VERT_START+9, 40)
    
    for i = VERT_START-1 to VERT_START
        SetTile(0, i, 42)
        SetTile(29, i, 42)
    next i

    // Put up our text...
    GLB_PrintString(5, VERT_START+1, sTitle)
    GLB_PrintString(8, VERT_START+14, sPressStart)
    GLB_PrintString(0, 25, sBensoft)
    GLB_PrintString(0, 26, sTiles)
    //DrawMap2(24,25, creative_commons);
    
    // And now draw the "big" stuff.
    
    // First, the D
    SetTile(1,VERT_START,32)
    SetTile(2,VERT_START,32)
    SetTile(3,VERT_START,33)
    for i = VERT_START+1 to (VERT_START+5)
        SetTile(1,i,32)
        SetTile(3,i,32)
    next i
    
    SetTile(1,VERT_START+5,32)
    SetTile(2,VERT_START+5,32)
    SetTile(3,VERT_START+5,35)
    
    // now the u
    SetTile(5,VERT_START+3,32)
    SetTile(7,VERT_START+3,32)
    SetTile(5,VERT_START+4,32)
    SetTile(7,VERT_START+4,32)
    SetTile(5,VERT_START+5,36)
    SetTile(6,VERT_START+5,32)
    SetTile(7,VERT_START+5,32)
    
    // now the n's
    SetTile(9,VERT_START+3, 33)
    SetTile(10,VERT_START+3, 32)
    SetTile(11,VERT_START+3, 33)
    SetTile(9,VERT_START+4,32)
    SetTile(9,VERT_START+5,32)
    SetTile(11,VERT_START+4,32)
    SetTile(11,VERT_START+5,32)
    SetTile(25,VERT_START+3, 33)
    SetTile(26,VERT_START+3, 32)
    SetTile(27,VERT_START+3, 33)
    SetTile(25,VERT_START+4,32)
    SetTile(25,VERT_START+5,32)
    SetTile(27,VERT_START+4,32)
    SetTile(27,VERT_START+5,32)
    
    // now the g
    SetTile(13, VERT_START+3, 34)
    SetTile(14, VERT_START+3, 32)
    SetTile(15, VERT_START+3, 32)
    SetTile(13, VERT_START+4, 32)
    SetTile(15, VERT_START+4, 32)
    SetTile(13, VERT_START+5, 36)
    SetTile(14, VERT_START+5, 32)
    SetTile(15, VERT_START+5, 32)
    SetTile(15, VERT_START+6, 32)
    SetTile(13, VERT_START+7, 36)
    SetTile(14, VERT_START+7, 32)
    SetTile(15, VERT_START+7, 35)
    
    // now e
    SetTile(17,VERT_START+3,32)
    SetTile(18,VERT_START+3,32)
    SetTile(19,VERT_START+3,35)
    SetTile(17,VERT_START+4,32)
    SetTile(18,VERT_START+4,33)
    SetTile(17,VERT_START+5,32)
    SetTile(18,VERT_START+5,32)
    SetTile(19,VERT_START+5,35)
    
    
    // finally, the o
    SetTile(21,VERT_START+3,34)
    SetTile(22,VERT_START+3,32)
    SetTile(23,VERT_START+3,33)
    SetTile(21,VERT_START+4,32)
    SetTile(23,VERT_START+4,32)
    SetTile(21,VERT_START+5,36)
    SetTile(22,VERT_START+5,32)
    SetTile(23,VERT_START+5,35)
ENDFUNCTION
