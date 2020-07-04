#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.


Global ProgramTile := "校验编辑器"
Global CurrentFileName := "未命名"

;#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\LVEDIT.ahk


Menu, MyContextMenu, Add, 添加配置                   Ctrl + G, AddRow
Menu, MyContextMenu, Add, 删除选择                   Ctrl + D, ContextClearRows



; Create the sub-menus for the menu bar:
Menu, FileMenu, Add, 新建         Ctrl + N , FileNew
Menu, FileMenu, Add, 打开         Ctrl + O , FileOpen
Menu, FileMenu, Add, 保存         Ctrl + S , FileSave
Menu, FileMenu, Add, 另存为      Ctrl + Shift + S , FileSaveAs
Menu, FileMenu, Add  ; Separator line.
Menu, FileMenu, Add, 退出         Ctrl + Q , FileExit

Menu, EditMenu, Add, 打开当前文件             Ctrl + E, OpenCurrentFile
Menu, EditMenu, Add, 打开当前文件路径       Ctrl + Shift + E, OpenCurrentFileDir
Menu, EditMenu, Add  ; Separator line.
Menu, EditMenu, Add, 添加配置                   Ctrl + G, AddRow
Menu, EditMenu, Add, 删除选择                   Ctrl + D, ContextClearRows
Menu, EditMenu, Add  ; Separator line.
Menu, EditMenu, Add, 刷新                         F5, Refresh

Menu, ExecMenu, Add, 执行录制动作         Ctrl + R, RunMacro

Menu, HelpMenu, Add, 关于 , HelpAbout

; Create the menu bar by attaching the sub-menus to it:
Menu, MyMenuBar, Add, 文件, :FileMenu
Menu, MyMenuBar, Add, 编辑, :EditMenu
Menu, MyMenuBar, Add, 运行, :ExecMenu
Menu, MyMenuBar, Add, 帮助, :HelpMenu

; Attach the menu bar to the window:
Gui, Menu, MyMenuBar

; Create the main Edit control and display the window:
Gui, +Resize  ; Make the window resizable.
; Gui, Add, Edit, W100 X10 HwndEdit1Hwnd vEdit1, Text1


; Gui, Add, Edit, R20 vMyEdit
Gui, Add, Listview,  h350 w616 W600 R20 +Grid -Readonly vListWidget hwndHLV1, 序号|选项名称|校验规则|获取数据

gui, add, text, section vMacroLabel, 录制文件路径 :  ; Save this control's position and start a new section.
gui, add, edit, ys vMacroEdit ; Start a new column within this section.
gui, add, button, ys gMacroButton vMacroButton , 执行路径 (Ctrl + R)  ; Start a new column within this section.

; Gui, Add, Listview, h350 w616 W600 R20 +Grid -Readonly vListWidget2 hwndHLV2, 序号|选项名称|校验规则
LV_Add("",1,"1234")
LV_Add("",2,"12345")
LV_Add("",3,"123456")
LV_Add("",4,"1234567")
LV_Add("",5,"12345678")
If !(LVEDIT_INIT(HLV1,True))
   MsgBox, %ErrorLevel%


Gui, Show,,  %ProgramTile%  - *%CurrentFileName%

return

; --------------------------------
; NOTE 右键菜单功能
; --------------------------------

GuiContextMenu:  ; Launched in response to a right-click or press of the Apps key.
if (A_GuiControl != "ListWidget")  ; Display the menu only for clicks inside the ListView.
    return
; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
; because they provide correct coordinates even if the user pressed the Apps key:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

^G::
AddRow:
; Gui,2:Default
ControlGet, rowCount, List, Count, , % "ahk_id " . HLV1

LV_Add("",rowCount+1)
If !(LVEDIT_INIT(HLV1,True))
   MsgBox, %ErrorLevel%

;    ControlGet, OutputVar1, List,, SysListView321, Test.ahk
; Filedelete, C:\GuiChoices4.txt
; FileAppend, %OutputVar1%, C:\GuiChoices4.txt
return

^D::
ContextClearRows:

ControlGet, SelectedItems, List, Selected, , % "ahk_id " . HLV1
Sort, SelectedItems, R
Loop, Parse, SelectedItems, `n  ; Rows are delimited by linefeeds (`n).
{	
	RegExMatch(A_LoopField, "^\d+",row_id)
	LV_Delete(row_id)
}


; NOTE 重新调整序号
ControlGet, TotalCount , List, Count, , % "ahk_id " . HLV1

Loop %TotalCount% 
{
	; MsgBox, %A_Index%
	LV_Modify(A_Index,"",A_Index)
}

; TODO 更新配置文件

; ControlGet, OutputVar1, List,, SysListView321, Test.ahk
; Filedelete, C:\GuiChoices4.txt
; FileAppend, %OutputVar1%, C:\GuiChoices4.txt
return

; --------------------------------
; NOTE 文件菜单功能
; --------------------------------

^N::
FileNew:
CurrentFileName := "未命名"
Gui, Show,,  %ProgramTile%  - *%CurrentFileName%

; NOTE 删除全部
ControlGet, TotalCount , List, Count, , % "ahk_id " . HLV1

while(TotalCount>0)
{
	LV_Delete(TotalCount)
	TotalCount--
}
return



^O::
FileOpen:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, 3,, Open File, CSV 文件 (*.csv)
if not SelectedFileName  ; No file selected.
    return
Gosub FileRead
return



FileRead:  ; Caller has set the variable SelectedFileName for us.
FileRead, Data, %SelectedFileName%  ; Read the file's contents into the variable.
if ErrorLevel
{
    MsgBox Could not open "%SelectedFileName%".
    return
}

Gosub FileNew

Loop, Parse, Data, `n  ; Rows are delimited by linefeeds (`n).
{	
	data_list := StrSplit(A_LoopField, ",")
	data_list.RemoveAt(0)
	LV_Add("",A_Index,data_list*)
}

; GuiControl,, MainEdit, %MainEdit%  ; Put the text into the control.
CurrentFileName := SelectedFileName
Gui, Show,,  %ProgramTile%  - %CurrentFileName%
return


^S::
FileSave:
if not CurrentFileName or CurrentFileName == "未命名"   ; No filename selected yet, so do Save-As instead.
    Goto FileSaveAs
Gosub SaveCurrentFile
return

^+S::
FileSaveAs:
Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
FileSelectFile, SelectedFileName, S16,, 保存配置 , CSV 文件 (*.csv)

; NOTE 添加 csv 后缀
if not SelectedFileName  ; No file selected.
    return

if not RegExMatch(SelectedFileName,".csv$")
	SelectedFileName = %SelectedFileName%.csv

CurrentFileName := SelectedFileName
Gosub SaveCurrentFile
return

SaveCurrentFile:  ; Caller has ensured that CurrentFileName is not blank.

if FileExist(CurrentFileName)
{
    FileDelete %CurrentFileName%
    if ErrorLevel
    {
        MsgBox The attempt to overwrite "%CurrentFileName%" failed.
        return
    }
}
Gui, Show,,  %ProgramTile%  - %CurrentFileName%

ControlGet, TotalItems , List, , , % "ahk_id " . HLV1
TotalItems := StrReplace(TotalItems, "`t", ",")

GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
FileAppend, %TotalItems%, %CurrentFileName%  ; Save the contents to the file.
return

; --------------------------------
; NOTE 编辑菜单功能
; --------------------------------

OpenCurrentFile:
Run %SelectedFileName%
return

OpenCurrentFileDir:
Run %SelectedFileName%\..\
return

F5::
Refresh:
return

; --------------------------------
; NOTE 运行菜单功能
; --------------------------------


^R::
RunMacro:
MacroButton:

GuiControlGet, MacroPath,, MacroEdit 
; NOTE 如果没有设置则选择一个路径
if not FileExist(MacroPath)
{
	Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, MacroPath, S1,, 获取 AHK 录制文件, AHK 文件 (*.ahk)
	GuiControl,, MacroEdit, %MacroPath%
}

; TODO 检查是否是 Macro AHK 文件



; TODO 获取剪切板信息


return

; --------------------------------
; NOTE 帮助菜单功能
; --------------------------------

HelpAbout:
Gui, About:+owner1  ; Make the main window (Gui #1) the owner of the "about box".
Gui +Disabled  ; Disable main window.
Gui, About:Add, Text,, TimmyLiang 基于 AutoHotkey 开发  
Gui, About:Add, Text,, 本软件免费使用，严禁商用
Gui, About:Add, Text,, 联系: 820472580@qq.com
Gui, About:Add, Button,x60 w100 , OK
Gui, About:Show , , 声明
return

AboutButtonOK:  ; This section is used by the "about box" above.
AboutGuiClose:
AboutGuiEscape:
Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
Gui Destroy  ; Destroy the about box.
return

; --------------------------------
; NOTE 窗口功能
; --------------------------------

GuiDropFiles:  ; Support drag & drop.
Loop, Parse, A_GuiEvent, `n
{
    SelectedFileName := A_LoopField  ; Get the first file only (in case there's more than one).
    break
}
Gosub FileRead
return

GuiSize:
if (ErrorLevel = 1)  ; The window has been minimized. No action needed.
    return
; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
NewWidth := A_GuiWidth - 20
NewHeight := A_GuiHeight - 40
GuiControl, Move, ListWidget, W%NewWidth% H%NewHeight%
NewHeight := NewHeight + 10
YMacroEdit := NewHeight + 1
YMacroLabel := NewHeight + 5
XMacroButton := A_GuiWidth - 135
WMacroEdit := XMacroButton - 110
GuiControl, Move, MacroLabel , Y%YMacroLabel%
GuiControl, Move, MacroEdit , Y%YMacroEdit% W%WMacroEdit%
GuiControl, Move, MacroButton ,X%XMacroButton% Y%NewHeight% 

return

^Q::
FileExit:     ; User chose "Exit" from the File menu.
GuiClose:  ; User closed the window.
ExitApp