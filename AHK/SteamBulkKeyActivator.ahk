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
	Sleep,1000
	WinWaitNotActive,Steam - Working
	steam_activate_window()
}
steam_activate_window(){					;activate the steam window
	WinWait, Product Activation, ;wait for the activation window to pop up
	IfWinNotActive, Product Activation, , WinActivate, Product Activation, ;if not active make active
	WinWaitActive, Product Activation, ;wait until active
	Sleep, 100 ;let windows recover a bit ! you slow piece of shit !
}
steam_close_all(){ 							;this will close the activation window (it should not be open in the first place !) 
	IfWinExist,Product Activation,
	{
		steam_activate_window()
		steam_click_back() ;click back 2 times to make sure we can cancel.
		steam_click_back()
		steam_click_cancel()
		return
	}
	IfWinExist,Install -,
	{
		WinWait, Install -, 
		IfWinNotActive, Install -, , WinActivate, Install -, 
		WinWaitActive, Install -, 
		MouseClick, left,  422,  568 ;click cancel.(we cant't use steam_click_cancel because this is not the activation window)
		Sleep,100
		return

	}

}
steam_check_if_key_worked(){ 				;check if steam key worked
	if(steam_check_invalid_or_too_many_attempts()){
		;Steam is whining (to many keys tries, or product code is invalid)
		steam_click_cancel()
		return false
	}else{
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
	If(A_Cursor = "Unknown"){
		return true
	}else{
		return false
	}
}
steam_check_if_on_install_screen(){			;check if we are on the install screen
	;steam_activate_window() <--- does not work, becuase title changed
	;name is "Install - Demolition Master 3D"
	WinWait, Install -, 
	IfWinNotActive, Install -, , WinActivate, Install -, 
	WinWaitActive, Install -, 
	WinMove, 100, 100 ;lets move the window to the left.
	Sleep,100
	WinGetTitle, gameTitle,
	MsgBox, The game we activated is is "%gameTitle%".
	MouseMove, 80,  232 ;move mouse 
	MsgBox,"",A_Cursor
	If(A_Cursor = "IBeam"){
		MsgBox,"",installation screen found !
		return true
	}else{
		return false
	}
}
steam_click_next(){							;click the next button 
	steam_activate_window()
	MouseClick, left,  320,  575 ;click next
	Sleep,100
	return
}
steam_click_cancel(){						;click the cancel button
	steam_activate_window()
	MouseClick, left,  422,  568 ;click cancel.
	Sleep,100
	return
}
steam_click_back(){							;click the back button
	steam_activate_window()
	MouseClick, left,  212,  568
	Sleep,100
	return
}
steam_activate_product_code_field(){		;activate the product code field
	steam_activate_window()
	MouseClick, left,  40,  190  ;click Product code field
	Sleep, 100
	return
}
steam_move_window(){						;move the steam activation window
	steam_activate_window()
	WinMove, 0, 0 ;lets move the window to the left.
	Sleep,100
	return
}
steam_open_activation_window(){				;steam open the activation window
	Run steam://open/activateproduct
	Sleep,100
	return
}
steam_send_input(input){					;send text to the steam window
	steam_activate_window()
	SendInput {Raw}%input%
	Sleep,100
	return
}
;#----------------------------------------- Methods / functions above  ----------------------------------------- 
;Main code goes here !
steam_activate_key("testkey")
Escape::
ExitApp
Return


