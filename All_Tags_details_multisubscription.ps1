connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,SUBSCRIPTION_TAG,TAG_COUNT" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId
        if(!([string]::IsNullOrEmpty($_.Tags))){
                $stags = @()
                $_.Tags.GetEnumerator() |ForEach-Object {
                    [string]$stags += $_.key+ "=" + $_.value+ ";"
                }
            }
            else{
                $stags = ""
            }

    
   
             
            "$TenentID,$subscriptionName,$subscriptionId,$stags,$tagcount" | Out-File $oFile -Append -Encoding ascii
        }
    


Write-Host "script executed successfully" -ForegroundColor Green
