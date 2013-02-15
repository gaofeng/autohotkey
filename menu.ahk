#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



Menu = Utils|Settings|Folders
Utils = Utils|DriverList|DeviceManager|RegEdit|TaskManager|NumToChn
Settings = SETTINGS|ControlPanel|Display
Folders = FOLDERS|Windows|ProgramFiles|Desktop
Loop, Parse, Menu, |
{
    B_LoopField := A_LoopField
    Loop, Parse, %B_LoopField%, |
    {
        Menu, %B_LoopField%, Add, &%A_LoopField%, %A_LoopField%
        If A_Index = 1
        {
            Menu, %B_LoopField%, Default, &%A_LoopField%
            Menu, %B_LoopField%, Add
        }
    }
}

;;Customize tray menu
#Persistent  ; Keep the script running until the user exits it.
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, Edit m&ain.ahk, EditMainAHK
Menu, tray, add, Edit m&enu.ahk, EditMenuAHK
Menu, tray, add, Open &Location, OpenScriptDir
Menu, FileMenu, add
return

Reg:
Run, regsvr32 %file_path%
return

UnReg:
Run, regsvr32 /u %file_path%
return

#z::
clipboard = 
file_path =
if WinActive("ahk_class CabinetWClass") or WinActive("ahk_class Progman") {
	SendInput ^c 
	sleep,200 ;;Must Delay
	file_path = %clipboard%
}
else if WinActive("ahk_class dopus.lister") {
	SendInput ^+c
	sleep,200 ;;Must Delay
	file_path = %clipboard%
}

if FileExist(file_path) {
	Menu, FileMenu, DeleteAll
	Menu, FileMenu, add, %file_path%, NullHandler
	Menu, FileMenu, Disable, %file_path%
	Menu, FileMenu, add
	Menu, FileMenu, add, COM View, COMView
	Menu, FileMenu, add, Regist, Reg
	Menu, FileMenu, add, UnRegist, UnReg
	Menu, FileMenu, show
}
return

NullHandler:
return

GetEditorPath()
{
	ahk_path := A_AhkPath
	SplitPath, ahk_path,, dir
	scite_path := dir . "\SciTe\SciTE.exe"
	IfExist, %scite_path%
	{
		return %scite_path%
	}
	return "D:\Program Files\Sublime Text 2\sublime_text.exe"
}

COMView:
Run, D:\Work\DLL & COM\ShowActiveXIF.exe "%file_path%"
return

EditMainAHK:
EditorPath := GetEditorPath()
Run, %EditorPath% %A_ScriptFullPath%
return

EditMenuAHK:
EditorPath := GetEditorPath()
Run, %EditorPath% %A_ScriptDir%\menu.ahk
return

OpenScriptDir:
Run, %A_ScriptDir%
return

#s::
~RButton::
RapidHotkey("Utils""Settings""Folders", 2,0.4,1)
return

Folders:
Settings:
Utils:
Menu,%A_ThisLabel%, Show
return

DriverList:
#include Removable.ahk
return

DeviceManager:
Run, devmgmt.msc
return

TaskManager:
Run, taskmgr
return

RegEdit:
Run, regedit
return

;;数字大写转换
NumToChn:
InputBox, UserNum, 数字大写, 请输入要转换为大写的数字
if (ErrorLevel = 0) {
    msg := UserNum . ":`n`n人民币 " . Num2Chn(UserNum)
    MsgBox, %msg%   
}
return

ControlPanel:
Run, control.exe
Return
Display:
Run, desk.cpl
Return
Windows:
Run, explorer.exe "C:\Windows"
Return
ProgramFiles:
Run, explorer.exe "%A_ProgramFiles%"
Return
Desktop:
Run, explorer.exe "%A_Desktop%"
Return


