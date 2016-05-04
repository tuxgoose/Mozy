       <# ----------------------------------------------------------------------------

 Original Author: Phillip Guzman

   Creation Date: 03/03/2014

   Script Function: Repairs DBErrors in Mozy Enterprise

   Modified By:

   Revision History:


#>
[CmdLetBinding()]
    Param(
    [Parameter(Mandatory=$True,HelpMessage="Please Enter Compputer Name(s)")]
              [string[]]$Computers
          )

#reads admin input
cls




#$StringName= $ComputerToFixName




#Allows you to start processe's on Remote Machines
Function New-RemoteProcess {
    Param([string]$computername=$env:computername,
        [string]$cmd=$(Throw "You must enter the full path to the command which will create the process.")
    )

    $ErrorActionPreference="SilentlyContinue"

    Trap {
        Write-Warning "There was an error connecting to the remote computer or creating the process"
        Continue
    }    

    Write-Output "Connecting to $computername" -ForegroundColor CYAN
    Write-Output "Process to create is $cmd" -ForegroundColor CYAN

    [wmiclass]$wmi="\\$computername\root\cimv2:win32_process"

    #bail out if the object didn't get created
    if (!$wmi) {return}

    $remote=$wmi.Create($cmd)

    if ($remote.returnvalue -eq 0) {
        Write-Output "Successfully launched $cmd on $computername with a process id of" $remote.processid -ForegroundColor GREEN
    }
    else {
        Write-Output "Failed to launch $cmd on $computername. ReturnValue is" $remote.ReturnValue -ForegroundColor RED
    }
}




foreach($i in $Computers)
{

$Computers=$i




function repair{
(Get-WmiObject -ComputerName $Computers -Class win32_computersystem).name
Set-Service -Name MozyEnterprisebackup -ComputerName $Computers -Status Stopped 
(Get-WmiObject Win32_Process -ComputerName $Computers| ?{ $_.ProcessName -match "mozy*" }).Terminate()

Invoke-Command -ComputerName $Computers -ScriptBlock {Stop-Process -Name mozy* -Force}

Remove-Item -path "\\$Computers\C$\Program Files\MozyEnterprise\Data\state.dat" 
Remove-Item -path "\\$Computers\C$\Program Files\MozyEnterprise\Data\changes.dat" 
Remove-Item -path "\\$Computers\C$\Program Files\MozyEnterprise\Data\resume.dat" 
#Remove-Item -path "\\$Computers\C$\Program Files\MozyEnterprise\Config\conf.dat" 

del "\\$Computers\C$\Program Files\MozyEnterprise\Data\cache.dat"


Set-Service -Name MozyEnterprisebackup -ComputerName $Computers -Status Running
New-RemoteProcess -computername $Computers -cmd "C:\Program Files\MozyEnterprise\MozyEnterprisestat.exe"
New-RemoteProcess -computername $Computers -cmd "C:\Program Files\MozyEnterprise\mozyenterpriseutil.exe /backup"
Write-Output  "$Computers Service has now changed" -ForegroundColor magenta
}

repair
& C:\Users\phil.guzman\Desktop\CMTrace.exe "\\$Computers\C$\Program Files\MozyEnterprise\data\MozyEnterprise.log"
#Uptime
}

