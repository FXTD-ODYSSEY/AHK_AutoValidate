/*
AutoHotkey Version: 1.1.13.01
Language:   English
Platform:   Windows XP
Author:     JPV alias Oldman <myemail@nowhere.com>

Script Function:
				Test Scroll Bar 4 images without keyboard and wheel navigation
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
#Include *i Test Scroll Bar 4 images - keys_h.ahk
#Include <__MessageLib>
#Include <__GuiScrollBarClass>

TraceLevel=0

gosub, Initialization
gosub, Main
return

Main:
	if TraceLevel
		SendTrace(A_ThisLabel, "START")
	
	GuiTitle := "Test Scroll Bar 1 without navigation key"
	
;	Gui, Main:new, HwndMainHwnd, % GuiTitle
	Gui, Main:new, HwndMainHwnd +Resize, % GuiTitle
;	Gui, Main:new, HwndMainHwnd +Resize +%WS_HSCROLL% +%WS_VSCROLL%, % GuiTitle
;	Gui, Font, s10, Verdana

	Gui, Add, Picture, W300 H-1 X10 vPict1 gClickPict, angel_island.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict2 gClickPict, corsica_cliffs.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict3 gClickPict, british_columbia.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict4 gClickPict, corsica_water.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict5 gClickPict, carmel.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict6 gClickPict, lake_moraine.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict7 gClickPict, corsica_cliffs.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict8 gClickPict, Hiver.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict9 gClickPict, corsica_water.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict10 gClickPict, carmel.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict11 gClickPict, Hiver.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict12 gClickPict, british_columbia.jpg
	
	Gui, Add, Picture, W300 H-1 X10 vPict13 gClickPict, lake_moraine.jpg
	Gui, Add, Picture, W300 H-1 X+5 vPict14 gClickPict, angel_island.jpg

	if !MainGui := new GuiScrollBarClass(MainHwnd)
;	if !MainGui := new GuiScrollBarClass(MainHwnd, 2)
;	if !MainGui := new GuiScrollBarClass(MainHwnd, Edit1Hwnd)
	{
		gosub, Termination
		ExitApp
	}
	
	if !MainGui.Show()							; centered
;	if !MainGui.Show("X50 Y30")				; X50, Y30 discarded ==> centered
;	if !MainGui.Show("X+50 Y+30 Center")	; Right 50, Down 30, Center discarded
;	if !MainGui.Show("W1920 H1200")			; screen emulatation 1920x1200
;	if !MainGui.Show("W1280 H1024")			; screen emulatation 1280x1024
;	if !MainGui.Show("W1200 H800")			; screen emulatation 1200x800
;	if !MainGui.Show("W1024 H768")			; screen emulatation 1024x768
;	if !MainGui.Show("W640 H480")				; screen emulatation 640x480
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
	ExitApp

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

MainButtonNothing1:
	GuiControlGet, name, Focus
	
	MsgBox, % name
	
	if TraceLevel
		SendTrace(A_ThisLabel, name)
	
	return

MainButtonNothing2:
	GuiControlGet, name, Focus
	
	MsgBox, % name
	
	if TraceLevel
		SendTrace(A_ThisLabel, name)
	
	return

ClickPict:
	MouseGetPos,,,, ControlName
	MsgBox, % ControlName " - " A_GuiControl
	return

Initialization:
	; Window style constants
	global WS_HSCROLL=0x100000, WS_VSCROLL=0x200000
	
	return

Termination:
	;----------------------------------------------------------------------------
	; Required to free the object
	;----------------------------------------------------------------------------
	if IsObject(MainGui)
		MainGui.StopScrollBars()
	
	MainGui := ""
	return
