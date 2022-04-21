$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,NAME,SKU,DISK_SIZE,NETWORK_ACCES_POLICY,PUBLIC_NETWORK_ACCESS,TIRE,ENCRYPTION_TYPE,DISK_STATE" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        
         Get-AzDisk -ResourceGroupName  $resourceGroupName | ForEach-Object{
          
          $Name = $_.Name
          $sku = $_.sku.Name
          $disksize = $_.DiskSizeGB
          $NetworkAccessPolicy = $_.NetworkAccessPolicy
          $PublicNetworkAccess = $_.PublicNetworkAccess
          $tire = $_.Tier
          $EncryptionType = $_.Encryption.Type
          $DiskState = $_.DiskState
           "$subscriptionName,$subscriptionId,$resourceGroupName,$Name,$sku,$disksize,$NetworkAccessPolicy,$PublicNetworkAccess,$tire,$EncryptionType,$DiskState" | Out-File $oFile -Append -Encoding ascii
        
        }
        
      }  
        

     Write-Host "script executed successfully"

