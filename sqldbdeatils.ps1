$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,SQLSERVER_NAME,SQL_DB_Name,SQL_Public_NW_Access,Restrict-outbound_Access" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        

      Get-AzSqlServer -ResourceGroupName $resourceGroupName | ForEach-Object{

      $SQLServerName = $_.ServerName
      $SQLPublicNetworkAccess = $_.PublicNetworkAccess
      $RestrictOutboundNetworkAccess = $_.RestrictOutboundNetworkAccess

      Get-AzSqlDatabase -ServerName $SQLServerName -ResourceGroupName $resourceGroupName | ForEach-Object{
      $DBname = $_.DatabaseName

     
      "$subscriptionName,$subscriptionId,$resourceGroupName,$SQLServerName,$DBname,$SQLPublicNetworkAccess,$RestrictOutboundNetworkAccess" | Out-File $oFile -Append -Encoding ascii
        
        } 
      }
   }

    Write-Host "script executed successfully"

      
