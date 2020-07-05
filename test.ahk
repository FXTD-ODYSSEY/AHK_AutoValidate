
; (
;     Send, {LControl Down}
;     Sleep, 328
;     Send, {c}
; )keykey

; msgbox % test
key := "{LWin down}" 
Send, %key%
key := "{e}" 
Send, %key%
key := "{LWin up}" 
Send, %key%
key := " 1272, 57, 0" 
Click, %key%