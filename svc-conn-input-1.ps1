#GET https://dev.azure.com/{organization}/{project}/_apis/serviceendpoint/endpoints?type={type}&authSchemes={authSchemes}&endpointIds={endpointIds}&owner={owner}&includeFailed={includeFailed}&includeDetails={includeDetails}&api-version=5.1-preview.2
#create service connection

$Token = "2wmhqumlqhpqu5qo3v342ywqt4c6ez6bx43fpmiwbncytj4dnmuq"
$Organization = "sgdemo0376"
$ProjectName = "DEMO-SC-LA"

$Uri = ('https://dev.azure.com/{0}/{1}/_apis/serviceendpoint/endpoints?api-version=5.1-preview.2' -f $Organization, $ProjectName)
$SecureToken = [system.convert]::ToBase64String([system.text.encoding]::ASCII.GetBytes(":$($Token)"))
$Params = @{
    Uri         = $uri
    Headers     = @{
        Authorization = "Basic $SecureToken"
    } 
    method      = "GET"
    ContentType = "application/json"
}
$value = Invoke-RestMethod @Params
$objects = $value.value
$objects | ConvertTo-Json
########Required information from last part#######################
$subscriptionId = $Objects.data.subscriptionId | Select-Object -Unique
$subscriptionName = $Objects.data.subscriptionName | Select-Object -Unique
$serviceprincipalid = "1f98a4f7-5229-4374-b489-3d2d31cde869"
$tenantid = "bb9d7afc-4ddc-42dd-8518-26777626a8df"
$serviceprincipalkey = "JfC7Q~acTE.ozs4XtzJK28m3OmjBsYrO3Sf6f"
#_______________________Retreive the Azure DevOps Project Id_________________________________
$Url = ('https://dev.azure.com/{0}/_apis/projects?api-version=6.0' -f $Organization)
$SecureToken = [system.convert]::ToBase64String([system.text.encoding]::ASCII.GetBytes(":$($Token)"))
$Params = @{
    Uri         = $Url
    Headers     = @{
        Authorization = "Basic $SecureToken"
    } 
    method      = "GET"
    ContentType = "application/json"
}
$value = Invoke-RestMethod @Params
$object1 = $value.value
$Object = $object1.id

#__________________________________________________________________________________
$body = '{
 
  "administratorsGroup": null,
  "authorization": {
    "parameters": {
      "authenticationType": "spnKey",
      "serviceprincipalid": "' + $serviceprincipalid+ '",
      "tenantid": "' + $tenantid + '",
      "serviceprincipalkey": "' + $serviceprincipalkey + '"
    },
    "scheme": "ServicePrincipal"
  },
  "data": {
    "creationMode": "Manual",
    "environment": "AzureCloud",
    "scopeLevel": "Subscription",
    "subscriptionId": "' + $subscriptionId + '",
    "subscriptionName": "' + $subscriptionName + '"
  },
  "description": "Description - CloudSkills Sub",
  "groupScopeId": null,
  "isReady": true,
  "isShared": false,
  "name": "devopsapp",
  "operationStatus": null,
  "owner": "Library",
  "readersGroup": null,
  "serviceEndpointProjectReferences": [
    {
      "description": "Description - CloudSkills Sub",
      "name": "devopsapp",
      "projectReference": {
        "id": "' + $Object + '",
        "name": "' + $ProjectName + '"
      }
    }
  ],
  "type": "azurerm",
  "url": "https://management.azure.com/"

  }'
  
  #__________________________________________________________________________________________________________
 $Uri = ('https://dev.azure.com/{0}/{1}/_apis/serviceendpoint/endpoints?api-version=5.1-preview.2' -f $Organization, $ProjectName)
 $SecureToken = [system.convert]::ToBase64String([system.text.encoding]::ASCII.GetBytes(":$($Token)"))
 $Headers     = @{
        Authorization = "Basic $SecureToken"
    } 
     
  $response = Invoke-RestMethod -Method 'Post' -Uri $Uri -Headers $Headers -Body $body -ContentType "application/json"
 
  write-output $response
  write-host "Service Connection has been created Successfully" -ForegroundColor Green
  write-host " New Service Connection name : $($response.name)  " -ForegroundColor Cyan