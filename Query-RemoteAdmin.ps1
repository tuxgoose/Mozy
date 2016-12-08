[CmdLetBinding()]
    Param(
    [Parameter(Mandatory=$True,HelpMessage="Please Enter a computer")]
              [string]$computer
         
          )

$query="Associators of {Win32_Group.Domain='$computer',Name='Administrators'} where Role=GroupComponent"

Get-CimInstance -Query $query -ComputerName $computer | Select-Object -Property caption | where -property caption -like SANDC\*