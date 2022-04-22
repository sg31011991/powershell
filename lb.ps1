$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME," | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    

    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
       Get-AzLoadBalancer -ResourceGroupName $resourceGroupName | ForEach-Object{
       $lbName = $_.Name
       $FrontendIpConfigurationsName = $_.FrontendIpConfigurations.Name
       $PrivateIpAllocationMethod = $_.FrontendIpConfigurations.PrivateIpAllocationMethod
       $bpAddresspoolsname = $_.BackendAddressPools.Name
       $lbRuleName = $_.LoadBalancingRules.Name
       $lbnatprotocol = $_.LoadBalancingRules.Protocol
       $lbnatfip = $_.InboundNatRules.FrontendPort
       $lbnatbip = $_.InboundNatRules.BackendPort
       $sku = $_.sku.Name
       $probsname = $_.Probes.Name
       $probport = $_.Probes.Port
       $probprotocol = $_.Probes.Protocol
       Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName | ForEach-Object{

            $NSG = $_.Name
            $AttachedNIC = $_.Subnets
       "$subscriptionName,$subscriptionId,$resourceGroupName,$lbName,$FrontendIpConfigurationsName,$PrivateIpAllocationMethod,$bpAddresspoolsname,$lbRuleName,$lbnatprotocol,$lbnatfip,$lbnatbip,$sku,$probsname,$probport,$probprotocol,$NSG" | Out-File $oFile -Append -Encoding ascii

       }
       
       }
       
       
        }
