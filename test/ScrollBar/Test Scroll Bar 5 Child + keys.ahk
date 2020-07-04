/*
AutoHotkey Version: 1.1.13.01
Language:   English
Platform:   Windows XP
Author:     JPV alias Oldman <myemail@nowhere.com>

Script Function:
				Test Scroll Bar 5 Child window with keyboard and wheel navigation
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
#Include *i Test Scroll Bar 5 Child + keys_h.ahk
#Include <__MessageLib>
#Include <__GuiScrollBarClass>

TraceLevel=0

gosub, Initialization
gosub, Main
return

Main:
if TraceLevel
	SendTrace(A_ThisLabel, "START")

WS_POPUP := 0x80000000
WS_CAPTION := 0xC00000
WS_CHILD := 0x40000000

; create and display main GUI
Gui, Main: New, +HwndmainGuiId +Resize, Main GUI
Gui, Main: Add, Text, Hidden, text1 main Gui
Gui, Main: Show, w500 h550

; create and display child GUI, with an option of setting the parent gui to main
Gui, Child: New, +ParentMain +Resize +HwndchildGuiId, Child GUI
Gui, Child:-%WS_CHILD% +%WS_POPUP%
Gui, Child: Add, Text, x10 y6 w486 h513 Hidden HwndText1Hwnd, this is child gui
	
if !ChildGui := new GuiScrollBarClass(ChildGuiId, Text1Hwnd)
{
	gosub, Termination
	ExitApp
}
	
if !ChildGui.Show("w400 h400",, SB_SCROLL_NORMAL)
{
	gosub, Termination
	ExitApp
}

WinMove, % "ahk_id " childGuiId,, 0, 0

; create and display child GUI in a Child Gui
Gui, Child2: New, +ParentChild +HwndchildGuiId2, Child2 GUI
Gui, Child2:-%WS_CHILD% +%WS_POPUP%
Gui, Child2: Add, Text, Y20,this is child2 gui
Gui, Child2: Add, Edit, W100 X10        vEdit2    , Text2
Gui, Child2: Add, Text, W25  X10        vText1    , Text
Gui, Child2: Add, Edit, W100 X+5 R5     vEdit3    , Text3 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
Gui, Child2: Add, Edit, W200 X30        vEdit4    , Text4
Gui, Child2: Add, Edit, W250 X25 R5     vEdit5    , Text5 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
Gui, Child2: Add, Edit, W300 X20        vEdit6    , Text6
Gui, Child2: Add, Edit, W100 X25 R5     vEdit7    , Text7 `na`nb`nc`nd`ne`nf`ng`nh`ni`nj`nk`nl
Gui, Child2: Add, Edit, W200 X30        vEdit8    , Text8
Gui, Child2: Add, UpDown, Range1-10     vUpDown1  , 5
Gui, Child2: Add, Checkbox,             vCheckBox1, Yes or no ?
Gui, Child2: Add, GroupBox, W200 H60              , Shipping
Gui, Child2: Add, Radio, Xp+10 Yp+20    vRadio1   , Wait before shipping.
Gui, Child2: Add, Radio,                vRadio2   , Do not Wait before shipping.
Gui, Child2: Add, Text, W80 X25 Y+15              , Choice color 1
Gui, Child2: Add, DropDownList, W60 X+5 vDropDownList1, Black|White|Red|Blue
Gui, Child2: Show, x0 y0 w500 h500

return

MainGuiClose:
MainGuiEscape:
MainButtonCancel:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	Gui, Main:Destroy
	
	gosub, Termination
	ExitApp

ChildGuiSize:
	if TraceLevel
		SendTrace(A_ThisLabel)
	
	if !IsObject(ChildGui)
		return
	
	if !ChildGui.UpdateScrollBars()
	{
		gosub, Termination
		ExitApp
	}
		
	return

Initialization:
	; Window style constants
	global WS_HSCROLL=0x100000, WS_VSCROLL=0x200000
	
	return

Termination:
	;----------------------------------------------------------------------------
	; Required to free the object
	;----------------------------------------------------------------------------
	if IsObject(ChildGui)
		ChildGui.StopScrollBars()
	
	ChildGui := ""
	return