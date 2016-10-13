$MachineList= @()
$userlist=@()

$Database = Import-Csv C:\users\phil.guzman\Desktop\PCInventory.csv

$ExportList= Import-Csv 'C:\users\phil.guzman\Downloads\older machines.csv'

            
            foreach($Machine in $ExportList)
            {
            $MozyActionUsers= New-Object -TypeName PSObject 
        
     

           $MozyActionUsers  |Add-Member -MemberType NoteProperty -name Alias -Value $Machine.machine
           $MozyActionUsers | Add-Member -MemberType NoteProperty -Name "Last Update" -Value $Machine.'Last Update'
           $MozyActionUsers | Add-Member -MemberType NoteProperty -Name "Backed Up" -Value $Machine.'Backed Up'
           $MozyActionUsers | Add-Member -MemberType NoteProperty -Name "Site" -Value $Machine.'User Group'
           $MachineList += $MozyActionUsers
           
               
               
               foreach($i in $Database)
               {

               if($Machine.machine -eq $i.Alias)
               {
                    $MozyActionUsers | Add-Member -MemberType NoteProperty -name Systemuser -Value $i.systemuser 

               }
               
         
               }
               }