$MachineList= @()


$Database = Import-Csv C:\users\phil.guzman\Desktop\PCInventory.csv | Select-Object -Property alias,systemuser

$ExportList= Import-Csv 'C:\users\phil.guzman\Downloads\older machines (6).csv'


            foreach($Machine in $ExportList)
            {
            $properties = @{'Alias'=$Machine.Machine;
                                 'Last Update'=$Machine.'Last Update';
                                 'Backed Up'=$Machine.'Backed Up';
                                 'Site'=$Machine.'User Group'}

            $MozyActionUsers= New-Object -TypeName PSObject  -Property $properties
           

               foreach($i in $Database)
               {
               
               if($Machine.machine -eq $i.Alias)
               {
               

               
               $MozyActionUsers | Add-Member -MemberType NoteProperty -name Systemuser -Value $i.SystemUser 
                $MachineList += $MozyActionUsers
               }
               
         
               }
        
               }
                 