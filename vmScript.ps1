Set-Service -Name WSearch -StartupType Disabled
Stop-Service -name WSearch

Set-Service -Name Wlansvc -StartupType Disabled
Stop-Service -name wlansvc

Set-Service -Name wuauserv -StartupType Disabled
Stop-Service -name wuauserv

fsutil behavior set disablelastacess 1
fsutil 8dot3name set 1

powercfg /hibernate off

Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name DisablePagingExecutive -Value 1
