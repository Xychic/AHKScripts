#SingleInstance, force

arrName := []
tabVal := 0
arrMaxIndex := 0

WIDTH := 520

Gui, 1:+Resize +MinSize +LastFound ; +Delimiter`n
Gui1HWND := WinExist()

tabs = 3
Gui, 1:Add, Tab2, w500 vTab -wrap,

Loop, read, %A_ScriptDir%/configTest.ahk
{   
    ; OutputDebug, %A_LoopReadLine%
    if RegExMatch(A_LoopReadLine, "^; .*$") {
        if (tabVal > 0) {
            Gui, 1:Add, Button, gAction xs+4 y+1 w245, Update
        }

        title := StrReplace(A_LoopReadLine, "; ")
        valueDict[%title%] := {}
        GuiControl,,Tab,%title%
        tabVal++
        Gui, 1:Tab, %tabVal%

    } else if (RegExMatch(A_LoopReadLine, "^[a-zA-z0-9_]*( ?):=( ?).*$")) {

        endPos := RegExMatch(A_LoopReadLine, "( ?):=( ?).*$")
        subTitle := SubStr(A_LoopReadLine, 1, endPos-1)
        Gui, 1:Font, s10
        Gui, 1:Add, Text, xs+4 y+1 w245,     %subTitle%

        arrMaxIndex++
        varName := "VAR" arrMaxIndex
        arrname.Insert(arrMaxIndex, varName)

        if InStr(A_LoopReadLine, "(Bool)") {
            if InStr(A_LoopReadLine, "True") { 
                options := "True||False"
            } else {
                options := "True|False||"
            }
            Gui, 1:Add, ComboBox, x+2 v%varName% w245 h60-, %options%
        } else if InStr(A_LoopReadLine, "(Str)") {
            pos1 := InStr(A_LoopReadLine, """") + 1
            pos2 := InStr(A_LoopReadLine, """",, 0)
            currText := SubStr(A_LoopReadLine, pos1, pos2-pos1)

            Gui, 1:Add, Edit, x+2 -wrap v%varName% w245 r1, %currText%
        } else if InStr(A_LoopReadLine, "(Int)") {
            pos1 := InStr(A_LoopReadLine, ":=") + 2
            pos2 := InStr(A_LoopReadLine, "`;",, 0)
            currText := StrReplace(SubStr(A_LoopReadLine, pos1, pos2-pos1), A_Space, "")

            Gui, 1:Add, Edit, x+2 -wrap Number v%varName% w245 r1, %currText%
        } else if InStr(A_LoopReadLine, "(Array)") {
            pos1 := InStr(A_LoopReadLine, "[") + 1
            pos2 := InStr(A_LoopReadLine, "]",, 0)
            currText := StrReplace(SubStr(A_LoopReadLine, pos1, pos2-pos1), """", "")

            Gui, 1:Add, Edit, x+2 -wrap v%varName% w245 r1, %currText%
        } else {
            Gui, 1:Add, ComboBox, x+2 v%varName% w245 h60-, TODO||TODO2
        }

    }
}
Gui, 1:Add, Button, gAction xs+4 y+1 w245, Update

 
Gui, 1:Show, w%WIDTH% ,
return

Action:
    ; Gui, 1:Submit ; or
    Gui, 1:Submit, NoHide   ; if you don't want to hide the gui-window after an action
    Loop %arrMaxIndex%
    {
        a := arrName[A_Index]
        OutputDebug, % %a%
    }
    return

GuiClose:
    ExitApp
    return