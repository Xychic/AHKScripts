/*
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Please don't edit manually: Press `CTRL+WIN+ALT+C` to launch the configurator
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

; AHKCompatability
RELOAD_TRAYTIP := True ; (Bool)

; EnQuoteText
ENQUOTE_ENABLED := True ; (Bool)
ENQUOTE_BLACKLIST := [] ; (Array) Programs to not enquote with text

; NumAsNumpad
NUM_AS_NUMPAD_ENABLED := True ; (Bool) 

; VirtualDesktopSwitcher
VIRTUAL_DESKTOPS_ENABLED := True ; (Bool)
ROWS := 3 ; (Int) The number of virtual desktops in each row
COLUMNS := 3 ; (Int) The number of virtual desktops in each column
INITIAL_DESKTOP := 5 ; (Int) The desktop that the computer will start on
TOTAL_DESKTOPS := ROWS*COLUMNS ; (Ignore) The total number of virtual desktops

; WindowsFunctions
WINDOWS_FUNCTIONS_ENABLED := True ; (Bool)
SEARCH_ENGINE := "https://www.google.com/search?q=" ; (Str)
PREFERED_SHELL := "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" ; (Str) Full directory path to preferred shell
BRIGHTNESS_DELTA := 10 ; (Int)

; MouseMediaControl
MOUSE_MEDIA_CONTROL_ENABLED := True ; (Bool)
INVERT_SCROLL := False ; (Bool)

; MouseAutoClicker
MOUSE_AUTO_CLICKER_ENABLED := True ; (Bool)
SCROLL_DELAY := 10 ; (Int)
LEFT_CLICK_DELAY := 10 ; (Int)
RIGHT_CLICK_DELAY := 10 ; (Int)

; TextReplacement
TEXT_REPLACEMENT_ENABLED := True ; (Bool)
EMAILS := [] ; (Array)
NUMBERS := [] ; (Array)
