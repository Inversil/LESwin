SetWorkingDir %A_ScriptDir%

SetTitleMatchMode, Regex
SetWorkingDir %A_ScriptDir%
SetDefaultMouseSpeed, 0
#KeyHistory 100
#SingleInstance Force
setmousedelay, -1 
setbatchlines, -1

;increase the loop count below to get more index entries

FileDelete, menuindex.ahk
Loop, 2000 {
if (indexcount = "")
	{
	indexcount := 0
	}	
indexcount := indexcount + 1

thing := indexcount ":"
FileAppend, %thing%`n, menuindex.ahk
thing := "queryname := % queryname"indexcount
FileAppend, %thing%`n, menuindex.ahk
thing := "Gosub, openplugin"
Fileappend, %thing%`n, menuindex.ahk
Fileappend, return`n, menuindex.ahk
}

msgbox, done!

exitapp