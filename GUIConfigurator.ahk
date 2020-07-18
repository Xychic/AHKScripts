#SingleInstance, force

/*
Okie Dokie...
This is gonna be interesting...

First of all some back story:
As I don't want to hardcode variables to store every variable in the config file, I need a to store the data from the GUI in an array.
Simple, surely you just tell each item in the GUI that returns data to store it in a unique index in an array? Well, no.
As far as I can tell, there's no way to point the result at an index in an array. So what I do is horrible.

The layout:
It all starts with the variable `dataArray`. I hope it is clear from the name that this is ultimately where we will be accessing the data
in each GUI item from. The way we do it is not so straightforward. That array/list stores strings which refer to variable names. These
variable names are sequential (Eg. `var1`, `var2` etc) as they are generated automatically. When I need to access the data these variables
hold, I double deref them. Which means the full process to access the data in the GUI items is as follows:
    1. Get the index that is associated with that item
    2. Get the string stored in the array `dataArray`
    3. Deref that string to get the variable
    4. Deref that variable to get the actual data

Yup. Dynamically created variables is not a good idea (Don't lecture me) but after 7 hours of searching the forums, reading the docs, and 
programming many test files, this is the only solution I managed to get working. If anyone (for some reason) reads this (It'll most likely
be me), I hope it's out of curiosity or you've found the 'correct' way to do this and not that you are tring to edit it for your own use.

Now that should explain the first variable...
*/
dataArray := [] 
dataTypeArray := [] ; Stores the type desciptor for the config variables
preTextArray := []  ; Stores all the text before the variables values for reconstructing the config file
postTextArray := [] ; Same as above except the data after
currentTab := 0     ; Used to control which tab items get added to
dataArraySize := 0  ; The number of items in the array, corresponds to the number of variables in the config file

global srcFile := A_ScriptDir "\config.ahk"    ; Try and load the full config file
if (Not FileExist(srcFile)) {   ; If the config file doesn't exist, load the template
    srcFile := A_ScriptDir "\configTemplate.ahk"
}


Gui, 1:+Resize +MinSize +LastFound  ; Start making the GUI
Gui1HWND := WinExist()

Gui, 1:Add, Tab2, w500 vTab -wrap,  ; Setting attributes for the GUI

Loop, Read, %srcFile%   ; Read the config file line by line
{   

    if RegExMatch(A_LoopReadLine, "^; .*$") {   ; If the line starts with a comment, it is a heading descriptor TODO: make this more secure to allow other comments
        if (currentTab > 0) {   ; If we have a tab, we need to add a button on the bottom before we can start working on the next tab
            Gui, 1:Add, Button, gupdateConfig xs+4 y+1 w245, Update   ; Create the button with a call to `updateConfig` when pressed
        }
        title := StrReplace(A_LoopReadLine, "; ")   ; Remove the leading comment to get the tab name
        GuiControl,,Tab,%title%     ; Create the tab
        currentTab++    ; Increase the index to add items to the new tab
        Gui, 1:Tab, %currentTab%    ; Change to the new tab

    } else if (RegExMatch(A_LoopReadLine, "^[a-zA-z0-9_]*( ?):=( ?).*$")) {     ; If the line matches the RegEx for a variable declaration
        if InStr(A_LoopReadLine, "(Ignore)") {  ; If Ignore is in the line we don't configure the variable, so jump to the next line
            continue
        }

        endPos := RegExMatch(A_LoopReadLine, "( ?):=( ?).*$")   ; Find the position of the `:=` with or without a space either side
        subTitle := SubStr(A_LoopReadLine, 1, endPos-1) ; Get the variable name
        Gui, 1:Font, s10
        Gui, 1:Add, Text, xs+4 y+1 w245,     %subTitle%     ; Add the variable name to the tab

        dataArraySize++     ; Increase the size of the array
        varName := "VAR" dataArraySize  ; Create the dynamic variable name, it doesn't matter what it is as long as they are all different
        dataArray.Insert(dataArraySize, varName)    ; Add the variable name to the array, insert will add it globally

        if InStr(A_LoopReadLine, "(Bool)") {    ; If the variable is a boolean
            dataTypeArray.Insert(dataArraySize, "Bool") ; Store the data type in an array

            pos1 := InStr(A_LoopReadLine, ":=") + 2 ; Find the position of the assignment
            pos2 := InStr(A_LoopReadLine, "`;",, 0) ; Find the start of the comment
            preTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, 1, pos1)) ; Storing all the text before the value of the variable
            postTextArray.Insert(dataArraySize, SubStr(A_LoopReadLine, pos2-1)) ; Storing all the text after the value of the variable

            if InStr(A_LoopReadLine, "True") {  
                options := "True||False"    ; Set the value to the current config setting
            } else {
                options := "True|False||"
            }
            Gui, 1:Add, ComboBox, x+2 v%varName% w245 h60-, %options%   ; Add the item to the tab
            SendMessage % EM_SETREADONLY:=0xCF, 1,, Edit%dataArraySize%   ; Prevents user from typing in combobox

        } else if InStr(A_LoopReadLine, "(Str)") {
            dataTypeArray.Insert(dataArraySize, "Str")

            pos1 := InStr(A_LoopReadLine, """") + 1     ; Finding the positions of the start and end of the string
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

            pos1 := InStr(A_LoopReadLine, "[") + 1  ; Arrays are surrounded by square brackets
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
Gui, 1:Add, Button, gupdateConfig xs+4 y+1 w245, Update ; Add the final update button

Goto, End   ; Jump over the update config section to prevent it running unnecessarily

updateConfig:   ; Block of code to update the config
    Gui, 1:Submit, NoHide   ; if you don't want to hide the gui-window after an action
    index := 1  ; AHK arrays start at 1
    value := dataArray[index]   ; Store all the paramaters for the variables
    valueType := dataTypeArray[index]
    pre := preTextArray[index]
    post := postTextArray[index]

    Loop, Read, %srcFile%, %A_ScriptDir%/config.tmp ; Loop over the lines in the original and open a new temporary file
    {
        if (InStr(A_LoopReadLine, pre)) {   ; If the pre text is in the current line, it is a line we need to change from the original
            if (%value% = "") { ; If a box is left blank, fill with defualt values
                Switch valueType
                {
                    Case "Bool":
                        %value% := False    ; The default value for a boolean is false
                        return
                    Case "Int":
                        %value% := 1    ; Default value for an int is one
                }
            } else if (valueType = "Int" And %value% <= 0) {
                %value% := 1    ; Force an int to be at least 1
            }
            GuiControl,, %value%, % %value% ; Updates any blanks on the GUI

            textValue := %value%    ; Store the value

            if (valueType = "Array") {
                textValue := StrReplace(textValue, A_Space) ; Remove any spaces
                textValue := StrReplace(textValue, "," , """, """)  ; replace any commas with `", "`
                if StrLen(textValue) { ; If there entry is not blank add speach marks at either side
                    textValue := """" textValue """"
                }
            }

            FileAppend, % pre textValue post "`n", %A_ScriptDir%/config.tmp ; Write the line to the file
            index++
            if (index <= dataArraySize) {   ; If there are still variables to store in the file
                value := dataArray[index]   ; Store all the paramaters for the variables
                valueType := dataTypeArray[index]
                pre := preTextArray[index]
                post := postTextArray[index]
            }   
        } else {
            FileAppend, % A_LoopReadLine "`n", %A_ScriptDir%/config.tmp ; If the pre text isn't in the line, use the text in the original
        }
    }

    FileMove, %A_ScriptDir%/config.tmp, %A_ScriptDir%/config.ahk, 1 ; Replace the original file with the temporary one
    reload  ; reload the script
    return

End: