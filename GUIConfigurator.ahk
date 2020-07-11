#SingleInstance, force

dataArray := []
dataTypeArray := []
preTextArray := []
postTextArray := []
currentTab := 0
dataArraySize := 0


srcFile := A_ScriptDir "\config.ahk"
if (Not FileExist(srcFile)) {
    srcFile := A_ScriptDir "\configTemplate.ahk"
}


WIDTH := 520

Gui, 1:+Resize +MinSize +LastFound
Gui1HWND := WinExist()

Gui, 1:Add, Tab2, w500 vTab -wrap,

Loop, Read, %srcFile%
{   
    if RegExMatch(A_LoopReadLine, "^; .*$") {
        if (currentTab > 0) {
            Gui, 1:Add, Button, gAction xs+4 y+1 w245, Update
        }

        title := StrReplace(A_LoopReadLine, "; ")
        valueDict[%title%] := {}
        GuiControl,,Tab,%title%
        currentTab++
        Gui, 1:Tab, %currentTab%

    } else if (RegExMatch(A_LoopReadLine, "^[a-zA-z0-9_]*( ?):=( ?).*$")) {

        endPos := RegExMatch(A_LoopReadLine, "( ?):=( ?).*$")
        subTitle := SubStr(A_LoopReadLine, 1, endPos-1)
        Gui, 1:Font, s10
        Gui, 1:Add, Text, xs+4 y+1 w245,     %subTitle%

        dataArraySize++
        varName := "VAR" dataArraySize
        dataArray.Insert(dataArraySize, varName)

        if InStr(A_LoopReadLine, "(Bool)") {
            dataTypeArray.Insert(dataArraySize, "Bool")

            pos1 := InStr(A_LoopReadLine, ":=") + 2
            pos2 := InStr(A_LoopReadLine, "`;",, 0)
            preTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, 1, pos1))
            postTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, pos2-1))

            if InStr(A_LoopReadLine, "True") { 
                options := "True||False"
            } else {
                options := "True|False||"
            }
            Gui, 1:Add, ComboBox, x+2 v%varName% w245 h60-, %options%
            SendMessage % EM_SETREADONLY:=0xCF, 1,, Edit%dataArraySize%   ; Prevents user from typing in combobox

        } else if InStr(A_LoopReadLine, "(Str)") {
            dataTypeArray.Insert(dataArraySize, "Str")

            pos1 := InStr(A_LoopReadLine, """") + 1
            pos2 := InStr(A_LoopReadLine, """",, 0)
            currText := SubStr(A_LoopReadLine, pos1, pos2-pos1)
            preTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, 1, pos1-1))
            postTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, pos2))

            Gui, 1:Add, Edit, x+2 -wrap v%varName% w245 r1, %currText%


        } else if InStr(A_LoopReadLine, "(Int)") {
            dataTypeArray.Insert(dataArraySize, "Int")
            
            pos1 := InStr(A_LoopReadLine, ":=") + 2
            pos2 := InStr(A_LoopReadLine, "`;",, 0)
            currText := StrReplace(SubStr(A_LoopReadLine, pos1, pos2-pos1), A_Space)
            preTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, 1, pos1))
            postTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, pos2-1))

            Gui, 1:Add, Edit, x+2 -wrap Number Limit5 v%varName% w245 r1, %currText%


        } else if InStr(A_LoopReadLine, "(Array)") {
            dataTypeArray.Insert(dataArraySize, "Array")

            pos1 := InStr(A_LoopReadLine, "[") + 1
            pos2 := InStr(A_LoopReadLine, "]",, 0)
            currText := StrReplace(SubStr(A_LoopReadLine, pos1, pos2-pos1), """")
            preTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, 1, pos1-1))
            postTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, pos2))

            Gui, 1:Add, Edit, x+2 -wrap v%varName% w245 r1, %currText%


        } else {
            Gui, 1:Add, ComboBox, x+2 v%varName% w245 h60-, TODO||TODO2
        }

    }
}
Gui, 1:Add, Button, gAction xs+4 y+1 w245, Update

; Gui, 1:Show, w%WIDTH% , Configurator
return

Action:
    Gui, 1:Submit, NoHide   ; if you don't want to hide the gui-window after an action
    index := 1

    Loop, Read, %srcFile%, %A_ScriptDir%/config.tmp
    {
        if (index <= dataArraySize) {
            value := dataArray[index]
            valueType := dataTypeArray[index]
            pre := preTextArray[index]
            post := postTextArray[index]
        }
        if (InStr(A_LoopReadLine, pre)) {
            if (%value% = "") { ; If a box is left blank, fill with defualt values
                Switch valueType
                {
                    Case "Bool":
                        %value% := False
                        return
                    Case "Int":
                        %value% := 1
                }
            } else if (valueType = "Int" And %value% = 0) {
                %value% := 1
            }
            GuiControl,, %value%, % %value% ; Updates any blanks on the GUI

            textValue := %value%

            if (valueType = "Array") {
                textValue := StrReplace(textValue, A_Space)
                textValue := StrReplace(textValue, "," , """, """)
                if StrLen(textValue) {
                    textValue := """" textValue """"
                }
            }

            FileAppend, % pre textValue post "`n", %A_ScriptDir%/config.tmp
            index++
        } else {
            FileAppend, % A_LoopReadLine "`n", %A_ScriptDir%/config.tmp
        }
    }

    FileMove, %A_ScriptDir%/config.tmp, %A_ScriptDir%/config.ahk, 1
    reload
    return