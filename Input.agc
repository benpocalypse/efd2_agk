#constant IN_NONE		0
#constant IN_UP			1
#constant IN_DOWN		2
#constant IN_LEFT		3
#constant IN_RIGHT		4
#constant IN_A			5
#constant IN_B			6
#constant IN_X			7
#constant IN_Y			8
#constant IN_L			9
#constant IN_R			10
#constant IN_SELECT		11
#constant IN_START		12
#constant IN_UNKNOWN	13


///****************************************************************************
/// This function is just a helper function that let's us abstract the reading
/// of the controllers a bit. In other words, it just makes things easier
/// elsewhere in our code.
///****************************************************************************
FUNCTION INPUT_GetButton(Button as INTEGER)
	ReturnJoy as INTEGER
	
	if (GetButtonPressed(1) = 1)
		ReturnJoy = IN_START
	endif
	
	if (GetButtonPressed(2) = 1)
		ReturnJoy = IN_A
	endif
	
	if(GetJoystickX() = -1)
		ReturnJoy = IN_LEFT
	endif
	
	if(GetJoystickX() = 1)
		ReturnJoy = IN_RIGHT
	endif
	
	if(GetJoystickY() = -1)
		ReturnJoy = IN_DOWN
	endif
	
	if(GetJoystickY() = 1)
		ReturnJoy = IN_UP
	endif
	
    /*
    if(eButton == (C_INPUT)IN_UP)
    {
        return ((uiJoy&BTN_UP) == BTN_UP);
    }
    if(eButton == (C_INPUT)IN_LEFT)
    {
        return ((uiJoy&BTN_LEFT) == BTN_LEFT);
    }
    if(eButton == (C_INPUT)IN_RIGHT)
    {
        return ((uiJoy&BTN_RIGHT) == BTN_RIGHT);
    } 
    if(eButton == (C_INPUT)IN_DOWN)
    {
        return ((uiJoy&BTN_DOWN) == BTN_DOWN);
    }
    if(eButton == (C_INPUT)IN_A)
    {
        return ((uiJoy&BTN_A) == BTN_A);
    }
    if(eButton == (C_INPUT)IN_B)
    {
        return ((uiJoy&BTN_B) == BTN_B);
    }
    if(eButton == (C_INPUT)IN_X)
    {
        return ((uiJoy&BTN_X) == BTN_X);
    }
    if(eButton == (C_INPUT)IN_Y)
    {
        return ((uiJoy&BTN_Y) == BTN_Y);
    }
    if(eButton == (C_INPUT)IN_SELECT)
    {
        return ((uiJoy&BTN_SELECT) == BTN_SELECT);
    }
    if(eButton == (C_INPUT)IN_START)
    {
        return ((uiJoy&BTN_START) == BTN_START);
    }

    if(eButton == (C_INPUT)IN_NONE)
    {
        return (uiJoy == 0);
    }
    */
    
ENDFUNCTION ReturnJoy
