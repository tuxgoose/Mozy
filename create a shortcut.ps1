

$TargetFile = "C:\Program Files\Microsoft Office 15\root\office15\SCANPST.EXE"

$ShortcutFile = "C:\Users\phil.guzman\Desktop\scanpst.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()