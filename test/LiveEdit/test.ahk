#NoEnv
SetBatchLines, -1
LV := "
(
1234567890|www.google.com|Row 1
2345678901|msdn.microsoft.com|Row 2
3456789012|www.autohotkey.com|Row 3
4567890123|de.autohotkey.com|Row 4
)"
; ----------------------------------------------------------------------------------------------------------------------
LVW := 610
Gui, Margin, 20, 20
Gui, Font, s10, Verdana
Gui, Add, CheckBox, h20 vCL gCommonListView Checked
   , % " In-cell editing for common ListView && parameter UseColWidth"
Gui, Add, ListView, -Readonly y+10 w%LVW% Grid r4 gMyListView hwndHLV1 vLV1
   , Column 1|Column 2|Column 3|Column 4|Column 5|Column 6|Column 7|Column 8|Column 9
Loop, Parse, LV, `n
{
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", F1, F2, F3)
   }
}
Loop, 3
   LV_ModifyCol(A_Index, "200")
Gui, Add, CheckBox, h20 vHL gHiddenCol1ListView Checked
   , % " In-cell editing for ListView with hidden column 1 && parameter BlankSubItem"
Gui, Add, ListView, xm y+10 w%LVW% -Readonly Grid r4 gMyListView hwndHLV2 vLV2
   , Column 1|Column 2|Column 3|Column 4|Column 5|Column 6|Column 7|Column 8|Column 9
Loop, Parse, LV, `n
{
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", "", F1, F2, F3)
   }
}
LV_ModifyCol(1, 0)
Loop, 3
   LV_ModifyCol(A_Index + 1, "200")
Gui, Show, , In-Cell ListView Editing with Doubleclick
LV_InCellEdit.OnMessage()
GoSub, CommonListView
Gosub, HiddenCol1ListView
Return
; ----------------------------------------------------------------------------------------------------------------------
GuiClose:
ExitApp
; ----------------------------------------------------------------------------------------------------------------------
CommonListView:
GuiControlGet, CL
If (CL) {
   If !(LV_InCellEdit.Attach(HLV1, ["UseColWidth"]))
      MsgBox, % "Registering HLV1 failed: " . ErrorLevel
} Else {
   LV_InCellEdit.Detach(HLV1)
}
Return
; ----------------------------------------------------------------------------------------------------------------------
HiddenCol1ListView:
GuiControlGet, HL
If (HL) {
   If !(LV_InCellEdit.Attach(HLV2, ["BlankSubItem"]))
      MsgBox, % "Registering HLV2 failed: " . ErrorLevel
} Else {
   LV_InCellEdit.Detach(HLV2)
}
Return
; ----------------------------------------------------------------------------------------------------------------------
MyListView:
Gui, ListView, %A_GuiControl%
if InStr(A_GuiEvent, "e", true) {
	; MsgBox % A_EventInfo
	LV_GetText(s, A_EventInfo, LV_InCellEdit.SITEM+1)
	ToolTip, % LV_InCellEdit.SITEM . ":" . s
}
Return