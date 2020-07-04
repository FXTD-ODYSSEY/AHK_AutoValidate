/*
AutoHotkey Version: 1.1.13.01
Language:   English
Platform:   Windows XP
Author:     JPV alias Oldman <myemail@nowhere.com>

Script Function:
				Test Scroll Bar 3 (2 Gui's) with keyboard and wheel navigation
*/

#SingleInstance force
#NoEnv            ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input    ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, -1
SetFormat, IntegerFast, D
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.
;------------------------------------------------------------------------------
; Required to leave in the hands subroutine to finish before any interruption,
; especially the 'GuiSize' window events.
;------------------------------------------------------------------------------
Critical

#Include <Stddef.1.1.12.0>
#Include *i Test Scroll Bar 3 (2 Gui's)_h.ahk
#Include <__MessageLib>
#Include <__GuiScrollBarClass>

TraceLevel=0

gosub, Initialization
gosub, Main
gosub, Main2
return

Main:
	if TraceLevel
		SendTrace(A_ThisLabel, "START")
	
	GuiTitle := "Test Scroll Bar 3A"
	
;	Gui, Main:new, HwndMainHwnd, % GuiTitle
	Gui, Main:new, HwndMainHwnd +Resize, % GuiTitle
;	Gui, Main:new, HwndMainHwnd +Resize +%WS_HSCROLL% +%WS_VSCROLL%, % GuiTitle
	Gui, Font, s10, Verdana
	
	Gui, Add, Edit,    W100 X-250 vEdit1 , Text1
	Gui, Add, Edit,    W250 X+5   vEdit2 , Text2
	Gui, Add, Edit, R5 W300 X-150 vEdit3 , Text3 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit4 , Text4
	Gui, Add, Edit, R5 W300 X-50  vEdit5 , Text5 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W270 X10   vEdit6 , Text6
	Gui, Add, Edit, R5 W300 X-50  vEdit7 , Text7 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit8 , Text8
	Gui, Add, Edit, R5 W200 X-150 vEdit9 , Text9 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit10, Text10
	Gui, Add, Edit, R5 W300 X-150 vEdit11, Text11 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit12, Text12
	Gui, Add, Edit, R5 W300 X-50  vEdit13, Text13 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-20  vEdit14, Text14
	Gui, Add, Edit, R5 W300 X-50  vEdit15, Text15 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit16, Text16
	Gui, Add, Edit, R5 W200 X-350 vEdit17, Text17 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-20  vEdit18, Text18
	Gui, Add, Edit, R5 W300 X-50  vEdit19, Text19 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X-100 vEdit20, Text20
	Gui, Add, Edit, R5 W200 X-150 vEdit21, Text21 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	
	Gui, Add, Button, H20 Default, Do Nothing
	Gui, Add, Button, H20 X+10   , Cancel

	if !MainGui := new GuiScrollBarClass(MainHwnd)
	{
		gosub, Termination
		ExitApp
	}
	
;	if !MainGui.Show(,,SB_SCROLL_FAST)			; centered
;	if !MainGui.Show(,,SB_SCROLL_NORMAL)		; centered
;	if !MainGui.Show(,,SB_SCROLL_SLOW)			; centered
;	if !MainGui.Show(,,SB_SCROLL_VERY_SLOW)	; centered
;	if !MainGui.Show("X50 Y30")					; X50, Y30 discarded ==> centered
;	if !MainGui.Show("X+50 Y+30 Center")		; Right 50, Down 30, Center discarded
;	if !MainGui.Show("W1920 H1200")				; screen emulatation 1920x1200
;	if !MainGui.Show("W1280 H1024")				; screen emulatation 1280x1024
;	if !MainGui.Show("W1200 H800")				; screen emulatation 1200x800
	if !MainGui.Show("W1024 H768",, SB_SCROLL_FAST)	; screen emulatation 1024x768
;	if !MainGui.Show("W640 H480")					; screen emulatation 640x480
	{
		gosub, Termination
		ExitApp
	}
	
	if TraceLevel
		SendTrace(A_ThisLabel, "END")
	
	return

MainGuiClose:
MainGuiEscape:
MainButtonCancel:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	Gui, Main:Destroy
	
	gosub, Termination
	
	if !IsObject(Main2Gui)
		ExitApp
	
	return

MainGuiSize:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	if !IsObject(MainGui)
		return
	
	if !MainGui.UpdateScrollBars()
	{
		gosub, Termination
		ExitApp
	}
	
	return

MainButtonDoNothing:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	return

Termination:
	;----------------------------------------------------------------------------
	; Required to free the object
	;----------------------------------------------------------------------------
	if IsObject(MainGui)
		MainGui.StopScrollBars()
	
	MainGui := ""
	return

Main2:
	if TraceLevel
		SendTrace(A_ThisLabel, "START")
	
	GuiTitle := "Test Scroll Bar 3B"
	
;	Gui, Main2:new, HwndMain2Hwnd, % GuiTitle
	Gui, Main2:new, HwndMain2Hwnd +Resize, % GuiTitle
;	Gui, Main2:new, HwndMain2Hwnd +Resize +%WS_HSCROLL% +%WS_VSCROLL%, % GuiTitle
;	Gui, Font, s10, Verdana

	Gui, Add, Edit,    W100 X10 vEdit1 , Text1
	Gui, Add, Edit,    W300 X+5 vEdit2 , Text2

	Gui, Add, Text,         X10 vText1 , Text
	Gui, Add, Edit, R5 W300 X+5 vEdit3 , Text3 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit4 , Text4
	Gui, Add, Edit, R5 W300 X25 vEdit5 , Text5 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X20 vEdit6 , Text6
	Gui, Add, Edit, R5 W300 X25 vEdit7 , Text7 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit8 , Text8
	Gui, Add, Edit, R5 W200 X35 vEdit9 , Text9 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit10, Text10
	Gui, Add, Edit, R5 W300 X35 vEdit11, Text11 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit12, Text12
	Gui, Add, Edit, R5 W300 X25 vEdit13, Text13 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X20 vEdit14, Text14
	Gui, Add, Edit, R5 W300 X25 vEdit15, Text15 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit16, Text16
	Gui, Add, Edit, R5 W200 X35 vEdit17, Text17 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X20 vEdit18, Text18
	Gui, Add, Edit, R5 W300 X25 vEdit19, Text19 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
	Gui, Add, Edit,    W300 X30 vEdit20, Text20
	Gui, Add, Edit, R5 W200 X35 vEdit21, Text21 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl

	Gui, Add, Button, H20 Default, &Do Nothing
	Gui, Add, Button, H20 X+10   , &Cancel

	if !Main2Gui := new GuiScrollBarClass(Main2Hwnd)
	{
		gosub, Termination2
		ExitApp
	}

;	if !Main2Gui.Show()								; centered
;	if !Main2Gui.Show("X50 Y30")					; X50, Y30 discarded ==> centered
;	if !Main2Gui.Show("X+50 Y+30 Center")		; Right 50, Down 30, Center discarded
;	if !Main2Gui.Show("W1920 H1200")				; screen emulatation 1920x1200
;	if !Main2Gui.Show("W1280 H1024")				; screen emulatation 1280x1024
;	if !Main2Gui.Show("W1200 H800")				; screen emulatation 1200x800
;	if !Main2Gui.Show("W1024 H768")				; screen emulatation 1024x768
	if !Main2Gui.Show("W640 H480 X+50 Y+50",, SB_SCROLL_VERY_SLOW)	; screen emulatation 640x480
	{
		gosub, Termination2
		ExitApp
	}

	if TraceLevel
		SendTrace(A_ThisLabel, "END")
	
	return

Main2GuiClose:
Main2GuiEscape:
Main2ButtonCancel:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	Gui, Main2:Destroy
	
	gosub, Termination2
	
	if !IsObject(MainGui)
		ExitApp
	
	return

Main2GuiSize:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	if !IsObject(Main2Gui)
		return
	
	if !Main2Gui.UpdateScrollBars()
	{
		gosub, Termination2
		ExitApp
	}
		
	return

Main2ButtonDoNothing:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	return

Termination2:
	;----------------------------------------------------------------------------
	; Required to free the object
	;----------------------------------------------------------------------------
	if IsObject(Main2Gui)
		Main2Gui.StopScrollBars()
	
	Main2Gui := ""
	return

Initialization:
	; Window style constants
	global WS_HSCROLL=0x100000, WS_VSCROLL=0x200000
	
	return
