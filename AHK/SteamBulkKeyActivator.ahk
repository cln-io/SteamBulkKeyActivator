;   Copyright 2014 colingg (colin.gg)
;
;   Licensed under the Apache License, Version 2.0 (the "License");
;   you may not use this file except in compliance with the License.
;   You may obtain a copy of the License at
;
;       http://www.apache.org/licenses/LICENSE-2.0
;
;  Unless required by applicable law or agreed to in writing, software
;  distributed under the License is distributed on an "AS IS" BASIS,
;  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;  See the License for the specific language governing permissions and
;  limitations under the License.

;Variables> 	http://ahkscript.org/docs/Variables.htm#Cursor
;Gendocs >   	https://github.com/fincs/GenDocs
;OutPutDebug 	http://www.autohotkey.com/docs/commands/OutputDebug.htm
/*!
	Script: Steam Bulk Key Activator 1.0
		This script/macro allows you to activate steam keys in bulk,
		up to 25 keys at once (steam limit)

	Author: colingg 
	License: Apache License, Version 2.0
*/
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn All, Off  ; Disable warnings (error dialog boxes being shown to user)
#singleinstance force ;force looping
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#----------------------------------------- End of header ------------------------------------------------------ 
;#----------------------------------------- Methods / functions below  ----------------------------------------- 

;general methods/functions 

;~ ScreenFLow Notes

;~ 1 : Activation 1 basic info: click_btn(2, "next")
;~ 2 : Activation 2 subscriber agreement: click_btn(2, "i agree")
;~ 3 : Activation 3 product key: Enter Key and click_btn(2, "next")
;~ NOW 3 options and different flows (handled in steam_check_if_key_worked())
;~ 4a : Invalid Key or Too many attempts: click_btn(3, "cancel") ; check for link

;~ 4b : Already Owned: click_btn(2, "next") ; fall through case
;~ 4b1 : Install : click_btn(3, "cancel") 

;~ 4c : Success : click_btn(3, "finish") ; check for print

steam_activate_key(key){ 					;method that takes a string variable (the key) and places it into the key box of steam activator window
	if(key = ""){ ;check to make sure key is not empty
		applog("we got an empty key ? ignoring this one")
		return
	}
	applog("[start of a new key]")
	
	FormatTime, Time,, dd/MM/yyyy HH:mm:ss tt
	log_to_file("`n[" . Time . "] " . "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ",false)
	log_to_file("`n[" . Time . "] " . "'key' =>" . " '" . key . "'",false)
	steam_close_all()
	steam_open_activation_window()
	get_button_pos()
	steam_click_next() ;or click_btn(2)
	steam_click_iagree() ;or click_btn(2)
;	steam_activate_product_code_field()
	steam_send_input(key)
	;steam_click_next()
	steam_click_iagree() ;or click_btn(2)
	steam_wait_until_done()
	if(steam_check_if_key_worked()){
		applog("[sucessfull] key activated without problems !")
		log_to_file(", 'success' => 'true'",false)
	}else{
		applog("[faillure] key failed to activate !")
		log_to_file(", 'success' => 'false' ",false)
	}
	applog("[end of this key]")
	return
}

;mouse and keyboard interactions

get_button_pos() {
; button width = 465 - 374 = 91
buttonwidth := 91
; button height = 387 - 364 = 23
; button x spacing = 11
; button x offset (right) = 476 - 465 = 11
xoffset := 11
; button y offset (bottom) = 400 - 387 = 13
yoffset := 13
precision := 5
;based on above, button locations are:
; button 1 = BACK
;   right - (3*xoffset + 2*buttonwidth + precision), bottom - (yoffset + precision) 
; button 2 = NEXT, I AGREE
;   right - (2*xoffset + buttonwidth + precision), bottom - (yoffset + precision)
; button 3 = CANCEL, FINISH
;   right - (xoffset + precision), bottom - (yoffset + precision)
; THUS
steam_activate_window()
WinGetPos, , , wnWidth, wnHeight
global ypos := wnHeight - (yoffset + precision)
global xpos3 := wnWidth - (xoffset + precision)
global xpos2 := xpos3 - (xoffset + buttonwidth)
global xpos1 := xpos2 - (xoffset + buttonwidth)
;Test moving to those co-ordinates
Loop, 3 {
	MouseMove, xpos%A_Index%, ypos
	;MsgBox, , ,%xpos3% %ypos%
	Sleep, 100
}
}

click_btn(num, logmsg="") {
	global ypos, xpos1, xpos2, xpos3
	MouseClick, left, xpos%num%, ypos
	;TrayTip, , % Clicked xpos%num% ypos ;debug message
	if (logmsg != "") {
		applog(logmsg)
	}
}

steam_click_next(){							;click the next button 
	steam_activate_window()
	;MouseClick, left,  320,  575 ;click next
	Send {Tab}
	Sleep,100
	Send {Space}
	;click_btn(2,"> clicked next 		[activation]")
	Sleep,100
	return
}
steam_click_iagree(){							;click the next button 
	steam_activate_window()
	;MouseClick, left,  320,  575 ;click next
	;~ Send {Tab}
	;~ Sleep,100
	;~ Send {Tab}
	;~ Sleep,100
	;~ Send {Space}
	click_btn(2,"> clicked I Agree	[activation]")
	Sleep,100
	return
}
steam_click_cancel(){						;click the cancel button
	steam_activate_window()
	;MouseClick, left,  422,  568 ;click cancel.
	click_btn(3,"> clicked cancel 	[activation]")
	Sleep,100
	return
}
steam_click_back(){							;click the back button
	steam_activate_window()
	;MouseClick, left,  212,  568 ;click back
	click_btn(1,"> clicked back 		[activation]")
	Sleep,100
	return
}
steam_click_print(){						;click the print button
	steam_activate_window()
	MouseClick, left,  225,  275 ;click print *VARIABLE*
	applog("> clicked print		[activation]")
	Sleep,100
	return
}
steam_install_click_back(){ 				;install window click back
	steam_activate_install()
	;MouseClick, left,  212,  568 ;click back
	click_btn(1,"> clicked back  	[install]")
	Sleep,100
	return

}
steam_install_click_cancel(){ 				;install window click cancel
	steam_activate_install()
	;MouseClick, left,  422,  568 ;click cancel.
	;click_btn(3)
	;Send, {Esc}
	Send {Tab}
	Sleep,100
	Send {Tab}
	Sleep,100
	Send {Space}	
	applog("> clicked cancel 	[install]")
	Sleep,100
	return
}
steam_install_click_next(){ 				;install window click next
	steam_activate_install()
	;MouseClick, left,  320,  575 ;click next
	click_btn(2,"> clicked next 		[install]")
	Sleep,100
	return
}
steam_activate_product_code_field(){		;activate the product code field, maybe not necessary?
	steam_activate_window()
	MouseClick, left,  40,  190  ;click Product code field
	applog("> clicked product code field")
	Sleep, 100
	return
}
steam_send_input(input){					;send text to the steam window
	steam_activate_window()
	SendInput {Raw}%input%
	applog("> sent input to steam activation window")
	Sleep,100
	return
}

;window interactions

steam_activate_window(){					;activate the steam activation window
	WinWait, Product Activation, ;wait for the activation window to pop up
	IfWinNotActive, Product Activation, , WinActivate, Product Activation, ;if not active make active
	WinWaitActive, Product Activation, ;wait until active
	applog("waited and activated the steam activation window")
	Sleep, 100 ;let windows recover a bit ! you slow piece of shit !
}
steam_activate_install(){					;activate the installer window
	WinWait, Install -, 
	IfWinNotActive, Install -, , WinActivate, Install -, 
	WinWaitActive, Install -, 
	applog("waited for install window and activated it")
	Sleep,100
}
steam_wait_until_done(){					;steam working handler
	;we need to wait for steam to stop working before we continue
	applog("steam is working hold on ...")
	Sleep,1000
	WinWaitNotActive,Steam - Working
	applog("steam is done working !")
	;steam stopped freezing ! we can continue
}
steam_move_window(){						;move the steam activation window
	steam_activate_window()
	WinMove, 0, 0 ;lets move the window to the left.
	applog("moved steam activation window to 0,0")
	Sleep,100
	return
}
steam_open_activation_window(){				;steam open the activation window
	Run steam://open/activateproduct
	applog("activated steam url to open activation window")
	Sleep,100
	return
}
steam_close_all(){ 							;this will close the activation window (it should not be open in the first place !) 
	applog("requested to close all activation windows (and print)")
	IfWinExist,Product Activation,
	{
		applog("Activation window exists !")
		steam_activate_window()
		steam_click_back() ;click back 2 times to make sure we can cancel.
		steam_click_back()
		steam_click_cancel()
		WinKill,Product Activation,
		applog("closed the activation window")
		Sleep,1000
	}
	IfWinExist,Install -,
	{
		applog("Install window exists!")
		steam_activate_install()
		;cant use steam click,need installer clicks
		steam_install_click_cancel()
		WinKill,Install -,
		applog("Activated the install window and clicked cancel")
		Sleep,1000

	}
	IfWinExist,Print,
	{
		applog("Print is open, closing it")
		WinKill,Print,
		Sleep,1000
	}
	return

}
steam_check_if_key_worked(){ 				;check if steam key worked
	applog("we need to check if the key worked")
	if(steam_check_invalid_or_too_many_attempts()){ ;4a
		applog("product code invalid or to many key tries")
		;Steam is whining (to many keys tries, or product code is invalid)
		steam_click_cancel()
		return false
	}else{
		applog("steam reports that our key is valid")
		;steam is happy !
		;make a difference between existing product and new product.
		;we need to press the print button & close that window again
		applog("checking if this is a new product")
		steam_click_print()
		if(is_print_window()){ ;4c
			applog("[new product] we activated a new product")
			log_to_file(", 'new product' => 'true'",false)
			;this means there is a print window & we closed it.
			click_btn(3,"> clicked Finish 	[activation]")
			return true
		}else{ ;4b
			applog("[duplicate product] we activated a duplicate product")
			log_to_file(", 'new product' => 'false'",false)
			;this means there is no print window
			click_btn(2,"> clicked next [activation]")
			Sleep,100
			steam_check_if_on_install_screen()
			click_btn(3,"> clicked Cancel 	[Install]")
			return true
		}
	}
}
steam_check_invalid_or_too_many_attempts(){ ;check if steam is angry at us
	steam_activate_window()
	MouseMove, 61,  207 ;move mouse to the invalid link *VARIABLE*
	applog("moved mouse to check if there is an invalid link")
	Sleep,100
	If(A_Cursor = "Unknown"){
		applog("key is bad")
		return true
	}else{
		applog("key is good")
		return false
	}
}
steam_check_if_on_install_screen(){			;check if we are on the install screen
	applog("checking if we are on the install window")
	;steam_activate_window() <--- does not work, because title changed
	IfWinExist,Install -,
	{
		steam_activate_install()
		;WinMove, 100, 100 ;lets move the window to the left.
		;applog("moved install window to 100,100")
		Sleep,100
		WinGetTitle, WindowTitle,
		StringTrimLeft,gameTitle,WindowTitle,10
		applog("adding game title to key log")
		log_to_file(", 'game' => '" . gameTitle . "'",false)
		return true
	}else{
		Sleep,100
		return false
	}

}
is_print_window(){							;way to check if we have a new product or a duplicate
	applog("waiting 5 seconds for the print window to pop up")
	WinWait, Print,,5 ;wait 5 seconds.
	if ErrorLevel
	{
		applog("did not get a print window within 5 seconds")
		return false
	}else{
		IfWinNotActive, Print, WinActivate, Print,
		WinWaitActive, Print,
		WinKill,Print,
		applog("Print window was open, we closed it")
		Sleep,100
		return true
	}
}
;generic functions here

log_to_file(text,newline){					;log to the keys file.
	if(newline){
		FileAppend,%text%`n, %A_WorkingDir%\activation.log
		return
	}else{
		FileAppend,%text%, %A_WorkingDir%\activation.log
		return
	}
}
applog(text){								;log to the application file
	FormatTime, Time,, dd/MM/yyyy HH:mm:ss tt
	FileAppend, %Time% %text%`n, %A_WorkingDir%\app.log
}

MultiLineInput(Text:="Waiting for Input") {
    Global MLI_Edit
    Gui, Add, Edit, vMLI_Edit x2 y2 w596 r27
    Gui, Add, Button, gMLI_OK x1 y368 w299 h30, &OK
    Gui, Add, Button, gMLI_Cancel x301 y368 w299 h30, &Cancel
    Gui, Show, h400 w600, %Text%
	SendMessage, 0xB1, 0, -1, Edit1, A
    Goto, MLI_Wait
    MLI_OK:
        GuiControlGet, MLI_Edit
    MLI_Cancel:
    GuiEscape:
        ReturnNow := True
    MLI_Wait:
        While (!ReturnNow)
            Sleep, 100
    Gui, Destroy
    Return %MLI_Edit%
}

;#----------------------------------------- Methods / functions above  ----------------------------------------- 
;Main code goes here !
applog("")
applog("")
applog("")
applog(" ----- App start ------")
applog(" ----- some info ------")
applog("AHK version =>" . A_AhkVersion)
applog("OS Type     =>" . A_OSType)
applog("OS Version  =>" . A_OSVersion)
applog("is x64      =>" . A_Is64bitOS)
applog("is elevated =>" . A_IsAdmin)
applog(" ---- console log -----")
;MsgBox, 64, Automation, Please do not touch the keyboard or mouse while the macro is running.`n(press escape to stop the program at any time)
IfExist, %A_WorkingDir%\keys.txt
{
	applog("found keys.txt")
	FileRead, keytext, %A_WorkingDir%\keys.txt
	;Loop, read, %A_WorkingDir%\keys.txt
	;{
	;	Loop, parse, A_LoopReadLine, %A_Tab%
	;	{
	;		if(RegExMatch(A_LoopField,"^\w{5}-\w{5}-\w{5}$")){
	;			steam_activate_key(A_LoopField)
	;			Sleep,1000
	;		}
	;	}
	;}
	MsgBox, 64, Success!, %keytext% ;We looped through the entire keys.txt file.
	;run notepad %A_WorkingDir%\activation.log

}else{
	;add a keys.txt file plz
	applog("we did not find any keys in keys.txt ! ")

	keytext:=MultiLineInput("Enter keys here or into keys.txt and restart.")

	;MsgBox, 48, No keys.txt found !, Please add a keys.txt file in the root of this program.`n1 key per line.`nxxxx-xxxx-xxxx-xxxx
	;run notepad %A_WorkingDir%\keys.txt
}

Loop, parse, keytext, `n, `r
{
	if(RegExMatch(A_LoopField,"^\w{5}-\w{5}-\w{5}$")){
		steam_activate_key(A_LoopField)
		Sleep,1000
	}
}
run notepad %A_WorkingDir%\activation.log

applog("exiting app! bye bye !")
applog(" ----- App End ------")
ExitApp
Escape::
applog("pressed escape!")
applog(" ----- App End ------")
ExitApp
Return
