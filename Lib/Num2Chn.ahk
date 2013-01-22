#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Num2Chn(m)
{
    s := "" ,matchlen1 := "", match:="",ss:=""
    ChnNum := {1:"壹", 2:"贰", 3:"叁", 4:"肆", 5:"伍", 6:"陆", 7:"柒", 8:"捌", 9:"玖", 0:"零"}
    DecimalBit := {2:"拾", 3:"佰", 4:"仟", 5:"万", 6:"拾", 7:"佰", 8:"仟", 9:"亿", 10:"拾", 11:"佰", 12:"仟", 13:"兆",14:"拾",15:"佰",16:"仟",17:"京",18:"拾",19:"佰",20:"仟"}
    DD := {1:"角", 2:"分"}
    ;;去掉开头的0
    n:=LTrim(m , "0")
    ;;得到点前面数字个数用于循环
    if (regexmatch(n,"\.") > 0)
        regexmatch(n,"P)\..*",match)
    match > 0 ? (l := strlen(n) - match) : (l := StrLen(n))
    Loop, %l%
    {
        s .= (SubStr(n, A_Index, 1) <> 0)? ChnNum[SubStr(n, A_Index, 1)] . DecimalBit[l - A_Index + 1] : ChnNum[SubStr(n, A_Index, 1)]
        if (l - A_Index = 0)
            s := RegExreplace(s, "零+$", "$1") ;;去掉正数部分最后的零
        if (l - A_Index = 4)
        {
            s := RegExreplace(s, "零+$", "$1") ;;去掉万位之前末尾的零
            s := RegExReplace(s, "[^万]$", "$0万") ;;若万位之前不是以万结尾，则加上一个万
        }
        if (l - A_Index = 8)
        {
            s := RegExreplace(s, "零+$", "$1")
            s := RegExReplace(s, "[^亿]$", "$0亿")
        }
        if (l - A_index = 12)
        {
            s := RegExreplace(s, "零$", "$1")
            s := RegExreplace(s, "[^兆]$", "$0兆")
        }
        if (l - A_index = 16)
        {
            s := RegExreplace(s, "零$", "$1")
            s := RegExreplace(s, "[^京]$", "$0京")
        }
    }
    ss .= "圆"
    if (match = ""){
        ss .= "整"
    }
    else{
        loop, % match -1
            ss .= SubStr(n,l+1+A_index,1) <> 0 ? ChnNum[SubStr(n, l+1+A_Index, 1)] . DD[A_Index] : ChnNum[SubStr(n, l+1+A_Index, 1)]
    }
    ss:=LTrim(ss, "零")
    return, RTrim(RegExReplace(s . ss, "零+", "零"), "零")
}
