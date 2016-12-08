[CmdLetBinding()]
    Param(
    [Parameter(Mandatory=$True,HelpMessage="Please Enter Computer Name(s)")]
              [string]$computer
          )

#reads admin input

$query ="Associators of {Win32_Group.Domain=''$computer''Name='Administrators'} where Role=GroupComponent"
get-wmiobject -query $query -computer $computer |Select @{Name="Members";Expression={$_.Caption}},@{Name="Type";Expression={([regex]"User|Group").matches($_.__CLASS)[0].Value}}

