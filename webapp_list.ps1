$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,HOSTNAME,STATE,ClientAffinity,Client_Certificate,HTTP_only,KIND,VIRTUAL_APPLIANCE,LOADBALANCER,VNET,VNET_ROUTE_ENABLE,IP_SECURITY,PUBLIC_NETWORK_ACCESS" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    
    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
    Get-AzWebApp -ResourceGroupName $resourceGroupName | ForEach-Object{

    $hostname = $_.HostNames
    $State = $_.State
    $ClientAffinityEnabled = $_.ClientAffinityEnabled
    $ClientCertEnabled = $_.ClientCertEnabled
    $HttpsOnly = $_.HttpsOnly
    $kind = $_.Kind
    $va = $_.SiteConfig.VirtualApplications.IsReadOnly
    $lb = $_.SiteConfig.LoadBalancing.Value
    $vnet = $_.SiteConfig.VnetName
    $vnetrouteenable = $_.SiteConfig.VnetRouteAllEnabled
    $ipsecres = $_.SiteConfig.IpSecurityRestrictions.IsReadOnly
    $PublicNwAccess = $_.SiteConfig.PublicNetworkAccess

    "$subscriptionName,$subscriptionId,$resourceGroupName,$hostname,$State,$ClientAffinityEnabled,$ClientCertEnabled,$HttpsOnly,$kind,$va,$lb,$vnet,$vnetrouteenable,$ipsecres,$PublicNwAccess" | Out-File $oFile -Append -Encoding ascii
       
       }
        }

        
    Write-Host "script executed successfully"

 
