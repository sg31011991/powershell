
Param(
    [Parameter(Mandatory = $False)]
    [string]$PersonalToken = "riu4zubftxieoc5rasbwtl5mwcsbouhalzowmpxlemwzvobmj6ja",
    
    [Parameter(Mandatory = $False)]
    [string]$Organisation = "sgdemo0376",
    
    [Parameter(Mandatory = $False)]
    [string]$ProjectName = "demo-SL-LA",
 
    [Parameter(Mandatory = $False, ParameterSetName = 'Subscription')]
    [string]$SubscriptionId = "6b099473-a929-4cc7-9f5f-3d238112f0a3",

    [Parameter(Mandatory = $False, ParameterSetName = 'Subscription')]
    [string]$SubscriptionName = "Azure subscription 1",

    [Parameter(Mandatory = $False)]
    [string]$TenantId = "bb9d7afc-4ddc-42dd-8518-26777626a8df",
    
    [Parameter(Mandatory = $False)]
    [string]$ApplicationId = "1f98a4f7-5229-4374-b489-3d2d31cde869",
    
    [Parameter(Mandatory = $False)]
    [string]$ApplicationSecret = "JfC7Q~acTE.ozs4XtzJK28m3OmjBsYrO3Sf6f"
    
)

$AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($personalToken)")) }

## Get ProjectId
$URL = "https://dev.azure.com/$($organisation)/_apis/projects?api-version=6.0"
Try {
    $ProjectNameproperties = (Invoke-RestMethod $URL -Headers $AzureDevOpsAuthenicationHeader -ErrorAction Stop).Value
    Write-Verbose "Collected Azure DevOps Projects"
}
Catch {
    $ErrorMessage = $_ | ConvertFrom-Json
    Throw "Could not collect project: $($ErrorMessage.message)"
}
$ProjectID = ($ProjectNameproperties | Where-Object { $_.Name -eq $ProjectName }).id
Write-Verbose "Collected ID: $ProjectID"
$ConnectionName = "devopsapp"


    $data = @{
            SubscriptionId   = $SubscriptionId
            SubscriptionName = $SubscriptionName
            environment      = "AzureCloud"
            scopeLevel       = "Subscription"
            creationMode     = "Manual"
        }

# Create body for the API call
$Body = @{
    data                             = $data
    name                             = $ConnectionName
    type                             = "AzureRM"
    url                              = "https://management.azure.com/"
    authorization                    = @{
        parameters = @{
            tenantid            = $TenantId
            serviceprincipalid  = $ApplicationId
            authenticationType  = "spnKey"
            serviceprincipalkey = $ApplicationSecret
        
        }
        scheme     = "ServicePrincipal"
    }
    isShared                         = $false
    isReady                          = $true
    serviceEndpointProjectReferences = @(
        @{
            projectReference = @{
                id   = $ProjectID
                name = $ProjectName
            }
            name             = $ConnectionName
        }
    )
}

$URL = "https://dev.azure.com/$organisation/$ProjectName/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
$Parameters = @{
    Uri         = $URL
    Method      = "POST"
    Body        = ($Body | ConvertTo-Json -Depth 3)
    Headers     = $AzureDevOpsAuthenicationHeader
    ContentType = "application/json"
    Erroraction = "Stop"
}
try {
    Write-Verbose "Creating Connection"
    $Result = Invoke-RestMethod @Parameters
    Write-Host "$($Result.name) service connection created"
}
Catch {
    $ErrorMessage = $_ | ConvertFrom-Json
    Throw "Could not create Connection: $($ErrorMessage.message)"
}