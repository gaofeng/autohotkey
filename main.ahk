; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one .ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.


#include menu.ahk

^!r::  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
TrayTip, AutoHotkey.ahk, Restart after 1 second..., 1
sleep 1000
Reload
return

;;Gmail��ַ��д
:o:g@::gaofengdiskonline@gmail.com
:o:$s::$(SolutionDir)
:o:$p::$(ProjectDir)

^!t::

return

^!F4::
WinGetActiveTitle, Title
WinGet, PID, PID, %Title%
MsgBox, 0x104, ע��, ��ǿ�ƹرձ���Ϊ"%Title%"�Ĵ���, ����Ϊ%PID%, �Ƿ����?
IfMsgBox, No
    return
Process, Close, %PID%
return

;;���ж���������ҳ��
^+a::
Run, %A_ProgramFiles%\Internet Explorer\iexplore.exe D:\Subversion\SmartCardReader\CardReaderATL\TestCardReader.html
return

^+s::
Run, %A_ProgramFiles%\Internet Explorer\iexplore.exe D:\Subversion\VCProject_trunk\ScannerTwain\DWScannerTwainATL\DWScannerTest.html
return

;;�������д������ÿ�ݼ�ճ��
#IfWinActive ahk_class ConsoleWindowClass
^v::
SendInput %clipboard%
#IfWinActive

;;�򿪻򼤻�Notepad++
#IfWinExist ahk_class Notepad++
#n::WinActivate
#IfWinExist

;;���ļ������Դ���
^p::
send ^c 
sleep,100
IfExist, %clipboard%
    Run, properties %clipboard%

CopySelection()
{
    clipboard =
    send ^c 
    ClipWait, 1
    if ErrorLevel
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        return
    }
    return clipboard
}

;;Alt+1 copy�ļ��� 
!1::
path := CopySelection()
if path = 
    return
SplitPath, path, name 
clipboard = %name%
MouseGetPos,x0
tooltip File name: "%clipboard%" copied.
loop
{
    MouseGetPos,x1 ;���Ų��ȡ����ʾ��
    if x1!=%x0%
    { 
        tooltip
        break
    }
}
return 
;;alt+2 copy ���ļ����ڵ�·���� 
!2:: 
path := CopySelection()
if path = 
    return
SplitPath, path, , dir 
clipboard = %dir%
MouseGetPos,x0
tooltip File Location: "%clipboard%" copied.
loop
{
    MouseGetPos,x1 ;���Ų��ȡ����ʾ��
    if x1!=%x0%
    { 
        tooltip
        break
    }
}
return 

;;Alt+3 copy ���ļ���ȫ·���� 
!3:: 
path := CopySelection()
if path = 
    return
MouseGetPos,x0
clipboard = %path%
tooltip Path: "%clipboard%" copied
loop
{
    MouseGetPos,x1 ;���Ų��ȡ����ʾ��
    if x1!=%x0%
    { 
        tooltip
        break
    }
}
return

;;Alt+4 copy ���ļ���ȫ·����������Ŀ¼�ָ�������ת��
!4:: 
path := CopySelection()
if path = 
    return
MouseGetPos,x0
clipboard = "%path%"
StringReplace, clipboard, clipboard, \, \\, All
tooltip Text: %clipboard% copied
loop
{
    MouseGetPos,x1 ;���Ų��ȡ����ʾ��
    if x1!=%x0%
    { 
        tooltip
        break
    }
}
return

;;Ctrl+Alt+O: Treat selected text as a local path, and select it in Explorer.
^!o::
path := CopySelection()
path := Trim(path)
ifExist, %path%
{
	cmd := "explorer.exe /select," path
	Run, %cmd%
}
else
	MsgBox, Please select a path text.
return

;;http://www.autohotkey.com/board/topic/79494-go-to-anything-browseexploregoogle-the-selected-text/
;; Go to anything that is in the currently selected text: URLs, email addresses, Windows paths, or just "Google it"
$#G::
    ;Tip("Clipping...")  ;; include my mouse-tip library for this https://gist.github.com/2400547
    clip := CopyToClipboard()
    if (!clip) {
        return
    }
    addr := ExtractAddress(clip)
    if (!addr)
    {
        ; Google it
        ;Tip("Searching for [" SubStr(clip, 1, 50) "] ...")
        addr := "http://www.google.com.hk/search?q=" . clip
    }
    else {
        ; Go to it using system's default methods for the address
        ;Tip("Going to " Substr(addr, 1, 25) " ...")
    }

    Run %addr%
    return

;; utility functions

;; Safely copies-to-clipboard, restoring clipboard's original value after
;; Returns the captured clip text, or "" if unsuccessful after 4 seconds
CopyToClipboard()
{
    ; Wait for modifier keys to be released before we send ^C
    KeyWait LWin
    KeyWait Alt
    KeyWait Shift
    KeyWait Ctrl

    ; Capture to clipboard, then restore clipboard's value from before capture
    ExistingClipboard := ClipboardAll
    Clipboard =
    SendInput ^{Insert}
    ClipWait, 4
    NewClipboard := Clipboard
    Clipboard := ExistingClipboard
    if (ErrorLevel)
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        ;Tip("The attempt to copy text onto the clipboard failed.")
        return ""
    }
    return NewClipboard
}

;; Extracts an address from anywhere in str.
;; Recognized addresses include URLs, email addresses, domain names, Windows local paths, and Windows UNC paths.
ExtractAddress(str)
{
    if (RegExMatch(str, "S)((http|https|ftp|mailto:)://[\S]+)", match))
        return match1
    if (RegExMatch(str, "S)(\w+@[\w.]+\.(com|net|org|gov|cc|edu|info))", match))
        return "mailto:" . match1
    if (RegExMatch(str, "S)(www\.\S+)", match))
        return "http://" . match1
    if (RegExMatch(str, "S)(\w+\.(com|net|org|gov|cc|edu|info))", match))
        return "http://" . match1
    if (RegExMatch(str, "S)([a-zA-Z]:[\\/][\\/\-_.,\d\w\s]+)", match))
        return match1
    if (RegExMatch(str, "S)(\\\\[\w\-]+\\.+)", match))
        return match1
    return ""
}

;Convert whatever's on the clipboard to plain text (no formatting) and then pastes.
#v:: 
Clip0 = %ClipBoardAll% 
ClipBoard = %ClipBoard% ; Convert to text 
Send ^v ; For best compatibility: SendPlay 
Sleep 50 ; Don't change clipboard while it is pasted! (Sleep > 0) 
ClipBoard = %Clip0% ; Restore original ClipBoard 
VarSetCapacity(Clip0, 0) ; Free memory 
Return

;Hitting Insert no longer puts me in "overstrike" mode.
;If I have text selected, it is appended to the clipboard (unlike CTRL+C, which replaces whatever is on the clipboard with your new selection).
Insert::
bak = %clipboard% ; Backup clipboard
clipboard = ; Empty clipboard
SendInput, ^c ; Send copy command
ClipWait, 1 ; Wait clipboard has content
clipboard = %bak%`r`n%clipboard% ; Append new content to old content's next line
return

;;��VS��Attach��IE
#p::
Send, !d
Sleep, 1000
Send, {Down 7}
Send, {Enter}
Sleep, 1000
Send, ie
return

#c::
CoordMode,Mouse,Screen
MouseGetPos,x0,, win_id, ctrl_id
WinGetTitle, win_title, ahk_id %win_id%
ControlGetText, ctrl_text, %ctrl_id%, ahk_id %win_id%
ActiveWinTitle := MouseIsOverTitlebar()
If ActiveWinTitle!=0 ;������Ǳ�����
{
    ToolTip, Window Title:"%win_title%" copied.
    clipboard=%win_title%
}
else ;������ǿؼ�
{
    if ctrl_text = 
        return
    ToolTip, Control Text:"%ctrl_text%" copied.
    clipboard=%ctrl_text%
}
loop
{
    MouseGetPos,x1 ;���Ų��ȡ����ʾ��
    if x1!=%x0%
    { 
        tooltip
        break
    }
}
return

MouseIsOverTitlebar(HeightOfTitlebar = 30)
{
    WinGetActiveStats,ActiveTitle,width,height,xPos,yPos
    MouseGetPos,x,y
    If ((x >= xPos) && (x <= yPos + width) && (y >= yPos) && (y <= yPos + HeightOfTitlebar))
        Return,%ActiveTitle%
    Else
        Return,false
}

#IfWinExist Megatops BinCalc
#b::
Send, ^c
WinActivate
WinWaitActive Megatops BinCalc
StringLower, cb, clipboard
if (SubStr(cb, 1, 2) = "0x") {

    Send ^h
}
else {
    Send ^d
}
Send ^v
return
#IfWinExist
#b::
Send, ^c
cb = %clipboard%
Run, D:\Portable\BinCalc\BinCalc.exe %cb%
return

;��ѡ�е�����ת��ΪHEX��ʽ�����Ƶ����а���
^!h::
SetFormat, IntegerFast, H
Send ^c
var := clipboard
var += 0
if (var = 0){
    return
}
MouseGetPos,x0
clipboard := var
tooltip %var%
SetTimer, RemoveToolTip, 5000
SetFormat, IntegerFast, d
return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
return
 
Esc::RapidHotkey("!{F4}",2)
~e::RapidHotkey("#e""#r",3) ;Run Windows Explorer
~LButton & RButton::RapidHotkey("Menu1""Menu2""Menu3",1,0.3,1)
Menu1:
Menu2:
Menu3:
MsgBox % A_ThisLabel
Return

;;��ȡ��������PATH��ֵ
;;EnvGet, OutputVar, Path

#t::
if (A_OSVersion = "WIN_XP")
    Run, C:\Documents and Settings\%A_UserName%\Local Settings\Application Data\Microsoft\VisualStudio\10.0\Extensions\Whole Tomato Software\Visual Assist X\
else if (A_OSVersion = "WIN_7")
    MsgBox, %A_UserName%
return

~LControl & WheelUp::  ; Scroll left.
ControlGetFocus, fcontrol, A
Loop 8  ; <-- Increase this value to scroll faster.
    SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
return

~LControl & WheelDown::  ; Scroll right.
ControlGetFocus, fcontrol, A
Loop 8  ; <-- Increase this value to scroll faster.
    SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
return

CapsLock::Send !{Tab}

#IfWinActive ahk_class CabinetWClass
; open ��cmd�� in the current directory
;
^+c::
OpenCmdInCurrent()
return
#IfWinActive
; Opens the command shell ��cmd�� in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.
;
OpenCmdInCurrent()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A
    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    ; Take the first element from the array
    full_path = %word_array1%
    ; strip to bare address
    full_path := RegExReplace(full_path, "Address: ", "")
    ; Just in case �C remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all
    IfInString full_path, \
    {
        Run, cmd /K cd /D "%full_path%""
    }
    else
    {
        Run, cmd /K cd /D "C:\"
    }
}
