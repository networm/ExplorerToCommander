#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Windows 7
#IfWinActive ahk_class ExploreWClass
; Windows 10
#IfWinActive ahk_class CabinetWClass
; Alt+E open current Explorer in Double Commander
!e::
WinGet, winid
Path := uriDecode(WindowsExplorerLocationByCOM(%winid%))
Run, "C:\Program Files\Double Commander\doublecmd.exe" --no-splash --client -T "%Path%"
WinClose, ahk_id %winid%
Return

;[Detect current windows explorer location - Ask for Help - AutoHotkey Community](https://www.autohotkey.com/board/topic/70960-detect-current-windows-explorer-location/)
WindowsExplorerLocationByCOM(HWnd="")
{
   If ( HWnd = "" )
      HWnd := WinExist("A")
   WinGet Process, ProcessName, ahk_id %HWnd%
   If ( Process = "explorer.exe" )
   {
      WinGetClass Class, ahk_id %HWnd%
      If ( Class ~= "Progman|WorkerW" )
         Location := A_Desktop
      Else If ( Class ~= "(Cabinet|Explore)WClass" )
      {
         For Window In ComObjCreate("Shell.Application").Windows
            If ( Window.HWnd == HWnd )
            {
               URL := Window.LocationURL
               Break
            }
         StringTrimLeft, Location, URL, 8 ; remove "file:///"
         StringReplace Location, Location, /, \, All
      }
   }
   Return Location
}

;[Great AutoHotkey script to URL Encode/Decode and parse URL parameters : AutoHotkey](https://www.reddit.com/r/AutoHotkey/comments/4py9e7/great_autohotkey_script_to_url_encodedecode_and/)
;***********https://autohotkey.com/board/topic/17367-url-encoding-and-decoding-of-special-characters/******************* 
uriDecode(str) {
    Loop
 If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
    StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
    Else Break
 Return, str
}
