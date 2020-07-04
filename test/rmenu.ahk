 #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, MyContextMenu, Add, AddTask,AddTask
Menu, MyContextMenu, Add, Modify, ModifyTask
Menu, MyContextMenu, Add, Remove, ContextClearRows

Button1 = Check All Items
Button2 = Return to Original Size ;the ClassNN of the control to show the tip over
Button3 = Shorten by (-5) ;the ClassNN of the control to show the tip over
Button4 = Increase by (+5) ;the ClassNN of the control to show the tip over
Button5 = Maximize Window Width ;the ClassNN of the control to show the tip over
Gui 2: Add, Checkbox, h20 w60 x13 y7
Gui 2: Add, dropdownlist, r10 h20 w150 x80 y7, Fields||A|B|C|D|E|F|G
Gui 2: Add, Combobox, r10 h20 w150 x275 y7, Create List for||Activity Type|Schedule With|Miscellaneous
Gui 2: Add, button, h20 w30 x518 y7, <<
Gui 2: Add, button, h20 w25 x548 y7, <
Gui 2: Add, button, h20 w25 x573 y7, >
Gui 2: Add, Button, h20 w30 x598 y7, >>
Gui 2: Add, Text, h20 w80 x12 y40 , Activity Type:
Gui 2: Add, Listview, h350 w616 x10 y60 +Grid checked vGuiContextMenu, Ck|Subtask|Quantity|Time|Directions|Web Page|Email
Gui 2: Add, Button, h20 w25 x500 y431, ^
Gui 2: Add, Button, h20 w25 x475 y431, v
Gui 2: Add, Button, h20 w70 x550 y431, Save
Gui 2:  -AlwaysOnTop +HwndGuiHwnd2 ;-Caption 
Gui 2: +Owner%Guihwnd3%
OnMessage(0x200,"WM_MOUSEMOVE")  ;Mouse over Buttons to Expand/Contract GUI   
;Gui,2:Default
;Gui,2:Listview
LV_ModifyCol(1,30), LV_ModifyCol(2,100), LV_ModifyCol(3,100), LV_ModifyCol(4,100)
Loop, Read, C:\GuiChoices4.txt
{
 StringSplit, Array,A_LoopReadLine, %A_Tab%
 LV_Add("","",Array1,Array2,Array3) ;Array3,Array4,Array5,Array6,Array7,Array8)
} 
;gosub, ShowinAddressList 
Gui 2: Show, h460 w640,Test.ahk
2GuiContextMenu:
Gui,2: Default
if (A_GuiEvent <> GuiContextMenu) and if (A_GuiEvent = "RightClick")

{
        Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
}
return
ContextClearRows:
Gui,2:Default
RowNumber = 0
Loop
{
   RowNumber := LV_GetNext(RowNumber -1)
   if not RowNumber
      break
   LV_Delete(RowNumber)
}
ControlGet, OutputVar1, List,, SysListView321, Test.ahk
Filedelete, C:\GuiChoices4.txt
FileAppend, %OutputVar1%, C:\GuiChoices4.txt
return
AddTask:
Gui,2:Default
   LV_Add("","New Task")
   ControlGet, OutputVar1, List,, SysListView321, Test.ahk
Filedelete, C:\GuiChoices4.txt
FileAppend, %OutputVar1%, C:\GuiChoices4.txt
return
;...
ModifyTask:
Gui,2:Default
   RN:=LV_GetNext("C")
   LV_Modify(RN,"", "", "NewContent")
   ControlGet, OutputVar1, List,, Test.ahk
Filedelete, C:\GuiChoices4.txt
FileAppend, %OutputVar1%, C:\GuiChoices4.txt
return
;~ ShowinAddressList:
;~ Gui,2:Default
;~ Gui,2:Listview
;~ LV_ModifyCol(1,30), LV_ModifyCol(2,100), LV_ModifyCol(3,100), LV_ModifyCol(4,100)
;~ Loop, Read, C:\GuiChoices4.txt
;~ {
 ;~ StringSplit, Array,A_LoopReadLine, %A_Tab%
 ;~ LV_Add("","",Array1,Array2,Array3) ;Array3,Array4,Array5,Array6,Array7,Array8)
;~ } 
;~ Return
 
WM_MOUSEMOVE()
{
 local CurrentControl
 MouseGetPos,,,, CurrentControl
 ToolTip % (CurrentControl = "") ? "" : %CurrentControl%
}
ExitApp