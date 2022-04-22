$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,LB_NAME,FIP_NAME,PIP_AllocationMethod,Backendpool_Addresspool_Name,LB_Rules_Name,LB_NAT_PROTOCOL,SKU,PROB_NAME,PROB_PORT,PROB_PROTOCAL,NSG" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
       Get-AzApplicationInsights -ResourceGroupName $resourceGroupName | ForEach-Object{
       $Name = $_.Name
       $kind = $_.Kind
       $ApplicationId = $_.ApplicationId
       $PublicNetworkAccessForIngestion = $_.PublicNetworkAccessForIngestion
       $PublicNetworkAccessForQuery = $_.PublicNetworkAccessForQuery
       $RetentionInDays = $_.RetentionInDays
       
       "$subscriptionName,$subscriptionId,$resourceGroupName,$Name,$kind,$ApplicationId,$PublicNetworkAccessForIngestion,$PublicNetworkAccessForQuery,$RetentionInDays" | Out-File $oFile -Append -Encoding ascii
       
       
       }
       
       
        }
        
    Write-Host "script executed successfully"

 
