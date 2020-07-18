;------------------------------------------------------------------------------------------------------------------------------------------------------------
; Includes
;------------------------------------------------------------------------------------------------------------------------------------------------------------
#Include, %A_ScriptDir%/config.ahk
#Include, %A_ScriptDir%/GUIConfigurator.ahk

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; Settings
;------------------------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv ; For security
#SingleInstance force
#MaxHotkeysPerInterval 200

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; GLOBAL CONSTANTS
;------------------------------------------------------------------------------------------------------------------------------------------------------------
global ENQUOTE_BLACKLIST, ROWS, COLUMNS, TOTAL_DESKTOPS, INITIAL_DESKTOP, PREFERED_SHELL

;------+------------------------------------------------------------------------------------------------------------------------------------------------------
; GLOBAL VARIABLES
;------------------------------------------------------------------------------------------------------------------------------------------------------------
{	; AHKCompatability
	suspended := False
}

{	; NumAsNumpad
	numAsNumpad := False
}

{	; MouseAutoClicker
	autoClicker := False
}
;------------------------------------------------------------------------------------------------------------------------------------------------------------
; FUNCTIONS
;------------------------------------------------------------------------------------------------------------------------------------------------------------
{	; AHKCompatability
	showTrayTip(title, text, delay:=1000) {
		TrayTip, %title%, %text%
		; sleep %delay%
		; HideTrayTip()
		return
	}

	HideTrayTip() {
		TrayTip  ; Attempt to hide it the normal way.
		if SubStr(A_OSVersion,1,3) = "10." {
			Menu Tray, NoIcon
			Sleep 200 
			Menu Tray, Icon
		}
	}
}
{	; EnQuoteText
	arrayContains(array, target) {	; Function to see if array contains value
		OutputDebug Target: %target%
		for index, value in array {	; Itertating over the index and values in the array
			if RegExMatch(target, value) {	; Return the index if the value matches
				return index
			}
		}
		return 0	; If the value is not found return 0
	}

	enQuote(startChar, endChar="") {	; Function to wrap highlighted text in chars
		WinGet, activeProcess, ProcessName, A	; Get the active windows name
		SplitPath, activeProcess,,,, programName	; Split the string to just the program name
		endChar := (endChar="") ? startChar : endChar	; Set endChar to the startChar if endChar is blank

		if (arrayContains(ENQUOTE_BLACKLIST, programName)) {	; If the current program is in the black list, send the original key
			SendInput {Raw}%startChar%
		} else {
			oldClipboard := ClipboardAll   ; Save the entire clipboard to a variable 
			Clipboard := ""	; Empty the clipboard
			Send, ^c	; Copy the highlighted text

			if (Clipboard = "") {	; If the clipboard is empty, send the orignal char
				SendInput {Raw}%startChar%	
			} else {	; Wrap the highlighted text in the specified chars if clipboard is not empty
				SendInput {Raw}%startChar%%Clipboard%%endChar%	
			}
			Clipboard := oldClipboard   ; Restoring the original clipboard
			oldClipboard := ""   ; Free the memory in case the clipboard was very large.
		}
		return
	}
}

{	; VirtualDesktopSwitcher
	getSessionID() {	; Getting the session ID
		processId := DllCall("GetCurrentProcessId", "UInt")	; DLL call to get the process ID
		if ErrorLevel {
			OutputDebug, Error getting current process id: %ErrorLevel%
			return
		}
		DllCall("ProcessIdToSessionId", "UInt", processId, "UInt*", sessionId)	; Getting the session ID using the process ID
		if ErrorLevel {
			OutputDebug, Error getting session id: %ErrorLevel%
			return
		}
		return sessionId
	}

	prepareRegistry() {		; Fixes issues where the registry has missing items
		sessionID := getSessionID()
		RegRead, currentDesktopID, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%sessionID%\VirtualDesktops, CurrentVirtualDesktop
		if (not StrLen(currentDesktopID)) {
			Send ^#d
		}
		return
	}


	getVirtualDesktopList() {
		RegRead, desktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
		if ErrorLevel {
			OutputDebug, Error getting desktop list: %ErrorLevel%
			return
		}
		return desktopList
	}

	GetActiveVirtualDesktopID() {
		sessionID := getSessionID()
		RegRead, currentDesktopID, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%sessionID%\VirtualDesktops, CurrentVirtualDesktop
		if ErrorLevel {
			OutputDebug, Error getting desktop id: %ErrorLevel%
			return
		}
		return currentDesktopID
	}

	getNumberOfDesktops() {
		activeDesktopID := GetActiveVirtualDesktopID()
		desktopList := getVirtualDesktopList()
		desktopCount := StrLen(desktopList) / StrLen(activeDesktopID)
		return desktopCount
	}

	getCurrentDesktopNumber() {
		activeDesktopID := GetActiveVirtualDesktopID()
		desktopList := getVirtualDesktopList()
		IDLength := StrLen(activeDesktopID)
		desktopCount := StrLen(desktopList) / IDLength

		i := 0
		while (i < desktopCount) {
			startPos := (i * IDLength) + 1
			desktopIter := SubStr(desktopList, startPos, IDLength)
			if (desktopIter = activeDesktopID) {
				currentDesktop := i + 1
				return currentDesktop
				break
			}
			i++
		}
		return
	}

	makeNewDesktops(numberWanted:=0) {
		numberOfDesktops := getNumberOfDesktops()
		extraNeeded := (numberWanted = 0) ? 1 : numberWanted - numberOfDesktops
		extraToRemove := 0-extraNeeded

		loop, %extraNeeded% {
			Send ^#d
		}

		loop, %extraToRemove% {
			Send ^#{F4}
		}
		return
	}

	goToDesktop(targetDesktop:=1) {
		currentDesktop := getCurrentDesktopNumber()
		WinActivate, ahk_class Shell_TrayWnd
		while (currentDesktop < targetDesktop) {
			send ^#{Right}
			currentDesktop++
		}
		while (targetDesktop < currentDesktop) {
			send ^#{Left}
			currentDesktop--
		}
		return
	}

	moveDesktop(direction) {
		currentDesktop := getCurrentDesktopNumber()-1
		if (direction = "up") {
			targetDesktop := Mod(currentDesktop + (TOTAL_DESKTOPS - ROWS), TOTAL_DESKTOPS)
			goToDesktop(targetDesktop + 1)
		} else if (direction = "down") {
			targetDesktop := Mod(currentDesktop + ROWS, TOTAL_DESKTOPS)
			goToDesktop(targetDesktop + 1)
		} else if (direction = "left") {
			if (Mod(currentDesktop, COLUMNS) = 0) {
				targetDesktop := currentDesktop + 2
			} else {
				targetDesktop := currentDesktop - 1
			}
			goToDesktop(targetDesktop + 1)
		} else if (direction = "right") {
			if (Mod(currentDesktop, COLUMNS) = 2) {
				targetDesktop := currentDesktop - 2
			} else {
				targetDesktop := currentDesktop + 1
			}
			goToDesktop(targetDesktop + 1)
		} else {
			OutputDebug, direction: %direction%
		}
		return
	}
}

{	; WindowsFunctions
	getActiveExplorerPath(defaultPath:="C:\") {
		hwnd := WinExist("A")	; Getting the Handle Window for the active window
		WinGet, process, processName, % "ahk_id" hwnd	; Getting the name of the active process that owns the active window
		if (process = "explorer.exe") {
			for window in ComObjCreate("Shell.Application").Windows {	; Iterate over every application
				if (window.hwnd==hwnd) {	; If the HWND matches, return the path
					return window.Document.Folder.Self.Path
				}
			}
		}
		return defaultPath	; If no path is found, return default
	}

	UriEncode(uri) {
		VarSetCapacity(Var, StrPut(uri, "UTF-8"), 0)
		StrPut(uri, &Var, "UTF-8")
		f := A_FormatInteger
		encoded := ""
		SetFormat, IntegerFast, H
		while Code := NumGet(Var, A_Index - 1, "UChar") {
			if (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) { ; a-z 
				encoded .= Chr(Code)
			} else {
				encoded .= "%" . SubStr(Code + 0x100, -1)
			}
		}
		SetFormat, IntegerFast, %f%
		Return, encoded
	}	

	SendFKeys(FKeyIndex) {
		SendLevel, 2
		Send {F%FKeyIndex%}
		return
	}
}

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; AUTO-EXECUTE
;------------------------------------------------------------------------------------------------------------------------------------------------------------
#If VIRTUAL_DESKTOPS_ENABLED
	prepareRegistry()
	makeNewDesktops(TOTAL_DESKTOPS)	; Ensure that there are the required number of virtual desktops
	goToDesktop(INITIAL_DESKTOP)
#If
#If WINDOWS_FUNCTIONS_ENABLED
	Loop, 12
	{
		OutputDebug, Index: %A_Index% 
		fn := Func("SendFKeys").Bind(A_Index+12)
		Hotkey, !F%A_Index% , % fn
	}
#If
return

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; HOT-KEY BINDINGS
;------------------------------------------------------------------------------------------------------------------------------------------------------------
{	; AHK Compatability
	^+SPACE:: 	; CTRL + SHIFT + SPACE will reload the script
		if (RELOAD_TRAYTIP) {
			TrayTip AutoHotKey, Reloaded script "Main"
		}
		sleep 1000
		reload ; CTRL + SHIFT + SPACE reloads scripts
		return
	#ScrollLock::
		Suspend ; WIN + SCROLLLOCK suspends AHK scripts
		suspended := not suspended
		if (suspended) {
			TrayTip AutoHotKey, Suspending script
		} else {
			TrayTip, AutoHotKey, Resuming script
		}
		Sleep 1500
		HideTrayTip()
		return

	^!#C:: ; CTRL + ALT + WIN + C launches the configurator
		Gui, 1:Show, w520 , Configurator
		return
}

#if ENQUOTE_ENABLED		; EnQuoteText
	$'::enQuote("'")	; Wraps highlighted text in single quotes 
	$"::enQuote("""")	; Wraps highlighted text in doulbe quotes 
	$`::enQuote("``")	; Wraps highlighted text in back ticks
	$(::enQuote("(", ")")	; Wraps highlighted text in round brackets
	${::enQuote("{","}")	; Wraps highlighted text in curly brackets
	$[::enQuote("[","]")	; Wraps highlighted text in doulbe square brackets
#if

#if NUM_AS_NUMPAD_ENABLED	; NumAsNumpad
	^F12::numAsNumpad := !numAsNumpad ; CTRL + F12 toggles number keys as numpad equivalent

	#if numAsNumpad	; If numAsNumpad is true send the numpad equivalent of keys
		0::Numpad0
		1::Numpad1
		2::Numpad2
		3::Numpad3
		4::Numpad4
		5::Numpad5
		6::Numpad6
		7::Numpad7
		8::Numpad8
		9::Numpad9
		.::NumpadDot
		/::NumpadDiv
		-::NumpadSub
		+=::NumpadAdd
		+8::NumpadMult
		+.::.
		+/::/
		+-::-
		+1::1
		+2::2
		+3::3
		+4::4
		+5::5
		+6::6
		+7::7
		+9::9
		+0::0
		return
	#if
#if

#if VIRTUAL_DESKTOPS_ENABLED	; VirtualDesktopSwitcher
	^#Up:: moveDesktop("up")		; Binding CTRL + WIN + UP to move up one desktop
	^#Down:: moveDesktop("down")	; Binding CTRL + WIN + DOWN to move up down desktop
	^#Left:: moveDesktop("left")	; Overwriting CTRL + WIN + LEFT 
	^#Right:: moveDesktop("right")	; Overwriting CTRL + WIN + RIGHT 
#if

#if WINDOWS_FUNCTIONS_ENABLED	; WindowsFunctions
	^!T::	; CTRL + ALT + T opens cmd shell at current directory
		currentDir := getActiveExplorerPath()
		Run, %PREFERED_SHELL%, %currentDir%
		return

	; $^D::	; CTRL + D Closes an active shell
	; 	hwnd := WinExist("A")	; Getting the Handle Window for the active window
	; 	WinGet, process, processName, % "ahk_id" hwnd	; Getting the name of the active process that owns the active window
	; 	SplitPath, PREFERED_SHELL, shell	; Getting the name of the system shell
	; 	if (process = shell) {	
	; 		WinClose % "ahk_id" hwnd	; Close the active window if it is the system shell
	; 	} else {
	; 		send ^D
	; 	}
	; 	return
	; ; ^D

	^+C::	; CTRL + SHIFT + C will search for highlighted text
		oldClipboard := ClipboardAll   ; Save the entire clipboard to a variable
		Send, ^c	; Copy the highlighted text
		Sleep, 10
		If RegExMatch(clipboard, "^[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$") { ; Check to see if it is a URL
			Run, %clipBoard%
		} else {
			clipboard := UriEncode(clipboard)
			Run, %SEARCH_ENGINE%%clipboard%	; Search google for the highlighted text
		}
		Clipboard := oldClipboard   ; Restoring the original clipboard
		oldClipboard := ""   ; Free the memory in case the clipboard was very large.
		return
	; ^+C

	^+V::	; CTRL + SHIFT + V will paste as plaintext
		oldClipboard = %clipBoardAll%	; Save the entire clipboard to a variable
		clipBoard = %clipBoard%	; Convert to text
		Send ^v		; Pasting the text
		Sleep, 10	; Don't change clipboard while it is pasted!
		clipBoard = %oldClipboard%	; Restore original ClipBoard
		oldClipboard := ""	; Free memory
	; ^+V

	#V::	; WIN + V will open up VLC streaming to copied or highlighted URL
		oldClipboard := clipboardAll   ; Save the entire clipboard to a variable 
		oldPlainText := clipBoard
		clipboard := ""	; Empty the clipboard
		Send, ^c	; Copy the highlighted text
		if (clipboard != "") {	; If the clipboard is empty, and the clipboard is text
			Run vlc %clipboard%	--qt-minimal-view --width=352 --height=265	; Open VLC stream to highlighted link with minimal interface
		} else {
			Run vlc %oldPlainText% --qt-minimal-view --width=352 --height=265
		}
		clipboard := oldClipboard   ; Restoring the original clipboard
		oldClipboard := ""   ; Free the memory in case the clipboard was very large.
		return

	^#DEL::		; CTRL + WIN + DEL will open shutdown dialogue
		fpath = %A_Temp%\ShutdownDialog.vbs
		FileDelete, %fpath%
		FileAppend,CreateObject("Shell.Application").ShutdownWindows,%fpath%
		RunWait wscript.exe %fpath%
		Return

	^+¬::Run, C:\Windows\System32\Taskmgr.exe ; CTRL + SHIFT + GRAVE will open task manager

	#Del::FileRecycleEmpty ; WIND + DEL empties recycling bin

	#SPACE:: Winset, Alwaysontop, , A ; WIN + SPACE makes a window always on top
	
	; TODO Force space play/pause for certain applications
#if


#if MOUSE_AUTO_CLICKER_ENABLED	; MouseAutoClicker
	#if autoClicker	; If an auto clicker is running, ESC will stop it
		ESC::
			autoClicker := False
			Send, {ESC UP}
			Sleep, 200
			Return
	#if
#if

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; MOUSE-KEY BINDINGS
;------------------------------------------------------------------------------------------------------------------------------------------------------------
#if MOUSE_MEDIA_CONTROL_ENABLED	; MouseMediaControl
	#IfWinActive, ahk_class CabinetWClass
		~MButton::Send !{Up} 	; Middle mouse button moves explorer up a directory
	#IfWinActive

	^#WheelDown::Volume_Down	; CTRL + WIN + SCROLL_DOWN lowers volume
	^#WheelUp::Volume_Up		; CTRL + WIN + SCROLL_UP raises volume
	^#MButton::Volume_Mute		; CTRL + WIN + MIDDLE_MOUSE mutes 
	^+#MButton::Media_Play_Pause	; CTRL + SHIFT + WIN pauses/plays media
	^+#WheelDown::Media_Prev	; CTRL + SHIFT + SCROLL_DOWN goes to previous track
	^+#WheelUp::Media_Next		; CTRL + SHIFT + SCROLL_UP goes to next track
#if

#if MOUSE_AUTO_CLICKER_ENABLED	; MouseAutoClicker
	!+LButton:: ; ALT + SHIFT + LEFT_CLICK will continue clicking until ESC is pressed
	autoClicker := True
    loop {
        if !autoClicker
            Return
        MouseClick, left
        Sleep %LEFT_CLICK_DELAY%
    }

	!+RButton:: ; ALT + SHIFT + RIGHT_CLICK will continue clicking until ESC is pressed
	autoClicker := True
    loop {
        if !autoClicker
            Return
        MouseClick, right
        Sleep %RIGHT_CLICK_DELAY%
    }

	!+WheelDown:: ; ALT + SHIFT + SCROLL will continue scrolling until ESC is pressed
    autoClicker := True
    loop {
        if !autoClicker
            Return
        MouseClick, WheelDown
        Sleep %SCROLL_DELAY%
    }

	!+WheelUp:: ; ALT + SHIFT + SCROLL will continue scrolling until ESC is pressed
		autoClicker := True
		loop {
			if !autoClicker
				Return
			MouseClick, WheelUp
			Sleep %SCROLL_DELAY%
		}
#if

;------------------------------------------------------------------------------------------------------------------------------------------------------------
; Text Replacement
;------------------------------------------------------------------------------------------------------------------------------------------------------------
#if TEXT_REPLACEMENT_ENABLED ; TextReplacement
	~@::	; Typing `@` starts the listener
		Input, userInput, V T10, {Space}	; Listen until a space is type, but continue typing

		if RegExMatch(userInput, "^@[0-9]+$") {	; If the input starts with `@` 
			backTrackLength := StrLen(userInput) + 2 ; Get the length of the typed text + an extra `@` and a space
			maxIndex := EMAILS.MaxIndex()	; Find the maximum valid index
			index := 1 + StrReplace(userInput, "@")	; Remove the leading `@` and add 1 to the integer value as AHK is 1-indexing

			if (index <= maxIndex) {	; If the index is in the valid range
				
				Send, {backspace %backTrackLength%}%outputVal%	; Send backspaces to clear the hostring, followed by the desired text
				oldClipboard = %clipBoardAll%	; Save the entire clipboard to a variable
				clipBoard := EMAILS[index]	; Load the desired value into the clipboard
				Send, ^v
				clipBoard := oldClipboard
			}
		}
		return

	~#::	; Typing `#` starts the listener
		Input, userInput, V T10, {Space}	; Listen until a space is type, but continue typing

		if RegExMatch(userInput, "^#[0-9]+$") {	; If the input starts with `#` 
			backTrackLength := StrLen(userInput) + 2 ; Get the length of the typed text + an extra `#` and a space
			maxIndex := NUMBERS.MaxIndex()	; Find the maximum valid index
			index := 1 + StrReplace(userInput, "#")	; Remove the leading `#` and add 1 to the integer value as AHK is 1-indexing

			if (index <= maxIndex) {	; If the index is in the valid range
				
				Send, {backspace %backTrackLength%}%outputVal%	; Send backspaces to clear the hostring, followed by the desired text
				oldClipboard = %clipBoardAll%	; Save the entire clipboard to a variable
				clipBoard := NUMBERS[index]	; Load the desired value into the clipboard
				Send, ^v
				clipBoard := oldClipboard
				oldClipboard := ""	; Free memory
			}
		}
		return
#if
