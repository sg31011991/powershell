$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,SUBSCRIPTION_TAG,RESOURCE_GROUP_NAME,RESOURCE_GROUP_TAG,RESOURCE_NAME,RESOURCE_TYPE,TAGS" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    $subs | ForEach-Object{ 
    if(!([string]::IsNullOrEmpty($subs.Tags))){
                $stags = @()
                $_.Tags.GetEnumerator() |ForEach-Object {
                    [string]$stags += $_.key+ "=" + $_.value+ ";"
                }
            }
            else{
                $stags = ""
            }

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        if(!([string]::IsNullOrEmpty($_.Tags))){
                $rgTag = @()
                $_.Tags.GetEnumerator() |ForEach-Object {
                    [string]$rgTag += $_.key+ "=" + $_.value+ ";"
                }
            }
            else{
                $rgtags = ""
            }

        Get-AzResource -ResourceGroupName $resourceGroupName | ForEach-Object{
            $resourceName = $_.Name
              
            $resourceType = $_.ResourceType
             
            if(!([string]::IsNullOrEmpty($_.Tags))){
                $tags = @()
                $_.Tags.GetEnumerator() |ForEach-Object {
                    [string]$tags += $_.key+ "=" + $_.value+ ";"
                }
            }
            else{
                $tags = ""
            }
             
            "$subscriptionName,$subscriptionId,$stags,$resourceGroupName,$rgTag,$resourceName,$resourceType,$tags" | Out-File $oFile -Append -Encoding ascii
        }
    }
}
    Write-Host "script executed successfully"
