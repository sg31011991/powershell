$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,AUTOMATION_ACC_NAME,PRINCIPAL_ID,ENCRYPTION,PUBLICNETWORKACCESS" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    
    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
    Get-AzAutomationAccount -ResourceGroupName $resourceGroupName | ForEach-Object{
     $Automationaccname = $_.AutomationAccountName
     $Principalid = $_.Identity.PrincipalId
     $encryption = $_.Encryption
     $publicNetworkAccess = $_.PublicNetworkAccess

   

    "$subscriptionName,$subscriptionId,$resourceGroupName,$Automationaccname,$Principalid,$encryption,$publicNetworkAccess" | Out-File $oFile -Append -Encoding ascii
       
       }
        }

        
    Write-Host "script executed successfully"

