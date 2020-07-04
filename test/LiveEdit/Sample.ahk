; ======================================================================================================================
; AHK 1.1.05+
; ======================================================================================================================
#NoEnv
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include LiveEdit\LVEDIT.ahk
SetBatchLines, -1
LV := "
(
123|www.google.com|Row 1
147|msdn.microsoft.com|Row 2
234|www.autohotkey.com|Row 3
288|de.autohotkey.com|Row 4
)"
; ----------------------------------------------------------------------------------------------------------------------
Gui, Margin, 20, 20
Gui, Font, s10
Gui, Add, Text, , Common ListView
Gui, Add, ListView, xm y+5 w410 -Readonly Grid r6 gMyListView hwndHLV1, Col 1|Col 2|Col 3
Loop, Parse, LV, `n
{
   If (A_LoopField) {
      StringSplit, F, A_LoopField, |
      LV_Add("", F1, F2, F3)
   }
}
Loop, 3
   LV_ModifyCol(A_Index, "200")
Gui, Add, Text, , ListView with hidden Column 1
Gui, Add, ListView, xm y+5 w410 -Readonly Grid r6 gMyListView hwndHLV2, |Col 1|Col 2|Col 3
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
If !(LVEDIT_INIT(HLV1))
   MsgBox, %ErrorLevel%
If !(LVEDIT_INIT(HLV2, True))
   MsgBox, %ErrorLevel%
Gui, Show, , In-Cell ListView Editing with Doubleclick
Return
; ----------------------------------------------------------------------------------------------------------------------
GuiClose:
ExitApp
; ----------------------------------------------------------------------------------------------------------------------
MyListView:
Return