

Workflow Cycle{
$list = get-content C:\Mozy\dberror.txt
foreach -parallel($i in $list)
{



if(test-connection $i -count 1 -ErrorAction SilentlyContinue)
{
if(Get-WmiObject win32_computersystem)
{
#[string[]]$computers += $i
Write-Output "$i" | Out-file -filepath "C:\Mozy\Online.txt" -append
}
}
}
}



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

    Write-Host "Connecting to $computername" -ForegroundColor CYAN
    Write-Host "Process to create is $cmd" -ForegroundColor CYAN

    [wmiclass]$wmi="\\$computername\root\cimv2:win32_process"

    #bail out if the object didn't get created
    if (!$wmi) {return}

    $remote=$wmi.Create($cmd)

    if ($remote.returnvalue -eq 0) {
        Write-Host "Successfully launched $cmd on $computername with a process id of" $remote.processid -ForegroundColor GREEN
    }
    else {
        Write-Host "Failed to launch $cmd on $computername. ReturnValue is" $remote.ReturnValue -ForegroundColor RED
    }
}
Function OpenAll{
    $list = Get-Content C:\Mozy\Online.txt
    foreach($i in $list)
    {
    sleep -Seconds 60

    & C:\Users\phil.guzman\Desktop\CMTrace.exe "\\$i\C$\Program Files\MozyEnterprise\data\MozyEnterprise.log"
    }

}

#File that has a list of currupted Mozy Computers

Function Cycle2{
$list = Get-Content C:\Mozy\Online.txt
foreach($i in $list)
{

Write-Host $i


Set-Service -Name MozyEnterprisebackup -ComputerName $i -Status Stopped 
Invoke-Command -ComputerName $i -ScriptBlock {Stop-Process -Name mozy* -Force}

Start-Sleep -s 2
Remove-Item -path "\\$i\C$\Program Files\MozyEnterprise\Data\state.dat" 


Set-Service -Name MozyEnterprisebackup -ComputerName $i -Status Running

New-RemoteProcess -computername $i -cmd "C:\Program Files\MozyEnterprise\mozyenterpriseutil.exe /backup"
Write-Host  "$i Service has now changed" -ForegroundColor magenta



}


}

function LastReboot{
$list = Get-Content C:\Mozy\Online.txt

foreach($i in $list)
{

Write-warning $i
Get-CimInstance win32_operatingsystem -ComputerName $i | select  LastBootUpTime | ft -AutoSize

}
}
Cycle
#OpenAll
#Cycle2
#LastReboot