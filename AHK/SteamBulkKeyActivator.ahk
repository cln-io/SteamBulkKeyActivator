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
steam_activate_key(key){ 					;method that takes a string variable (the key) and places it into the key box of steam activator window
	if(key = ""){ ;check to make sure key is not empty
		return
	}
	FormatTime, Time,, dd/MM/yyyy hh:mm:ss tt
	log_to_file("`n[" . Time . "] " . "'key' =>" . "'" . key . "'",false)
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
		MsgBox, 64, Valid Key, Valid Key !
	}else{
		MsgBox, 16, Non valid key !, Non valid key`, we should log this !
	}
	return
}
steam_wait_until_done(){
	applog("steam is working hold on ...")
	Sleep,1000
	WinWaitNotActive,Steam - Working
	applog("steam is done working !")
}
steam_activate_window(){					;activate the steam window
	WinWait, Product Activation, ;wait for the activation window to pop up
	IfWinNotActive, Product Activation, , WinActivate, Product Activation, ;if not active make active
	WinWaitActive, Product Activation, ;wait until active
	applog("waited and activated the steam activation window")
	Sleep, 100 ;let windows recover a bit ! you slow piece of shit !
}
steam_close_all(){ 							;this will close the activation window (it should not be open in the first place !) 
	applog("requested to close all activation windows")
	IfWinExist,Product Activation,
	{
		applog("Activation window exists !")
		steam_activate_window()
		steam_click_back() ;click back 2 times to make sure we can cancel.
		steam_click_back()
		steam_click_cancel()
		applog("closed the activation window")
		return
	}
	IfWinExist,Install -,
	{
		applog("Install window exists!")
		WinWait, Install -, 
		IfWinNotActive, Install -, , WinActivate, Install -, 
		WinWaitActive, Install -, 
		MouseClick, left,  422,  568 ;click cancel.(we cant't use steam_click_cancel because this is not the activation window)
		applog("Activated the install window & > clicked cancel")
		Sleep,100
		return

	}

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
		steam_click_next() ;we click next
		if(steam_check_if_on_install_screen()){
			steam_click_cancel() ;click cancel on install screen.
			return true
		}else{
			;how would we end up here anway ?
			MsgBox, 16, Oops!, Something went wrong after redeeming the key and canceling the installation !?
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
	;steam_activate_window() <--- does not work, becuase title changed
	;name is "Install - Demolition Master 3D"
	WinWait, Install -, 
	IfWinNotActive, Install -, , WinActivate, Install -, 
	WinWaitActive, Install -, 
	applog("waited for install window and activated it")
	WinMove, 100, 100 ;lets move the window to the left.
	applog("moved install window to 100,100")
	Sleep,100
	WinGetTitle, WindowTitle,
	StringTrimLeft,gameTitle,WindowTitle,10
	MsgBox, The game we activated is is "%gameTitle%".
	MouseMove, 80,  232 ;move mouse 
	applog("moved mouse to the dropdown")
	Sleep,100
	MsgBox,"",A_Cursor
	If(A_Cursor = "IBeam"){
		applog("confirmed we are on the activation window")
		MsgBox,"",installation screen found !
		return true
	}else{
		applog("we are not on the install window ?!")
		return false
	}
}
steam_click_next(){							;click the next button 
	steam_activate_window()
	MouseClick, left,  320,  575 ;click next
	applog("> clicked next")
	Sleep,100
	return
}
steam_click_cancel(){						;click the cancel button
	steam_activate_window()
	MouseClick, left,  422,  568 ;click cancel.
	applog("> clicked cancel")
	Sleep,100
	return
}
steam_click_back(){							;click the back button
	steam_activate_window()
	MouseClick, left,  212,  568
	applog("> clicked back")
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
steam_send_input(input){					;send text to the steam window
	steam_activate_window()
	SendInput {Raw}%input%
	applog("> sent input to steam activation window")
	Sleep,100
	return
}
;steam functions above
;generic functions here
log_to_file(text,newline){
	if(newline){
		FileAppend,%text%`n, %A_WorkingDir%\activation.log
		return
	}else{
		FileAppend,%text%, %A_WorkingDir%\activation.log
		return
	}
}
applog(text){
	FormatTime, Time,, dd/MM/yyyy hh:mm:ss tt
	FileAppend, %Time% %text%`n, %A_WorkingDir%\app.log
}

#----------------------------------------- Methods / functions above  ----------------------------------------- 
;Main code goes here !
applog(" ----- App start ------")
applog(" ----- some info ------")
applog("AHK version =>" . A_AhkVersion)
applog("OS Type     =>" . A_OSType)
applog("OS Version  =>" . A_OSVersion)
applog("is x64      =>" . A_Is64bitOS)
applog("is elevated =>" . A_IsAdmin)
applog(" ---- console log -----")
steam_activate_key("key")
Escape::
applog("pressed escape!")
applog(" ----- App End ------")
ExitApp
Return


