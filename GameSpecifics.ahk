;------------------------------------------------------------------------------------------------------------------------------------------------------------
; Minecraft
;------------------------------------------------------------------------------------------------------------------------------------------------------------
$*XButton1::
    WinGet, activeProcess, ProcessName, A	; Get the active windows name
    SplitPath, activeProcess,,,, programName	; Split the string to just the program name
    SendLevel, 3
    if (programName = "javaw") {
        Send, 3
    } else {
        Send, {XButton1}
    }
    return

$*XButton2::
    WinGet, activeProcess, ProcessName, A	; Get the active windows name
    SplitPath, activeProcess,,,, programName	; Split the string to just the program name
    SendLevel, 3
    if (programName = "javaw") {
        Send, 1
    } else {
        Send, {XButton2}
    }
    Return

; $^/::
;     WinGet, activeProcess, ProcessName, A	; Get the active windows name
;     SplitPath, activeProcess,,,, programName	; Split the string to just the program name
;     SendLevel, 3        
;     if (programName = "javaw") {
;         Send, c
;         Sleep, 100
;         Send, {Up}
;         Return
;     } else {
;         Send, ^/
;     }
;     Return

; F3 & Volume_Up::
;     WinGet, activeProcess, ProcessName, A	; Get the active windows name
;     SplitPath, activeProcess,,,, programName	; Split the string to just the program name
;     SendLevel, 3
;     MsgBox, test
;     if (programName = "javaw") {
;         MsgBox, java
;         Send, {F3}
;     } else {
;         Send, {F3}{Volume_Up}
;     }
;     Return