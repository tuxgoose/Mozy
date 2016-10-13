

[CmdLetBinding()]
    Param(
    [Parameter(Mandatory=$True,HelpMessage="Please Enter User Name(s)")]
              [string]$UserName,
          

    [Parameter(Mandatory=$True,HelpMessage="Please Enter ComputerName(s)")]
              [string]$ComputerName
          )


$UserName1=$UserName
$objUser = New-Object System.Security.Principal.NTAccount($Username)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SIDTranslation=$strSID.Value



Invoke-Command -scriptblock  ([ScriptBlock]::Create("Get-ChildItem Registry::\HKEY_Users\$SIDTranslation\network | Get-ItemProperty -Name Remotepath | ft remotepath, PSChildName")) -ArgumentList $SIDTranslation -ComputerName $ComputerName
