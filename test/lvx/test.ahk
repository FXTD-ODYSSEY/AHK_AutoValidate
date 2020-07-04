#Include lvx.ahk

Gui, Add, ListView, w250 r8 vLV_Sample gEditLV Grid, Day|Activity
LV_Add("", "Monday") 
LV_Add("", "Tuesday") 
LV_Add("", "Wednesday", "pre-set value") 
LV_Add("", "Thursday") 
LV_Add("", "Friday") 
LV_Add("", "Saturday") 
LV_Add("", "Sunday") 
Loop, 3
	LV_ModifyCol(A_Index, "AutoHdr")

LVX_Setup("LV_Sample")
LVX_SetColour(3, 0xce0000, 0xffffff)

LVX_SetColour(2, 0x008000)
LVX_SetColour(5, 0xff8000, 0xffff00)
LVX_SetColour(6, 0xffffff, 0x0000bb)
LVX_SetColour(7, 0xffffff, 0x0000ff)

Gui, Show, , Test
Return

EditLV:
If A_GuiEvent = DoubleClick
	LVX_CellEdit()
Return

GuiClose:
ExitApp