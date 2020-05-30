/*
* * * Compile_AHK SETTINGS BEGIN * * *

[AHK2EXE]
Exe_File=%In_Dir%\Live Enhancement Suite 1.3.1 (Captains hax).exe
Compression=0
No_UPX=1
Created_Date=1
[VERSION]
Set_Version_Info=1
Company_Name=Inverted Silence & Dylan Tallchief
File_Description=Live Enhancement Suite
File_Version=0.1.3.1
Inc_File_Version=0
Internal_Name=Live Enhancement Suite
Legal_Copyright=© 2019
Original_Filename=Live Enhancement Suite
Product_Name=Live Enhancement Suite (Captain's Hax)
Product_Version=0.1.3.1
[ICONS]
Icon_1=%In_Dir%\resources\blueico.ico
Icon_2=%In_Dir%\resources\blueico.ico
Icon_3=%In_Dir%\resources\redico.ico
Icon_4=%In_Dir%\resources\redico.ico
Icon_5=%In_Dir%\resources\redico.ico

* * * Compile_AHK SETTINGS END * * *
*/

; ^^^^^^^^^^^^^^^^^^
; this stuff up here are settings I use to compile the EXE file; appointing icons.. etc.

; Ok so, just to mentally prepare you: this source code is a complete mess. 
; I only really got into programming while writing this, so there's just dumb stuff happening all over.
; Live Enhancement Suite for windows was my first programming project, and you'll especially be able to see that the sections I wrote first. 
; They are the absolute worst to read.
; My apologies in advance.

; if you want to see organized code, look at the mac rewrite... But this?? nahhhhhhhhhhhhh

;-----------------------------------;
;		 AHK Setup stuff			;
;-----------------------------------;
#MaxThreadsPerHotkey 2

CoordMode, Menu, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, Regex
SetWorkingDir %A_ScriptDir%
SetDefaultMouseSpeed, 0
#InstallKeybdHook
#KeyHistory 100
#SingleInstance Force
setmousedelay, -1 
setbatchlines, -1
#UseHook
#MaxHotkeysPerInterval 400

OnExit, exitfunc

;-----------------------------------;
;		 Tray menu contents		;
;-----------------------------------;

;this sets up the tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Configure Settings, settingsini
Menu, Tray, Add, Configure Menu, menuini
Menu, Tray, Add,
Menu, Tray, Add, Donate, monatpls
Menu, Tray, Add,
Menu, Tray, Add, Website, website
Menu, Tray, Add, Manual, Manual
Menu, Tray, Add, Exit, quitnow
Menu, Tray, Default, Exit
Menu, Tray, insert, 9&, Reload, doreload

; // CPT - Removed quirky rando quotes
Menu, Tray, Tip, Ableton Live Enhancement Suite 1.3.1 (Captain Hack)

;-----------------------------------;
;		 Installation		;
;-----------------------------------;

FileReadLine, OutputVar, %A_ScriptDir%/resources/firstrun.txt, 1
;Checks if the first run file exists
;if it doesn't exist; this is the first run, so then do a bunch of initialization stuff.
if (ErrorLevel = 1 or !(OutputVar = 0)) 
{ 
    if !(InStr(FileExist("resources"), "D")) 
    { ;if the resources folder doesn't exist, check if there's other stuff in the current folder, otherwise spawn the text box.
        loop, %A_ScriptDir%\*.*,1,1
        {
            if (A_Index > 1) 
            {
                MsgBox,48,Live Enhancement Suite, % "You have placed LES in a directory that contains other files.`n LES will create new files when used for the first time.`n Please move the program to a dedicated directory."
                exitapp
            }
        }
    }
    
    if InStr(splitPath A_ScriptDir, "Windows\Temp") or InStr(splitPath A_ScriptDir, "\AppData\Local\Temp") 
    {
        MsgBox,48,Live Enhancement Suite, % "You executed LES from within your file extraction software.`nThis placed it inside of a temporary cache folder, which will cause it to be deleted by Windows' cleanup routine.`nPlease extract LES into its own folder before proceeding."
        exitapp
    }
    
    ;this part of the code extracts a bunch of resources from the .exe and puts them in the right spot
    FileCreateDir, resources
    
    FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
    FileInstall, settings.ini, %A_ScriptDir%/settings.ini
    FileInstall, changelog.txt, %A_ScriptDir%/changelog.txt
    
    MsgBox, 4, Live Enhancement Suite, Welcome to the Live Enhancement Suite!`nWould you like to add the Live Enhancement Suite to startup?`nIt won't do anything when you're not using Ableton Live.`n(This can be changed anytime)
    IfMsgBox, Yes
    {
        ;MsgBox You pressed Yes.
        loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
        {
            testforstartup := Instr(A_LoopReadLine, "addtostartup")
            if(testforstartup = 1) 
            {
                FileAppend, addtostartup = 1`n, %A_ScriptDir%/settingstemp.ini
                FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
            }
            else
            {
                FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
            }
        }
        goto, donewithintro
    }
    
    ;MsgBox You pressed No.
    loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
    {
        testforstartup := Instr(A_LoopReadLine, "addtostartup")
        if(testforstartup = 1) 
        {
            FileAppend, addtostartup = 0`n, %A_ScriptDir%/settingstemp.ini
            FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
        }
        else
        {
            FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
        }
    }
    donewithintro: ;this is the goto thats being used when the "intro" is done
    FileDelete,%A_ScriptDir%/resources/firstrun.txt
    FileAppend, 0,%A_ScriptDir%/resources/firstrun.txt
    FileDelete, %A_ScriptDir%/settings.ini
    FileMove, %A_ScriptDir%/settingstemp.ini, %A_ScriptDir%/settings.ini
    Sleep, 50
    settimer, tooltipboi, 1
    Sleep, 2
}

FileReadLine, OutputVar, %A_ScriptDir%\resources\firstrun.txt, 2
;msgbox % OutputVar
coolpath := A_ScriptFullPath
if (ErrorLevel = 1 or !(OutputVar = coolpath)) 
{
    ;msgbox, adding reg
    FileReadLine, line1, %A_ScriptDir%\resources\firstrun.txt, 1
    ;msgbox % line1
    FileReadLine, line2, %A_ScriptDir%\resources\firstrun.txt, 2
    if (Errorlevel = 0) 
    {
        RegDelete, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %line2%
    }
    FileDelete, %A_ScriptDir%/resources/firstrun.txt
    FileAppend, %line1%, %A_ScriptDir%/resources/firstrun.txt
    FileAppend, `n%A_ScriptFullPath%,%A_ScriptDir%/resources/firstrun.txt
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers, %A_ScriptFullPath%, ~ HIGHDPIAWARE
}

FileReadLine, OutputVar, settings.ini, 1
if (ErrorLevel = 1) 
{
    Msgbox, 4, Oops!, % "the settings.ini file is missing and is required for operation. Create new?"
    IfMsgBox, Yes
    {
        FileInstall, settings.ini, %A_ScriptDir%/settings.ini
    }
    else
    {
        exitapp
    }
}
FileReadLine, OutputVar, menuconfig.ini, 1
if (ErrorLevel = 1) 
{
    Msgbox, 4, Oops!, % "the menuconfig.ini file is missing and is required for operation. Create new?"
    IfMsgBox, Yes
    {
        FileInstall, menuconfig.ini, %A_ScriptDir%/menuconfig.ini
    }
    else
    {
        exitapp
    }
}
Outputvar := ;

sleep, 10

; updating the changelog.txt file with the one included in the current package
FileDelete, %A_ScriptDir%\changelog.txt
FileInstall, changelog.txt, %A_ScriptDir%\changelog.txt

;-----------------------------------;
;		 reading Settings.ini		;
;-----------------------------------;

; This next loop is the settings.ini "spell checker". As a lot of variables come from this text file. 
; It's important that all of them are present in the correct way; otherwise AHK might misbehave or do stupid stuff.
; I didn't really know how to make this work as a function back then so I just copy pasted the different checks for each of the values.
; Contrary to what it looks like, these are not all the same; not every field requires a 1 or a 0
loop, Read, %A_ScriptDir%\settings.ini
{
    
    line := StrReplace(A_LoopReadLine, "`r", "")
    line := StrReplace(line, "`n", "")
    
    if (RegExMatch(line, "autoadd\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "autoadd" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        autoadd := result[2]
    }
    
    ; // CPT - removed resetbrowsertobookmark code 
    
    if (RegExMatch(line, "windowedcompensationpx\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(RegExReplace(result[2], "[0-9]") = "") 
        {
            msgbox % "Invalid parameter for " . Chr(34) "windowedcompensationpx" . Chr(34) . ": the specified parameter is not a number. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        windowedcompensationpx := result[2]
    }
    
    if (RegExMatch(line, "disableloop\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "disableloop" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        disableloop := result[2]
    }
    
    ; // CPT - force ctrl-alt-s 
    ; remove quick markers
    
    if (RegExMatch(line, "middleclicktopan\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "middleclicktopan" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        middleclicktopan := result[2]
    }
    
    ; // CPT - 5/29/2020 - remove scrollspeed
    ; - remove addctrlshiftz
    ; - remove 0todelete
    ; - Remove absolute d & b
    
    if (RegExMatch(line, "enableclosewindow\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "enableclosewindow" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        enableclosewindow := result[2]
    }
    
    ; // CPT - 5/29/2020 - Remove vst shortcuts
    
    if (RegExMatch(line, "smarticon\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "smarticon" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        smarticon := result[2]
    }
    
    if (RegExMatch(line, "dynamicreload\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "dynamicreload" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        dynamicreload := result[2]
    }
    
    ; // CPT - 5/29/2020 - remove piano roll function
    
    if (RegExMatch(line, "enabledebug\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "enabledebug" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        enabledebug := result[2]
    }
    
    if (RegExMatch(line, "addtostartup\s=\s") != 0) 
    {
        result := StrSplit(line, "=", A_Space)
        if !(result[2] = 0 or result[2] = 1) 
        {
            msgbox % "Invalid parameter for " . Chr(34) "addtostartup" . Chr(34) . ". Valid parameters are: 1 and 0. The program will shut down now."
            run, %A_ScriptDir%\settings.ini
            exitapp
        }
        addtostartup := result[2]
    }
}

; // CPT - 5/28/2020 - removed resetbrowsertobookmark

; alright, so this section asks the user to update the settings.ini with the one included in the package if some values are missing.
; these are the values I deem "nescesary"
if ((autoadd = "") or (windowedcompensationpx = "") or (disableloop = "") or (middleclicktopan = "") or (smarticon = "") or (enabledebug = "") or (addtostartup = "")) 
{ 
    gosub, settingsinibad
}

; this section checks for the remaining variables; ones that were added in recent updates or betas. They aren't really nescesary for the program to function.
; In case you're wondering; missing variables default to a "false" response in AHK - so none of the features with missing settings.ini entries will work until you add them to the file.

; I never bothered to make a dynamic settings.ini file updater. Or some UI thing that would make this entire process more convoluted.
; Things like LES 1.2 and 1.3 were never supposed to happen so I didn't account for them - these are the crappy workarounds.

if ((dynamicreload = "") or (enableclosewindow = ""))
    Msgbox, 4, Oops!, % "It seems your settings.ini file is from an older version of LES.`nYou won't be able to use some of the new features added to the settings without restoring your settings.ini file to its default state. It is recommended you make a backup before you do. Reset settings?"
IfMsgBox Yes
{
    FileDelete, %A_ScriptDir%\settings.ini
    FileInstall, settings.ini, %A_ScriptDir%/settings.ini
    
    MsgBox, 4,Live Enhancement Suite, Would you like to add the Live Enhancement Suite to startup?`n(This can be changed anytime)
    IfMsgBox Yes
    {
        ;MsgBox You pressed Yes.
        loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
        {
            testforstartup := Instr(A_LoopReadLine, "addtostartup")
            if(testforstartup = 1) 
            {
                FileAppend, addtostartup = 1`n, %A_ScriptDir%/settingstemp.ini
                FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
            }
            else
            {
                FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
            }
        }
        goto, donelalalala
    }
    
    ;MsgBox You pressed No.
    loop, Read, %A_ScriptDir%/settings.ini, %A_ScriptDir%/settingstemp.ini
    {
        testforstartup := Instr(A_LoopReadLine, "addtostartup")
        if(testforstartup = 1) 
        {
            FileAppend, addtostartup = 0`n, %A_ScriptDir%/settingstemp.ini
            FileAppend, `;`	causes the script to launch on startup`n, %A_ScriptDir%/settingstemp.ini"
        }
        else
        {
            FileAppend, %A_LoopReadLine%`n, %A_ScriptDir%/settingstemp.ini
        }
    }
    donelalalala:
        FileDelete,%A_ScriptDir%/resources/firstrun.txt
        FileAppend, 0,%A_ScriptDir%/resources/firstrun.txt
        FileDelete, %A_ScriptDir%/settings.ini
        FileMove, %A_ScriptDir%/settingstemp.ini, %A_ScriptDir%/settings.ini
        Sleep, 50
        settimer, tooltipboi, 1
        Sleep, 2
    return
}
;-----------------------------------;
;		 Post-settings.ini stuff		;
;-----------------------------------;

if (enabledebug = 1) 
{ ;modifies the tray menu if enabledebug is enabled.
    Menu, Tray, Insert, 1&, Key History, listkeys
    Menu, Tray, Insert, 2&,
    Menu, Tray, Insert, 1&, Log, logstuff
    Menu, Tray, Default, Log
}

; speeeeeeeeeeeeeeeeeeeeeeeed
; This used to have a variable setting "superspeedmode", but it was depricated.
; I'm not sure why I haven't moved this to the start of the script.
setmousedelay -1 
setbatchlines -1

loop, 1
{ ;adding to startup (or not)
    if (addtostartup = 1) 
    {
        RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, Live Enhancement Suite, %A_ScriptDir%\%A_ScriptName%
    }
    if (addtostartup = 0) 
    {
        RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, Live Enhancement Suite
    }
}

; SetTimer, watchforopen, 1000

#IfWinActive ahk_exe Ableton Live.+ 
    ;-----------------------------------;
    ;		 Hotkeys main		;
    ;-----------------------------------;
    loop, 1
    { ;creating hotkeys
        if (disableloop = 1) 
        {
            HotKey, ^+m, midiclip
        }
        ; // CPT - 5/29/2020 - Remove piano roll function
        ; - Force ctrl-alt-s save method
        Hotkey, ^!s, savenewver
        ; // CPT - 5/29/2020 - remove 0todelete
        ; - remove quick markers
        
        Hotkey, !c, colortracks
        Hotkey, !x, cleartracks
        if (enableclosewindow = 1) 
        {
            Hotkey, ^w, closewindow
            Hotkey, ^!w, closeall
        }
        Hotkey, ^b, buplicate 
    }
    
    gosub, createpluginmenu
    
    ; // CPT - 5/29/2020 - Remove piano roll function 
    
    ;-----------------------------------;
    ;		 Double right click routine		;
    ;-----------------------------------;
    
    *~RButton::
        if (A_PriorHotkey <> "*~RButton" or A_TimeSincePriorHotkey > 400) 
        {
            KeyWait, RButton
            return
        }
        
        Show()
        WinKill, menu launcher
    return ;end of script's auto-execute section.
    
    
    ; the menu show routine 
    Show() 
    { 
        Global dynamicreload 
        if (!MX && !MY)
            MouseGetPos, MX, MY 
        ; // CPT - 5/29/2020 - Remove piano roll function 
        gosub, createpluginmenu
        Menu, ALmenu, Show, % MX, % MY 
    } 
    
    ;-----------------------------------;
    ;		 Hotkeys Mouse		;
    ;-----------------------------------;
    ; I'm using this syntax here; rather than "Hotkey", because for some reason this works on MX master mice and the "Hotkey" approach does not.
    ; I'm not sure if I'm doing something wrong but this is probably a bug; AHK pease fix?
    ; these are after the double right click routine because it ends the auto execute section of the script.
    ; if they were higher up, the nescesary "return" would end the auto-execute section of the script early.
    
    MButton:: 
    if (middleclicktopan = 1) 
    {
        Send {LControl down}{LAlt down}{LButton down}
    }
    return
    MButton Up::
        if (middleclicktopan = 1) 
        {
            Send {LControl up}{LAlt up}{LButton up}
        }
    return
    
    ; // CPT - 5/29/2020 - remove scrollspeed 
    ; // CPT - 5/29/2020 - remove pause feature
    
    ;-----------------------------------;
    ;		 reading menuconfig.ini		;
    ;-----------------------------------;
    
    ; Below here is the function that interprets the stuff inside of the menuconfig.ini file and turns it into a functional autohotkey menu.
    
    ; I made up the LES menu syntax improve accessibility. In hindsight I could've done some things better, but it's too late for that now.
    ; if I ever decide to overhaul this (or if someone else does), I would try to make a converter that can convert people's old configurations into a new syntax, along with the update.
    ; Seriously, I've seen people add a thousand items. That must take for ever...
    
    createpluginmenu: 
    ; this thing over here clears out all variables and folders from memory before rebuilding to prevent double entries while using dynamic reload.
    if (menuitemcount != "") 
    {
        menu, ALmenu, DeleteAll
        
        Array := ""
        menuitemcount := ""
        querycount := ""
        categoryname := ""
        configoutput := ""
        TestForContent := ""
        slashcount := ""
        counter := ""
        outputcount := ""
        historyi := ""
        table := trimArray(table)
        loop
        {
            if (historyi = "") 
            {
                historyi := 1
            }
            if (table[historyi] = "") 
            {
                break
            }
            menu, % table[historyi], DeleteAll
            historyi := historyi + 1
        }
        table := ""
        historyi := ""
    }
    
    table := []
    Array := Array()
    categorydest := Array()
    categoryname := Array()
    categorydest[1] := "ALmenu"
    depth := 1
    loop
    {
        FileReadLine, configoutput, menuconfig.ini, A_Index
        if (configoutput = "") 
        { ;checks if string is empty
            continue
        }
        TestForcontent := SubStr(configoutput, 1, 1)
        TestForContent := RegExReplace(TestForContent, ";", "ȶ") ; the way I used to check for stuff here is really dumb. Never fixed it because it works. I used these characters because I figured nobody would ever use them.
        if (TestForContent = "ȶ") 
        { ;checks if line is comment
            continue
        }
        TestForcontent := SubStr(configoutput, 1)
        TestForContent := RegExReplace(TestForContent, "Readme", "þ")
        if (TestForContent = "þ") 
        { ;checks if line is Readme
            Menu, ALmenu, Add, Readme, readme
            continue
        }
        TestForContent := SubStr(configoutput, 1)
        TestForContent := RegExReplace(TestForContent, "/nocategory", "ȴ")
        if (TestForContent = "ȴ") 
        { ;checks if line is /nocategory
            CategoryHeader := 0
            NoCategoryHeader := 1
            continue
        }
        TestForContent := SubStr(configoutput, 1)
        TestForContent := RegExReplace(TestForContent, "--", "ȴ")
        if (TestForContent = "ȴ") 
        { ;checks if line is --
            if (NoCategoryHeader = 1) 
            { ;is the item in or out of a category?
                Menu, ALmenu, Add
                CategoryHeader := 0
                continue
            }
            if (CategoryHeader = 1) 
            {
                Menu, % categoryname[depth], Add
            }
            else
            {
                Menu, ALmenu, Add
            }
            continue
        }
        TestForContent := RegExReplace(TestForContent, "—", "ȴ")
        if (TestForContent = "ȴ") 
        { ;checks if line is --
            if (NoCategoryHeader = 1) 
            { ;is the item in or out of a category?
                Menu, ALmenu, Add
                CategoryHeader := 0
                continue
            }
            if (CategoryHeader = 1) 
            {
                Menu, % categoryname[depth], Add
            }
            else
            {
                Menu, ALmenu, Add
            }
            continue
        }
        slashcount := RegExMatch(TestForcontent, "/[^/;]+") 
        if (slashcount > 0) 
        { ; tests if line is category
            depth := slashcount
            categoryname[depth] := SubStr(configoutput, (slashcount + 1))
            if (depth > 1) 
            {
                categorydest[depth] := categoryname[(depth - 1)]
            }
            ;Msgbox % categoryname[depth] . " and depth = " . depth
            if (historyi = "") 
            {
                historyi := 1
            }
            historyi := (historyi + 1) ; history keeps track of all the subcategory names so they can properly be cleared later.
            table[historyi] := categoryname[depth]
            
            CategoryHeader := 1
            NoCategoryHeader := 0
            continue
        }
        TestForContent := SubStr(configoutput, 1)
        TestForContent := RegExReplace(TestForContent, "\.\.", "ȴ")
        if (TestForContent = "ȴ") 
        { ;checks if line is ..
            depth := depth - 1
            if (depth = 0) 
            {
                depth := 1
                CategoryHeader := 0
                NoCategoryHeader := 1
            }
            continue
        }
        if (configoutput = "End" or configoutput = "END" or configoutput = "end") 
        { ;checks for the end of the config file
            break
        }
        
        ;// Below this line is the stuff that happens when the config is is actually outputting entries and it's not just configuration or empty lines
        {
            if (outputcount = "") ;counting how many times the config has output menu entries
                outputcount := 1
        }
        outputcount := outputcount + 1
        counter := outputcount/2
        if (counter ~= "\.0+?$|^[^\.]$") 
        {	; on titles only
            configoutput := StrReplace(configoutput, "&", "&&") 
        }
        
        Array[A_Index] := configoutput ;putting the output in an array
        
        if (counter ~= "\.0+?$|^[^\.]$") 
        {	; on titles only
            actionname:= RegExReplace(configoutput, "^.*?,")
            
            if (menuitemcount = "") ;counting how many items the config has output
            {
                menuitemcount := 0
            }
            menuitemcount := menuitemcount + 1
            
            if (NoCategoryHeader = 1) 
            {
                Menu, ALmenu, Add, % Array[A_Index], % menuitemcount
                CategoryHeader := 0
            }
            if (CategoryHeader = 1) 
            {
                Menu, % categoryname[depth], Add, % Array[A_Index], % menuitemcount
                Menu, % categorydest[depth], Add, % categoryname[depth], % ":" . categoryname[depth]
            }
            else
            {
                Menu, ALmenu, Add, % Array[A_Index], % menuitemcount
            }
        }
        else
        {
            if (querycount = "") 
            { ;counting in order to figure out if config output is a menu item name or a search query
                querycount := 0
            }
            querycount := querycount + 1
            queryname%querycount% := Array[A_Index]
        }
    } 
    return 
    
    ; Alright, hear me out.
    ; This right here, is my biggest programming sin.
    ; I was actually hoping nobody would ever have to see this.
    ; I'm so sorry
    
    ; This "library" below here contains 2000 numerical variables labeled 1 through 2000.
    ; When you click a menu item in AHK, it will ALWAYS perform a "gosub", which is basically the same as a goto except it can go back to whatever it was doing beforehand once it's done.
    ; A goto can only go to a label, and AHK does not support dynamic labels.
    ; I have no idea what people will name their menu entries so I thought of the infamous minecraft item ID system and picked it as a "solution". 
    ; I printed out a 4000 line AHK script that's nothing but goto markers with two lines of repeated code each.
    ; None of this code is actually executed unless a menu item is clicked; so I moved it to a library to debloat my code.
    ; I would be greatful if you could figure out a better way to do this, but right now; I'm going to keep sinning. Sinning hard forever.
    #include menuindex.ahk
    
    
    ;-----------------------------------;
    ;		 Opening a plugin		;
    ;-----------------------------------;
    
    
    openplugin: ;you would think consistently typing something in the ableton search bar would be easy 
    Send,{ctrl down}{f}{ctrl up}
    Sendinput % queryname
    WinWaitActive, ExcludeText - ExcludeTitle, , 0.5 ; prevents the keystrokes from desynchronizing when ableton lags during the search query.
    
    if (pressingalt = 1) 
    {
        if (GetKeyState("Lctrl", p) = 0) 
        {
            tempautoadd := autoadd
        }
    }
    if (GetKeyState("Lctrl", p) = 1) 
    {
        if (autoadd = 1) 
        {
            tempautoadd := 0
        }
        else
        {
            tempautoadd := 1
        }
    }
    else
    {
        tempautoadd := autoadd
    }
    
    
    if (tempautoadd = 1) 
    {
        sleep, 112
        Send,{down}{enter}
    }
    else
    {
        goto, skipautoadd
    }
    ; // CPT - 5/28/2020 - remove resetbrowsertobookmark
    ; MouseGetPos, posX, posY // not sure if needed
    
    SendInput, {Esc}
    SetTitleMatchMode, RegEx
    
    querynameclean := RegExReplace(queryname, "['""]+", "")
    StringLower, querynameclean, querynameclean
    ;msgbox, % querynameclean
    if (querynameclean = "analog" or querynameclean = "collision" or querynameclean = "drum rack" or querynameclean = "electric" or querynameclean = "external instrument" or querynameclean = "impulse" or querynameclean = "instrument rack" or querynameclean = "operator" or querynameclean = "sampler" or querynameclean = "simpler" or querynameclean = "tension" or querynameclean = "wavetable") or (querynameclean = "amp") or (querynameclean = "audio effect rack") or (querynameclean = "auto filter") or (querynameclean = "auto pan") or (querynameclean = "beat repeat") or (querynameclean = "cabinet") or (querynameclean = "chorus") or (querynameclean = "compressor") or (querynameclean = "corpus") or (querynameclean = "drum buss") or (querynameclean = "dynamic tube") or (querynameclean = "echo") or (querynameclean = "eq eight") or (querynameclean = "eq three") or (querynameclean = "erosion") or (querynameclean = "external audio effect") or (querynameclean = "filter delay") or (querynameclean = "flanger") or (querynameclean = "frequency shifter") or (querynameclean = "gate") or (querynameclean = "glue compressor") or (querynameclean = "grain delay") or (querynameclean = "limiter") or (querynameclean = "looper") or (querynameclean = "multiband dynamics") or (querynameclean = "overdrive") or (querynameclean = "pedal") or (querynameclean = "phaser") or (querynameclean = "ping pong delay") or (querynameclean = "redux") or (querynameclean = "resonators") or (querynameclean = "reverb") or (querynameclean = "saturator") or (querynameclean = "simple delay") or (querynameclean = "delay") or (querynameclean = "spectrum") or (querynameclean = "tuner") or (querynameclean = "utility") or (querynameclean = "vinyl distortion") or (querynameclean = "vocoder") or (InStr(querynameclean, ".adv") != 0) 
    {
        ; I could do this with an array instead but I'm too lazy and this works too so enjoy this 15km 'if' statement
        WinWaitActive, ExcludeText - ExcludeTitle, , 0.5
    return
}
else
{
    WinWaitActive, ahk_class (AbletonVstPlugClass|Vst3PlugWindow),,12
    WinGetTitle, piss, ahk_class (AbletonVstPlugClass|Vst3PlugWindow)
}
if (piss != "") 
{
    SetTitleMatchMode, 2
    WinActivate, Ableton
    SendInput, {Esc}
    sleep, 1
    WinActivate, %piss%
}
else
{
    SetTitleMatchMode, 2
}

skipautoadd:
    piss := ;
return
return

;-----------------------------------;
;		 Tray menu actions	& Readme	;
;-----------------------------------;

loop, 1 { ; (again, loop, 1 does nothing) 
    listkeys: ;these are built in AHK GUIs, so this simple command needed to be added to the tray menu as well.
    KeyHistory
return

logstuff:
    listlines
return

settingsini:
    run, %A_ScriptDir%\settings.ini
return

menuini:
    run, %A_ScriptDir%\menuconfig.ini
return

doreload:
    Reload
return 

; // CPT - 5/29/2020 - remove pause feature
; - remove Timer

website:
    run, https://enhancementsuite.me/
return

manual:
    run, https://docs.enhancementsuite.me/
return

monatpls: ;please gib monat
run, https://paypal.me/enhancementsuite
return

quitnow:
    exitapp
return
}

; the readme technically isn't a tray menu action, since it's no longer located there. It's now included in the plugin menu to attract more attention.
; the marker is still here though because idk where else to put it.

readme:
    MsgBox, 0, Readme, % "Welcome to the Live Enhancement Suite created by @InvertedSilence & @DylanTallchief 🐦`nDouble right click to open up the custom plug-in menu.`nClick on the LES logo in the menu bar to add your own plug-ins, change settings, and read our manual if you're confused.`nHappy producing : )"
return

;-----------------------------------;
;		 Hotkey actions		;
;-----------------------------------;

midiclip:
    Sendinput, {ctrl down}{ShiftDown}{m}{ShiftUp}{ctrl up}
    sleep, 1
    Sendinput, {ctrl down}{j}{ctrl up}
return

savenewver: 
; this section does the ctrl+alt+s command and also includes the section that tries to parse the filename in a way that makes sense.
; I'm not very good at these, but this spaghetti approach works 99% of the time, so it would be ok.
; Ever since LES 1.0, it's gone through many different iterations.
Errorlevel := ""
Sendinput, ^+s
SetTitleMatchMode, 2
WinWaitActive, ahk_class #32770,,2 ;this waits for the save dialog thing to show up.
if (ErrorLevel = 1) 
{
return
}

; // CPT - 5/29/2020 saveasnewver
BlockInput, On
ClipSaved := ClipboardAll
clipboard = ;
SendInput, {Ctrl down}{a}{Ctrl up}
SendInput, {Ctrl down}{c}{Ctrl up}
ClipWait ;
stuff := Clipboard
Clipboard := ClipSaved

if (InStr(Stuff, ".als")) 
{
    Sendinput, {right}
    sendinput, {Backspace 4}
    alsfound := 1
    StringTrimRight, Stuff, Stuff, 4
}
else
{
    alsfound := 0
}

if (Stuff = "Untitled") 
{ ;safeguard for if the user is trying to do something really unnescesary
    MsgBox, 4, Live Enhancement Suite, Your project name is "Untitled".`nAre you sure you want to save it as a new version?
    IfMsgBox Yes
    {
        goto enduntitledcycle
    }
    else
    {
        return
    }
}
return

enduntitledcycle:
    ; I don't know if this goto was nescesary or if it was a workaround to fix AHK jank - ...now I'm scared to remove it.
    
    EndPos := InStr(Stuff, "_", 0, 0) -1
    Stuff := SubStr(Stuff, (EndPos))
    
    if (InStr(Stuff, "_")) 
    {
        testforletterend := (SubStr(stuff, (0), 1))
        ;Msgbox % testforletterend
        if testforletterend is alpha
        {
            ;StringTrimRight, stuff, stuff, (1)
            ;stuff .= "."
            alphacharatend := 1
            ;numberstuff := % "_" . numberstuff
        }
        numberstuff := RegExReplace(stuff, "^.*?_")
        numberstuff := RegExReplace(numberstuff, "[^0-9, .]")
    }
    else
    {
        Numberstuff = ;
        goto nounderscore
    }
    
    if (extentioncompensation = 0) 
    {
        StringTrimRight, numberstuff, numberstuff, 1
    }
    Versionlength := StrLen(numberstuff)
    if (alphacharatend = 1) 
    {
        Versionlength := Versionlength + 1
    }
    
nounderscore:
    if (numberstuff = "") 
    { ; if the string is empty make it 1 and then tell it to skip deletion
        numberstuff := "1"
        skipflag := 1
    }
    numberstuff := numberstuff + 1 ; add 1 to the version number
    if (RegExMatch(numberstuff, "[., 0{5}]")) 
    { ; if theres a dot delete everything until after and including the dot
        SplitPath, numberstuff,,,,numberstuff
    }
    
    if !(InStr(Stuff, "_")) 
    {
        ;msgbox, yatta
        numberstuff := % "_" . numberstuff
        ;msgbox % numberstuff
    } 
    
    Sendinput, {Right 1}
    
    if (skipflag = 1) 
    {
        goto skipdel1
    }
    
    sleep, 5
    Sendinput, {ShiftDown}{Left %Versionlength%}{ShiftUp}
    SendInput, {BackSpace}
    
    sleep, 5
return

skipdel1:
    Sendinput % numberstuff
    Sendinput, {Enter}
    skipflag := 0
    alphacharatend := 0
    numberstuff = ;
    stuff = ;
    Blockinput, Off
return

return

; // CPT - 5/29/2020 - remove piano roll function 
; - remove 0todelete
; - remove vst shortcts


colortracks:
    MouseGetPos,,,guideUnderCursor
    WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
    if(InStr(WinTitle, "Ableton") != 0) 
    {
        Click, Right
        sleep, 20
        SendInput {up 2}
        SendInput {Enter}
    }
return

cleartracks:
    MouseGetPos,,,guideUnderCursor
    WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
    if(InStr(WinTitle, "Ableton") != 0) 
    {
        Click, Right
        sleep, 20
        SendInput {down 12}{enter}{delete}
    }
return

closewindow:
    Winget processnameoutput, ProcessName
    WinGetClass classnameoutput
    WinGetTitle, wintitleoutput
    SetTitleMatchMode, 3
    if (RegExMatch(processnameoutput, "Ableton")) 
    {
        if (RegExMatch(classnameoutput, "AbletonVstPlugClass") or RegExMatch(classnameoutput, "Vst3PlugWindow")) 
        {
            Winclose, %wintitleoutput%
            SetTitleMatchMode, 2
        }
    }
return

closeall:
    DetectHiddenWindows, Off
    WinGet windows, List
    SetTitleMatchMode, 3
    loop %windows%
    {
        id := windows%A_Index%
        Winget processnameoutput, ProcessName, ahk_id %id%
        WinGetClass classnameoutput, ahk_id %id%
        if (RegExMatch(processnameoutput, "Ableton")) 
        { 
            if (RegExMatch(classnameoutput, "AbletonVstPlugClass") or RegExMatch(classnameoutput, "Vst3PlugWindow")) 
            {
                Winclose, ahk_id %id%
                ;windowlist .= wt . "`n"
            }
        }
    }
    SetTitleMatchMode, 2
return

buplicate: ;brought to you by dylan tallchief
if (A_PriorHotkey != "^b" or A_TimeSincePriorHotkey > 1800 or A_PriorKey = Lbutton) 
{
    ; Too much time between presses, so this isn't a double-press.
    send {ctrl down}{d 7}{ctrl up}
return
}
send {ctrl down}{d 8}{ctrl up}
return

; // CPT - 5/29/2020 - remove vst shortcuts

settingsinibad:
    Msgbox, 4, Oops!, % "The settings.ini file is outdated or invalid and is required for operation. reset?`n(Make sure to make a copy of the old one before you click yes!)"
    IfMsgBox Yes
    {
        FileDelete, %A_ScriptDir%\settings.ini
        FileInstall, settings.ini, %A_ScriptDir%/settings.ini
    }
    else
    {
        Msgbox, The program will shut down now.
        exitapp
    }
return

; // CPT - 5/29/202 - remove timer

tooltipboi:
    SetTitleMatchMode, 2
    WinWaitActive, Ableton
    winget, ProcessID, PID, A
    if !(hProcess := DllCall("OpenProcess", "uint", 0x0400, "int", 0, "uint", ProcessID, "ptr")) 
    {
        MsgBox, 0, Live Enhancement Suite Admin Warning, % "Hey there!`n`nIt seems you're running Ableton Live as an Administrator, and this might prevent LES from doing anything. Please run Ableton Live without elevated permissions (since it allows you to import files from your desktop etc).`nIf you have a good reason to run Ableton Live as an Admin, please run LES as an Administrator as well, this way things will work as intended.`n`n(This notification will only show up once)"
    }
    Traytip, Live Enhancement Suite, Double right click anywhere in Live to bring up custom menus!, 5
    SetTimer, tooltipboi, Delete
return

exitfunc:
    exitapp
return

;==========================
;=	 imported functions =
;==========================

trimArray(arr) 
{ ; Hash O(n) https://stackoverflow.com/questions/46432447/how-do-i-remove-duplicates-from-an-autohotkey-array 
    hash := {}, newArr := []
    for e, v in arr {
        if (!hash[v]) 
        {
            hash[(v)] := 1, newArr.push(v)
        }
    }
return newArr
}
