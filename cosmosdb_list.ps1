$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,NAME,VNET_RULES,ENABLE_AUTO_FAILOVER,IP_RULE_ISReadOnly,PUBLIC_NETWORK_ACCESS,NETWORK_ACL_BYPASS,BACKUP_INTERVAL,BACKUP_TYPE" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        
         Get-AzCosmosDBAccount -ResourceGroupName  $resourceGroupName | ForEach-Object{
          
          $Name = $_.Name
          $Location = $_.Location
          $VirtualNetworkRules = $_.IsVirtualNetworkFilterEnabled
          $EnableAutomaticFailover = $_.EnableAutomaticFailover
          $IPRules_ISReadonly = $_.IpRules.IsReadOnly
          $PublicNetworkAccess = $_.PublicNetworkAccess
          $NetworkAclBypass = $_.NetworkAclBypass
          $NetworkAclBypassResourceIds = $_.NetworkAclBypassResourceIds.IsReadOnly
          $backupPolicy_interval = $_.BackupPolicy.BackupIntervalInMinutes
          $backupType = $_.BackupPolicy.BackupType

           "$subscriptionName,$subscriptionId,$resourceGroupName,$Name,$VirtualNetworkRules,$EnableAutomaticFailover,$IPRules_ISReadonly,$PublicNetworkAccess,$NetworkAclBypass,$backupPolicy_interval,$backupType" | Out-File $oFile -Append -Encoding ascii
        
        }
        
      }  
        

     Write-Host "script executed successfully"

