$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,VM_NAME,VM_NIC,VM_PatchStatus,VM_PIP,VM_PIPAllocationMethod,NSG" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    
     #(($vm.NetworkProfile.NetworkInterfaces.id) -split "/networkInterfaces/")[-1]
    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        
           Get-AzVM -ResourceGroupName $resourceGroupName | ForEach-Object{
            $VMName = $_.Name
            $NIC = (($_.NetworkProfile.NetworkInterfaces.id) -split "/networkInterfaces/")[-1]
            $PatchStatus = $_.PatchStatus
            }
            Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName  | ForEach-Object{
            $PublicIP = $_.IpAddress
            $PublicIpAllocationMethod = $_.PublicIpAllocationMethod
            Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName | ForEach-Object{

            $NSG = $_.Name
            $AttachedNIC = $_.NetworkInterfaces
            
           
             
              
         

            "$subscriptionName,$subscriptionId,$resourceGroupName,$VMName,$NIC,$PatchStatus,$PublicIP,$PublicIpAllocationMethod,$NSG" | Out-File $oFile -Append -Encoding ascii
        } 
    }
   }

    Write-Host "script executed successfully"
