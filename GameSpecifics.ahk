;------------------------------------------------------------------------------------------------------------------------------------------------------------
; Mouse Buttons
;------------------------------------------------------------------------------------------------------------------------------------------------------------
$*XButton1::
    WinGet, activeProcess, ProcessName, A	; Get the active windows name
    SplitPath, activeProcess,,,, programName	; Split the string to just the program name
    SendLevel, 3
    OutputDebug, %programName% 
    switch programName {
        case "javaw":                   Send, 3
        case "ApplicationFrameHost":    Send, 3
        case "starwarsjedifallenorder": Send, Z
        default:                        Send, {XButton1}
    }
    Return

$*XButton2::
    WinGet, activeProcess, ProcessName, A	; Get the active windows name
    SplitPath, activeProcess,,,, programName	; Split the string to just the program name
    SendLevel, 3
    OutputDebug, %programName% 
    switch programName {
        case "javaw":                   Send, 1
        case "ApplicationFrameHost":    Send, 1
        case "starwarsjedifallenorder": Send, 1
        default:                        Send, {XButton2}
    }
    Return