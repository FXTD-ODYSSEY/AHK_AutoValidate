setworkingdir, %a_scriptdir%

List=slist.txt
ifnotexist,%List%
   {
   fileappend,Score;Name;# of Episodes; how many Seen?;Short Descrition`r`n,%List%
   }

Gui,2:default
Gui,2:Font, s12

Gui,2:Add, ListView,+grid x6 y27  +hscroll altsubmit h180 w490  vMLV2A gMLV2B, Rank|Name|EPS|Seen?|Desc.
LV_ModifyCol(1,56)
LV_ModifyCol(2,96)
LV_ModifyCol(3,56)
LV_ModifyCol(4,64)
LV_ModifyCol(5,200)

gosub,filllistview
Gui,2:add,button,x6 y217 w140 h20 gCADD    ,New        ;button after LV
Gui,2:add,button,x356 y217 w140 h20 gCDELETE ,Delete

Gui, Add, Edit, x156 y217 w190 h20 +readonly vtotal,%I%

Gui,2: Show,,%name1%
Return


FillListview:
Gui,2:default
Gui,2:submit,nohide
Gui,2:ListView,MLV2A
LVX_Setup("MLV2A")
LV_Delete()
I=0

loop,read,%List%
  {
  I++
  BX1= ; score
  BX2= ; name
  BX3= ; episodes
  BX4= ; seen?
  BX5= ; desc.
  stringsplit,BX,A_LoopReadLine,`;,
  LV_Add("",BX1,BX2,BX3,BX4,BX5)
  Gui,2:submit,nohide
}
guicontrol,,total,%I%
return
;-----------------------------------------------------------------

MLV2B:
Gui,2:ListView,MLV2A
     RN:=LV_GetNext("C")
     RF:=LV_GetNext("F")
     GC:=LV_GetCount()
     if (RF="" OR RF=0)
     return

If A_GuiEvent = Normal
   {
   LV_GetText(C1,A_EventInfo,1)
   LV_GetText(C2,A_EventInfo,2)
   Return
   }


If A_GuiEvent = RightClick
   {
   LV_GetText(C1,A_EventInfo,1)
   LV_GetText(C2,A_EventInfo,2)
   LVX_CellEdit()
   sleep,200
   LV_GetText(C11,A_EventInfo,1)
   LV_GetText(C12,A_EventInfo,2)
   goto,CEDIT
   Return
   }


If A_GuiEvent = DoubleClick
   {
   LV_GetText(C21,A_EventInfo,1)
   LV_GetText(C22,A_EventInfo,2)
   ifexist,%C22%
       run,%C22%
   Return
   }
return


2GuiClose:
ExitApp


CEDIT:
Gui,2:submit,nohide
  FileRead, fcx, %List%
  FileDelete, %List%
  StringReplace, fcx, fcx, %C1%`;%C2%,%C11%`;%C12%
  FileAppend, %fcx%, %List%
  Gosub, FillListView
  Gui,2:submit,nohide
return


;------------------ ADD --------------------------------------
CADD:
Gui,2:submit,nohide
Gui,11:Font,  S10 CDefault , FixedSys

Gui,11:Add,Text, x1  y5   w80  h20, Rank:
Gui,11:Add,Edit, x80 y5   w96 h20 vA31,

Gui,11:Add,Text, x1  y30  w80  h20, Name:
Gui,11:Add,Edit, x80 y30  w256 h20 vA32,

Gui,11:Add,Text, x1  y55   w80  h20, Episodes:
Gui,11:Add,Edit, x80 y55   w96 h20 vA33,

Gui,11:Add,Text, x1  y80  w80  h20, Seen?:
Gui,11:Add,Edit, x80 y80  w96 h20 vA34,

Gui,11:Add,Text, x1  y105   w80  h20, Desc.:
Gui,11:Add,Edit, x80 y105   w256 h20 vA35,

Gui,11:Add, Button,, OK
Gui,11:Show,, NEW11
GuiControl,11:Focus,A31
return
;---------------------------------------
11GuiClose:
11GuiEscape:
Gui,11:Destroy
return

11ButtonOK:
Gui,11:submit
FILEAPPEND,`n%A31%`;%A32%`;%A33%`;%A34%`;%A35%`r`n,%List%
Gui,11: Destroy
gosub,FillListview
return
;----------------------------------------------




;------------------ DELETEMULTIPLE Lines in file F4 ------------------
CDELETE:
C1x=
RF = 0
RFL =
Loop
   {
   RF:=LV_GetNext(RF)
   if RF=0
      break
   RFL = %RF%|%RFL%
   LV_GetText(C1_Temp, RF, 2)
   C1x = %C1x%`n%C1_Temp%
  }

if C1x !=
  {
   MsgBox, 4, ,Do you really want to permenatly delete:`n%C1x% ?
   IfMsgBox,No
      Return
   Else
     {

      Loop, parse, RFL, |
             {
             LV_Delete(A_LoopField)
             }

     filedelete,%List%
     Loop % LV_GetCount()
            {
            BX1=
            BX2=
            BX3=
            BX4=
            BX5=
            LV_GetText(BX1,A_INDEX,1)
            LV_GetText(BX2,A_INDEX,2)
            LV_GetText(BX3,A_INDEX,3)
            LV_GetText(BX4,A_INDEX,4)
            LV_GetText(BX5,A_INDEX,5)
            fileappend,%BX1%;%BX2%;%BX3%;%BX4%;%BX5%`r`n,%List%
            }
       }

  }
gosub,filllistview
return
;------------------ END DELETE ------------------------------------





;====================== 1.03b  ESC ENTER NumpadEnter ===============================================================
/*
        Title: LVX Library

        Row colouring and cell editing functions for ListView controls.

        Remarks:
            Cell editing code adapted from Michas <http://www.autohotkey.com/forum/viewtopic.php?t=19929>;
            row colouring by evl <http://www.autohotkey.com/forum/viewtopic.php?t=9266>.
            Many thanks to them for providing the code base of these functions!

        License:
            - Version 1.03b by Titan <https://ahknet.autohotkey.com/~Titan/#lvx>
            - zlib License <https://ahknet.autohotkey.com/~Titan/zlib.txt>
*/

/*

        Function: LVX_Setup
            Initalization function for the LVX library. Must be called before all other functions.

        Parameters:
            name - associated variable name (or Hwnd) of ListView control to setup for colouring and cell editing.

*/
LVX_Setup(name) {
    global lvx
    If name is xdigit
        h = %name%
    Else GuiControlGet, h, Hwnd, %name%
    VarSetCapacity(lvx, 4 + 255 * 9, 0)
    NumPut(h + 0, lvx)
    OnMessage(0x4e, "WM_NOTIFY")
    LVX_SetEditHotkeys() ; initialize default hotkeys
}

/*

        Function: LVX_CellEdit
            Makes the specified cell editable with an Edit control overlay.

        Parameters:
            r - (optional) row number (default: 1)
            c - (optional) column (default: 1)
            set - (optional) true to automatically set the cell to the new user-input value (default: true)

*/
LVX_CellEdit(set = true) {
    global lvx, lvxb
    static i = 1, z = 48, e, h, k = "Enter|Esc|NumpadEnter"
    If i
    {
        Gui, %A_Gui%:Add, Edit, Hwndh ve Hide
        h += i := 0
    }
    If r < 1
        r = %A_EventInfo%
    If !LV_GetNext()
        Return
    If !(A_Gui or r)
        Return
    l := NumGet(lvx)
  SendMessage, 4135, , , , ahk_id %l% ; LVM_GETTOPINDEX
  vti = %ErrorLevel%
  VarSetCapacity(xy, 16, 0)
  by = 0
  ControlGetPos, bx, by, , , , ahk_id %l%
  bh = 0
  bw = 0
  bpw = 0
  bp = 0
  SendMessage, 4136, , , , ahk_id %l% ; LVM_GETCOUNTPERPAGE
  Loop, %ErrorLevel% {
    cr = %A_Index%
        NumPut(cr - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
        SendMessage, 4152, vti + cr - 1, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
        If !bph
            bph := by - NumGet(xy, 4)
        by += bh := NumGet(xy, 12) - NumGet(xy, 4)
        If (LV_GetNext() - vti == cr)
            Break
    }
    cr--
    by -= bh - Ceil(bph / 2)
  VarSetCapacity(xy, 16, 0)
  CoordMode, Mouse, Relative
  MouseGetPos, mx
  Loop, % LV_GetCount("Col") {
        cc = %A_Index%
        NumPut(cc - 1, xy, 4), NumPut(2, xy) ; LVIR_LABEL
        SendMessage, 4152, cr, &xy, , ahk_id %l% ; LVM_GETSUBITEMRECT
        bx += bw := NumGet(xy, 8) - NumGet(xy, 0)
        If !bpw
            bpw := NumGet(xy, 0)
        If (mx <= bx)
            Break
    }
    bx -= bw - bpw
    LV_GetText(t, cr + 1, cc)
    GuiControl, , e, %t%
    GuiControl, Move, e, x%bx% y%by% w%bw% h%bh%
    GuiControl, Show, e
    GuiControl, Focus, e
    VarSetCapacity(g, z, 0)
    NumPut(z, g)
    LVX_SetEditHotkeys(~1, h)
    Loop {
        DllCall("GetGUIThreadInfo", "UInt", 0, "Str", g)
        If (lvxb or NumGet(g, 12) != h)
            Break
        Sleep, 100
    }
    GuiControlGet, t, , e
    If (set and lvxb != 2)
        LVX_SetText(t, cr + 1, cc)
    GuiControl, Hide, e
    Return, lvxb == 2 ? "" : t
}

_lvxc:
lvxb++
_lvxb:
lvxb++
LVX_SetEditHotkeys(~1, -1)
Return

LVX_SetText(text, row = 1, col = 1) {
    global lvx
    l := NumGet(lvx)
    row--
    VarSetCapacity(d, 60, 0)
    SendMessage, 4141, row, &d, , ahk_id %l%  ; LVM_GETITEMTEXT
    NumPut(col - 1, d, 8)
    NumPut(&text, d, 20)
    SendMessage, 4142, row, &d, , ahk_id %l% ; LVM_SETITEMTEXT
}

LVX_SetEditHotkeys(enter = "Enter,NumpadEnter", esc = "Esc") {
    global lvx, lvxb
    static h1, h0
    If (enter == ~1) {
        If esc > 0
        {
            s = On
            lvxb = 0
            Hotkey, IfWinNotActive, ahk_id %esc%
        }
        Else s = Off
        Loop, Parse, h1, `,
            Hotkey, %A_LoopField%, _lvxb, %s%
        Loop, Parse, h0, `,
            Hotkey, %A_LoopField%, _lvxc, %s%
        Hotkey, IfWinActive
        Return
    }
    If enter !=
        h1 = %enter%
    If esc !=
        h0 = %esc%
}

/*

        Function: LVX_SetColour
            Set the background and/or text colour of a specific row on a ListView control.

        Parameters:
            index - row index (1-based)
            back - (optional) background row colour, must be hex code in RGB format (default: 0xffffff)
            text - (optional) similar to above, except for font colour (default: 0x000000)

        Remarks:
            Sorting will not affect coloured rows.

*/
LVX_SetColour(index, back = 0xffffff, text = 0x000000) {
    global lvx
    a := (index - 1) * 9 + 5
    NumPut(LVX_RevBGR(text) + 0, lvx, a)
    If !back
        back = 0x010101 ; since we can't use null
    NumPut(LVX_RevBGR(back) + 0, lvx, a + 4)
    h := NumGet(lvx)
    WinSet, Redraw, , ahk_id %h%
}

/*

        Function: LVX_RevBGR
            Helper function for internal use. Converts RGB to BGR.

        Parameters:
            i - BGR hex code

*/
LVX_RevBGR(i) {
    Return, (i & 0xff) << 16 | (i & 0xffff) >> 8 << 8 | i >> 16
}

/*
        Function: LVX_Notify
            Handler for WM_NOTIFY events on ListView controls. Do not use this function.
*/
LVX_Notify(wParam, lParam, msg) {
    global lvx
    If (NumGet(lParam + 0) == NumGet(lvx) and NumGet(lParam + 8, 0, "Int") == -12) {
        st := NumGet(lParam + 12)
        If st = 1
            Return, 0x20
        Else If (st == 0x10001) {
            a := NumGet(lParam + 36) * 9 + 9
            If NumGet(lvx, a)
        NumPut(NumGet(lvx, a - 4), lParam + 48), NumPut(NumGet(lvx, a), lParam + 52)
        }
    }
}


WM_NOTIFY(wParam, lParam, msg, hwnd) {
    ; if you have your own WM_NOTIFY function you will need to merge the following three lines:
    global lvx
    If (NumGet(lParam + 0) == NumGet(lvx))
        Return, LVX_Notify(wParam, lParam, msg)
}

;====================================== END FUNCTION ==================================================