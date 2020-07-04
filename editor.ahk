/*
AutoHotkey Version: 1.1.13.01
Language:   English
Platform:   Windows XP
Author:     JPV alias Oldman <myemail@nowhere.com>

Script Function:
				Test Scroll Bar 1 with keyboard and wheel navigation
*/

#SingleInstance force
#NoEnv            ; Recommended for performance and compatibility with future AutoHotkey releases.
if !A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}
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
global Enum_ProgramMessage := {1000: "Unknown error (%s)."
		, 1001: "File does not exist`n%s."
		, 1002: "%s array is missing."
		, 1003: "Your operating system (%s) is no longer supported by this AutoHotkey version %s."
		, 1004: "It is possible that the script is not fully operational on your AutoHotkey version %s.`nDo you want to continue anyway ?"
		, 1006: "%s array is empty."
		, 1007: "SysGet command failed for %s(%s)."
		, 1008: "%s coordinates (%s,%s) are outside the screen area."
		, 1009: "Gui handle parameter is missing."
		, 1010: "The control number (%s) is invalid."
		, 1011: "GetWindowInfo() failed due to LastError %s."
		, 1012: "The control list handle is empty."
		, 1013: "PostMessage, WM_QUIT to %s`nfailed due to error %s."
		, 1014: "Invalid ScrollBarSpeed parameter (%s). Must be between 1 and 4."
		, 1015: "SendMessage, WM_COPYDATA to %s`nfailed due to error %s - LastError %s."
		, 1016: "ScrollWindowEx() failed due to LastError %s."
		, 1017: "%s`ncannot be launched due to LastError %s."
		, 1018: "WinWait timed out failed for`n%s."
		, 1019: "GetScrollInfo(%s) failed due to LastError %s."
		, 1020: "SendMessage, WM_CLOSE to %s`nfailed due to error %s."}
#Include <__MessageLib>
#Include <__GuiScrollBarClass>

TraceLevel=0

gosub, Initialization
gosub, Main
return

Main:
	if TraceLevel
		SendTrace(A_ThisLabel, "START")
	
	GuiTitle := "Validate Editor"
	; Gui, Main:new, HwndMainHwnd, % GuiTitle
	Gui, Main:new, HwndMainHwnd +Resize, % GuiTitle

	Gui Add, GroupBox, x10 y6 w120 h205 HwndGrpHwnd, 效率软件
	Gui Add, CheckBox, x20 y23 w100 h25 +Checked vListary, Listary
	Gui Add, CheckBox, y+5 w100 h25 +Checked vQTTabBar, QTTabBar
	Gui Add, CheckBox, y+5 w100 h25 +Checked vDitto, Ditto
	Gui Add, CheckBox, y+5 w100 h25 vWGesture, WGesture
	Gui Add, CheckBox, y+5 w100 h25 vQuicker, Quicker
	Gui Add, CheckBox, y+5 w100 h25 vTencentDesktop, 腾讯桌面管理
	Gui Add, GroupBox, x135 y6 w120 h49, 代码编辑器
	Gui Add, CheckBox, x143 y24 w102 h23 +Checked vVScode, VScode
	Gui Add, GroupBox, x135 y66 w120 h80, 截取软件
	Gui Add, CheckBox, x143 y86 w107 h23 +Checked vSnipaste, Snipaste
	Gui Add, CheckBox, x143 y115 w107 h23 +Checked vScreenToGif, ScreenToGif
	Gui Add, GroupBox, x135 y153 w120 h58, 播放器
	Gui Add, CheckBox, x143 y176 w102 h23 +Checked vPotPlayer, Pot Player

	; Gui, Main:new, HwndMainHwnd +Resize +%WS_HSCROLL% +%WS_VSCROLL%, % GuiTitle
	; Gui, Font, s10, Verdana

	Gui, Add, Edit, W100 X10 HwndEdit1Hwnd vEdit1, Text1
	Gui, Add, Edit, W100 X10 vEdit2, Text2
	Gui, Add, Edit, W100 X10 vEdit3, Text3


	if !MainGui := new GuiScrollBarClass(MainHwnd)
	{
		gosub, Termination
		ExitApp
	}
	
	if !MainGui.Show(,,SB_SCROLL_FAST)			; centered
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
	
	MsgBox, % "Nothing1 is launched - " name
	
	if TraceLevel
		SendTrace(A_ThisLabel, name)
	
	return

MainButtonNothing2:
	GuiControlGet, name, Focus
	
	MsgBox, % "Nothing2 is launched - " name
	
	if TraceLevel
		SendTrace(A_ThisLabel, name)
	
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
