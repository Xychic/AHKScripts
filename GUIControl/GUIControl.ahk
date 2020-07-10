#SingleInstance, force

arrName := []
arrMaxIndex := 0

Gui, 1:+Resize +MinSize +LastFound +Delimiter`n
Gui1HWND := WinExist()
Loop, read, %A_ScriptDir%/configTest.ahk
{   
    OutputDebug, %A_LoopReadLine%
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
        Gui, 1:Add, ListBox, xPos+100 gAction varrName%arrMaxIndex% w200 h60, one|two|three|four
    }

}
Gui, 1:Show
return

Action:
    Gui, 1:Submit ; or
    ; Gui, Submit, NoHide   ; if you don't want to hide the gui-window after an action
    max := arrName.MaxIndex()
    OutputDebug, arr: %max%, %arrMaxIndex%
    return


; Gui, 1:Add, Text, x+10, Hello

