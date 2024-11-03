; V1toV2: Removed #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; Windows 7
#HotIf WinActive("ahk_class ExploreWClass", )
; Windows 10
#HotIf WinActive("ahk_class CabinetWClass", )
; Alt+E open current Explorer in Total Commander
!e::
{ ; V1toV2: Added bracket
global ; V1toV2: Made function global
winid := WinGetID()
Path := uriDecode(WindowsExplorerLocationByCOM(winid))
Run("`"C:\Program Files\totalcmd\TOTALCMD64.EXE`" /O /T `"" Path "`"")
WinClose("ahk_id " winid)
Return

;[Detect current windows explorer location - Ask for Help - AutoHotkey Community](https://www.autohotkey.com/board/topic/70960-detect-current-windows-explorer-location/)
} ; V1toV2: Added bracket before function
WindowsExplorerLocationByCOM(HWnd:="")
{
   If ( HWnd = "" )
      HWnd := WinExist("A")
   Process := WinGetProcessName("ahk_id " HWnd)
   If ( Process = "explorer.exe" )
   {
      Class := WinGetClass("ahk_id " HWnd)
      If ( Class ~= "Progman|WorkerW" )
         Location := A_Desktop
      Else If ( Class ~= "(Cabinet|Explore)WClass" )
      {
         For Window In ComObject("Shell.Application").Windows
            If ( Window.HWnd == HWnd )
            {
               URL := Window.LocationURL
               Break
            }
         Location := SubStr(URL, (8)+1) ; remove "file:///"
         ; V1toV2: StrReplace() is not case sensitive
         ; check for StringCaseSense in v1 source script
         ; and change the CaseSense param in StrReplace() if necessary
         Location := StrReplace(Location, "/", "\")
      }
   }
   Return Location
}

;[Great AutoHotkey script to URL Encode/Decode and parse URL parameters : AutoHotkey](https://www.reddit.com/r/AutoHotkey/comments/4py9e7/great_autohotkey_script_to_url_encodedecode_and/)
;***********https://autohotkey.com/board/topic/17367-url-encoding-and-decoding-of-special-characters/******************* 
uriDecode(str) {
    Loop
 If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", &hex)
    ; V1toV2: StrReplace() is not case sensitive
    ; check for StringCaseSense in v1 source script
    ; and change the CaseSense param in StrReplace() if necessary
    str := StrReplace(str, "`%" (hex&&hex[0]), Chr("0x" . (hex&&hex[0])))
    Else Break
 Return str
}
