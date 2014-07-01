#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
IfNotExist,mpress.exe
{
	UrlDownloadToFile,http://www.matcode.com/mpress.219.zip,mpress.219.zip
	;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	Extract2Folder("mpress.219.zip",A_ScriptDir)

}
ExitApp
Extract2Folder(Zip, Dest="", Filename="")
{
    SplitPath, Zip,, SourceFolder
    if ! SourceFolder
        Zip := A_ScriptDir . "\" . Zip
    
    if ! Dest {
        SplitPath, Zip,, DestFolder,, Dest
        Dest := DestFolder . "\" . Dest . "\"
    }
    if SubStr(Dest, 0, 1) <> "\"
        Dest .= "\"
    SplitPath, Dest,,,,,DestDrive
    if ! DestDrive
        Dest := A_ScriptDir . "\" . Dest
    
    fso := ComObjCreate("Scripting.FileSystemObject")
    If Not fso.FolderExists(Dest)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
       fso.CreateFolder(Dest)
       
    AppObj := ComObjCreate("Shell.Application")
    FolderObj := AppObj.Namespace(Zip)
    if Filename {
        FileObj := FolderObj.ParseName(Filename)
        AppObj.Namespace(Dest).CopyHere(FileObj, 4|16)
    }
    else
    {
        FolderItemsObj := FolderObj.Items()
        AppObj.Namespace(Dest).CopyHere(FolderItemsObj, 4|16)
    }
}
