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
#Warn All, Off  ; Disable warnings (error dialog boxes being shown to user)
#singleinstance force ;force looping
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#----------------------------------------- End of header ------------------------------------------------------ 
;#----------------------------------------- Methods / functions below  ----------------------------------------- 

;general methods/functions 

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
	steam_move_window()
	steam_click_next()
	steam_click_next()
	steam_activate_product_code_field()
	steam_send_input(key)
	steam_click_next()
	steam_wait_until_done()
	if(steam_check_if_key_worked()){
		applog("[sucessfull] key activated without problems !")
		log_to_file(", 'success' => 'true'",false)
		;log_to_file("		<---- Activated",false)
	}else{
		applog("[faillure] key failed to activate !")
		log_to_file(", 'success' => 'false' ",false)
		;log_to_file("		<---- Failed",false)

	}
	applog("[end of this key]")
	return
}

;mouse and keyboard interactions

steam_click_next(){							;click the next button 
	steam_activate_window()
	MouseClick, left,  320,  575 ;click next
	applog("> clicked next 		[activation]")
	Sleep,100
	return
}
steam_click_cancel(){						;click the cancel button
	steam_activate_window()
	MouseClick, left,  422,  568 ;click cancel.
	applog("> clicked cancel 	[activation]")
	Sleep,100
	return
}
steam_click_back(){							;click the back button
	steam_activate_window()
	MouseClick, left,  212,  568 ;click back
	applog("> clicked back 		[activation]")
	Sleep,100
	return
}
steam_click_print(){						;click the print button
	steam_activate_window()
	MouseClick, left,  221,  407 ;click print
	applog("> clicked print		[activation]")
	Sleep,100
	return
}
steam_install_click_back(){ 				;install window click back
	steam_activate_install()
	MouseClick, left,  212,  568 ;click back
	applog("> clicked back  	[install]")
	Sleep,100
	return

}
steam_install_click_cancel(){ 				;install window click cancel
	steam_activate_install()
	MouseClick, left,  422,  568 ;click cancel.
	applog("> clicked cancel 	[install]")
	Sleep,100
	return
}
steam_install_click_next(){ 				;install window click next
	steam_activate_install()
	MouseClick, left,  320,  575 ;click next
	applog("> clicked next 		[install]")
	Sleep,100
	return
}
steam_activate_product_code_field(){		;activate the product code field
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
	if(steam_check_invalid_or_too_many_attempts()){
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
		if(is_print_window()){
			applog("[new product] we activated a new product")
			log_to_file(", 'new product' => 'true'",false)
			;this means there is a print window & we closed it.
		}else{
			applog("[duplicate product] we activated a duplicate product")
			log_to_file(", 'new product' => 'false'",false)
			;this means there is a print window & we closed it.
		}
		steam_click_next() ;we click next (past print screen)
		applog("now we need to check if we are on the install screen")
		;in order to see if they key worked we need to check if we are on the install screen, if we are press cancel & report that the key worked
		if(steam_check_if_on_install_screen()){
			;normal cancel click won't work here
			steam_install_click_cancel()
			return true
		}else{
			;how would we end up here anway ?
			applog("/!\ ERROR ! /!\ Something went wrong after redeeming the key and canceling the installation !?")
			ExitApp
		}
	}
}
steam_check_invalid_or_too_many_attempts(){ ;check if steam is angry at us
	steam_activate_window()
	MouseMove, 61,  207 ;move mouse to the invalid link
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
	steam_activate_install()
	WinMove, 100, 100 ;lets move the window to the left.
	applog("moved install window to 100,100")
	Sleep,100
	WinGetTitle, WindowTitle,
	StringTrimLeft,gameTitle,WindowTitle,10
	applog("adding game title to key log")
	log_to_file(", 'game' => '" . gameTitle . "'",false)
	MouseMove, 80,  232 ;move mouse 
	applog("moved mouse to the dropdown")
	Sleep,100
	;MsgBox,"",A_Cursor
	If(A_Cursor = "IBeam"){
		applog("confirmed we are on the activation window")
		return true
	}else{
		applog("we are not on the install window ?!")
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
MsgBox, 64, Automation, Please do not touch the keyboard or mouse while the macro is running.`n(press escape to stop the program at any time)
IfExist, %A_WorkingDir%\keys.txt
{
	applog("found keys.txt")
	Loop, read, %A_WorkingDir%\keys.txt
	{
		Loop, parse, A_LoopReadLine, %A_Tab%
		{
			steam_activate_key(A_LoopField)
			Sleep,1000
		}
	}
	MsgBox, 64, Success!, We looped through the entire keys.txt file.
	run notepad %A_WorkingDir%\activation.log

}else{
	;add a keys.txt file plz
	applog("we did not find any keys in keys.txt ! ")
	MsgBox, 48, No keys.txt found !, Please add a keys.txt file in the root of this program.`n1 key per line.`nxxxx-xxxx-xxxx-xxxx
	run notepad %A_WorkingDir%\keys.txt
}
ExitApp
Escape::
applog("pressed escape!")
applog(" ----- App End ------")
ExitApp
Return


