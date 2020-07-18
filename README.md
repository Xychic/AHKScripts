# My AHK Scipt

This is the script I use to make windows act more like I want it to.

## Sections
[1. AHKCompatability](#AHKCompatability)  
[2. EnQuoteText](#EnQuoteText)  
[3. NumAsNumpad](#NumAsNumpad)  
[4. VirtualDesktopSwitcher](#VirtualDesktopSwitcher)  
[5. WindowsFunctions](#WindowsFunctions)  
[6. MouseMediaControl](#MouseMediaControl)  
[7. MouseAutoClicker](#MouseAutoClicker)  
[8. TextReplacement](#TextReplacement)  

## AHKCompatability  
A couple functions that allow quick editing and suspending of the script.  

### Keybindings  
|Hotkey          |Action               |  
|----------------|---------------------|  
|CTRL+SHIFT+SPACE|Reloads the script   |  
|WIN+SCROLL_LOCK |Suspends the script  |  
|CTRL+ALT+WIN+C  |Open GUI configurator|

### Config settings
|Variable Name |Description                               |Valid values  |  
|--------------|------------------------------------------|--------------|  
|RELOAD_TRAYTIP|Enabled or disables the tray tip on reload|"True","False"|  

## EnQuoteText
This allows you to highlight text and type several 'wrapping'  characters to surround the text in that character.
The functionality is similar to several IDEs such as VSCode, Eclipse, and IntelliJ to name a few. 

### Example
Highlighting the word `fox` in the following sentence and typing an open bracket will do the following:
`The quick brown fox jumps over the lazy dog` &rarr; `The quick brown (fox) jumps over the lazy dog`

### List of 'wrapping' characters
- '
- "
- `
- (
- {
- [

### Config settings
|Variable Name    |Description                                  |Valid values               |  
|-----------------|---------------------------------------------|---------------------------|  
|ENQUOTE_ENABLED  |Enables or disables the functions            |"True","False"             |  
|ENQUOTE_BLACKLIST|A list of programs to not apply the functions|Example: ["code","notepad"]|  

## NumAsNumpad
Allows the number keys (or any of the arithmetic keys that also appear on the numpad) on a keyboard to function as their numpad equivalents. This is because I have a 62-key keyboard without a numpad but sometimes I need the numpad keys.  

### Keybindings  
|Hotkey    |Action                                                                    |  
|----------|--------------------------------------------------------------------------|  
|CTRL + F12|Toggles number keys between acting as numpad keys and their default action|  

### Config settings  
|Variable Name        |Description                      |Valid values  |  
|---------------------|---------------------------------|--------------|  
|NUM_AS_NUMPAD_ENABLED|Enables or disables the functions|"True","False"|  

## VirtualDesktopSwitcher  
Adds functionality for 2D virtual desktop layouts in windows, as well as adding wrapping to warp from one side to the other.  

### Keybindings
|Hotkey            |Action                                                                                            |  
|------------------|--------------------------------------------------------------------------------------------------|  
|CTRL + WIN + UP   |Will move up one virtual desktop, if at the top, go to lowest virtual desktop in the column       |  
|CTRL + WIN + DOWN |Will move down one virtual desktop, if at the bottom, go to highest virtual desktop in the column |  
|CTRL + WIN + LEFT |Will move left one virtual desktiop, if at the left-most desktop, go to the right-most in the row |  
|CTRL + WIN + RIGHT|Will move right one virtual desktiop, if at the right-most desktop, go to the left-most in the row|  

### Config settings
|Variable Name           |Description                                         |Valid values  |  
|------------------------|----------------------------------------------------|--------------|  
|VIRTUAL_DESKTOPS_ENABLED|Enables or disables the functions                   |"True","False"|  
|ROWS                    |The number of virtual desktops in each row          |1,2,3,...     |  
|COLUMNS                 |The numnbr of virtual desktops in each column       |1,2,3,...     |  
|INITIAL_DESKTOP         |The desktop where the program will start the user at|0,1,2,...     |  

## WindowsFunctions
Adds some nice functions that are I didn't really know how to group...  

### Keybindings
|Hotkey          |Action                                                                                                                     |  
|----------------|---------------------------------------------------------------------------------------------------------------------------|  
|CTRL+ALT+T      |Opens a command shell in the active directory in an explorer window or C:\\ if none are active                             |  
|CTRL+SHIFT+C    |Will search for any highlighted text, or if no text is highlighted; the clipboard. If the text is a URL, just go to the URL|  
|CTRL+SHIFT+V    |Will paste clipboard as plaintext                                                                                          |  
|WIN+V           |Will open up VLC with a network stream to highlighted text or clipboard, useful for watching YouTube videos as a pop-out   |  
|CTRL+WIN+DEL    |Will open the shutdown dialogue box                                                                                        |  
|CTRL+SHIFT+GRAVE|Starts task manager as SHIFT+ESC types grave on my keyboard                                                                |  
|WIN+DEL         |Empties the recycling bin                                                                                                  |  
|WIN+SPACE       |Makes a window stick on top, even if it is not the active window                                                           |  

### Config settings
|Variable Name           |Description                                         |Valid values                                                           |  
|------------------------|----------------------------------------------------|-----------------------------------------------------------------------|  
|WINDOWS_FUNCTIONS_ENABLED|Enables or disables the functions                  |"True","False"                                                         |  
|SEARCH_ENGINE            |The string that prefixes the search term           |"https://www.google.com/search?q=","https://www.bing.com/search?q=",etc|  
|PREFERED_SHELL           |The full directory path to the preferred shell     |"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe","%comspec%"|

## MouseMediaControl
Allows volume and play/pause control quickly with the mouse

### Keybindings  
|Hotkey                     |Action      |  
|---------------------------|------------|  
|CTRL+WIN+SCROLL_UP         |Volume up   |  
|CTRL+WIN+SCROLL_DOWN       |Volume down |  
|CTRL+WIN+MIDDLE_CLICK      |Mute        |  
|CTRL+SHIFT+WIN+SCROLL_UP   |Next        |  
|CTRL+SHIFT+WIN+SCROLL_DOWN |Previous    |  
|CTRL+SHIFT+WIN+MIDDLE_CLICK|Play/Pause  |

### Config settings  
|Variable Name              |Description                      |Valid values  |  
|---------------------------|---------------------------------|--------------|  
|MOUSE_MEDIA_CONTROL_ENABLED|Enables or disables the functions|"True","False"|  

## MouseAutoClicker
Adds an autoclicker for left click, right click, and scroll.  

### Keybindings 
|Hotkey               |Action                                      |  
|---------------------|--------------------------------------------|  
|ALT+SHIFT+LEFT_CLICK |Repeatedly left clicks until ESC is pressed |  
|ALT+SHIFT+RIGHT_CLICK|Repeatedly right clicks until ESC is pressed|  
|ALT+SHIFT+SCROLL_UP  |Repeatedly scrolls up until ESC is pressed  |  
|ALT+SHIFT+SCROLL_DOWN|Repeatedly scrolls down until ESC is pressed|  

### Config settings 
|Variable Name             |Description                                             |Valid values        |  
|--------------------------|--------------------------------------------------------|--------------------|  
|MOUSE_AUTO_CLICKER_ENABLED|Enables or disables the functions                       |"True","False"      |  
|SCROLL_DELAY              |The delay between each scroll event in millisecons      |"10","20","300",... |  
|LEFT_CLICK_DELAY          |The delay between each left click event in milliseconds |"10","20","300",... |  
|RIGHT_CLICK_DELAY         |The delay between each right click event in milliseconds|"10","20","300",... |  

## TextReplacement  
Adds some useful text replacement for frequently used text.  

## Example  
Typing `@@` followed by a number will type that item from the email config.  
if `EMAILS: = ["email0@mail.example","email1@mail.example"]` is set in the config:  
`@@0` &rarr; `email0@mail.example`  
`@@1` &rarr; `email1@mail.example`  

Typing `##` followed by a number will type that item from the number config  
if `NUMBERS := ["0123456789","0987654321"]` is set in the config:  
`##0` &rarr; `0123456789`  
`##1` &rarr; `0987654321`  

### Config settings  
|Variable Name           |Description                             |Valid values                              |  
|------------------------|----------------------------------------|------------------------------------------|  
|TEXT_REPLACEMENT_ENABLED|Enables or disables the functions       |"True","False"                            |  
|EMAILS                  |List of emails used in text replacement |Example: ["me@mail.com","me2@example.com"]|  
|NUMBERS                 |List of numbers used in text replacement|Example: ["0123456789","0987654321"]      |  
