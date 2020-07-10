#SingleInstance, force

arrName := [1,2,3,4,5,6,7,8,9]
arrMaxIndex := 0
global arrName

For value, index in arrName
    OutputDebug arrName[%index%] %value%

Gui, 1:+Resize +MinSize +LastFound ; +Delimiter`n
Gui1HWND := WinExist()
Loop, read, %A_ScriptDir%/configTest.ahk
{   
    ; OutputDebug, %A_LoopReadLine%
    if RegExMatch(A_LoopReadLine, "^; .*$") {
        title := StrReplace(A_LoopReadLine, "; ")
        Gui, 1:Font, s14
        Gui, 1:Add, Text, y+5, %title%
        xPos := x
        yPos := y
    } else if (RegExMatch(A_LoopReadLine, "^[a-zA-z0-9_]*( ?):=( ?).*$")) {
        endPos := RegExMatch(A_LoopReadLine, "( ?):=( ?).*$")
        subTitle := "    " + SubStr(A_LoopReadLine, 1, endPos-1)
        Gui, 1:Font, s10
        Gui, 1:Add, Text, y+1, %subTitle%
        arrMaxIndex += 1
        arrName[%arrMaxIndex%] := 0
        ; Gui, Add, ComboBox, y+1, one|two|three|four, one
        Gui, 1:Add, ComboBox, y+1 gAction varrName%arrMaxIndex% w200 h60-, one|two|three|four||
    }

}
For value, index in arrName
    OutputDebug arrName[%index%] %value%
Gui, 1:Show
return

Action:
    ; Gui, 1:Submit ; or
    Gui, 1:Submit, NoHide   ; if you don't want to hide the gui-window after an action
    max := arrName.MaxIndex()
    ; MsgBox, % arrName
    For value, index in arrName
        OutputDebug arrName[%index%] %value% 

    return


; Gui, 1:Add, Text, x+10, Hello

