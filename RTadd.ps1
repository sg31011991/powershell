$RGNAME = "Demo-RG"
$Location = "EASTUS"
$RouteTableName = 'myRouteTablePublic'
$vnet = 'demo-vnet' 
$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
###Connect to subscription##### 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    Write-Host "connecting to $subscriptionName "

    ## Creating RG ##
    
  
    New-AzResourceGroup -Name $RGNAME -Location $Location
    Write-host "New RG has been created "
   
   $routeTablePublic = New-AzRouteTable `
  -Name $RouteTableName `
  -ResourceGroupName $RGNAME `
  -location $Location

   Get-AzRouteTable `
  -ResourceGroupName $RGNAME `
  -Name $RouteTableName `
  | Add-AzRouteConfig `
  -Name "ToPrivateSubnet" `
  -AddressPrefix 10.0.1.0/24 `
  -NextHopType "VirtualAppliance" `
  -NextHopIpAddress 10.0.2.4 `
 | Set-AzRouteTable

 $virtualNetwork = Get-AzVirtualNetwork -Name $vnet 
$virtualNetwork | Set-AzVirtualNetwork
Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork  $virtualNetwork  `
  -Name 'default' `
  -AddressPrefix 10.0.0.0/24 `
  -RouteTable  $routeTablePublic | `
Set-AzVirtualNetwork
