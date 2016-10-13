$query = "SELECT System.ItemName, system.ItemPathDisplay, System.ItemTypeText, 
  System.Size FROM SystemIndex where CONTAINS(System.fileExtension,'.pst')"
$objConnection = New-Object -ComObject adodb.connection
$objrecordset = New-Object -ComObject adodb.recordset
$objconnection.open(
  "Provider=Search.CollatorDSO;Extended Properties='Application=Windows';")
$objrecordset.open($query, $objConnection)
Try { $objrecordset.MoveFirst() }
Catch [system.exception] { "no records returned" }
do 
{
 Write-host ($objrecordset.Fields.Item("System.ItemName")).value `
 ($objrecordset.Fields.Item("System.ItemPathDisplay")).value `
 ($objrecordset.Fields.Item("System.ITemTypeText")).value `
 ($objrecordset.Fields.Item("System.Size")).value
 $total+= ($objrecordset.Fields.Item("System.size")).value
 if(-not($objrecordset.EOF)) {$objrecordset.MoveNext()}
} Until ($objrecordset.EOF)


write-host ($total, "KB")
$total=0;
$objrecordset.Close()
$objConnection.Close()
$objrecordset = $null
$objConnection = $null
[gc]::collect()