
#####################Stop###############
clear-host
$serviceName = @("XboxNetApiSvc","XboxGipSvc","XblGameSave")
Get-Service -Name $serviceName
foreach($serviceNames in $serviceName){
$svc= Get-Service -Name $serviceNames
while ($svc.Status -ne "Stopped") 
                {              
                    Stop-Service $svc -Verbose                       
                    Start-Sleep -s 10
                    $svc.Refresh() 
                    if ($svc.Status -eq "Stopped") 
                    {
                        Set-Service -Name $svc.Name -StartupType Manual
                        Get-Service $svc.Name | Select-Object -Property Name, StartType, Status  
                        Write-Host $svc "is now stopped & $(Get-Service $svc.Name | Select-Object -Property StartType) " -ForegroundColor Green 
                    }
                }


}
####################STart#############
clear-host
$serviceName = @("XboxNetApiSvc","XboxGipSvc","XblGameSave")
Get-Service -Name $serviceName
foreach($serviceNames in $serviceName){
$svc= Get-Service -Name $serviceNames
while ($svc.Status -ne "Running") 
                {              
                    Stop-Service $svc -Verbose                       
                    Start-Sleep -s 10
                    $svc.Refresh() 
                    if ($svc.Status -eq "Running") 
                    {
                        Set-Service -Name $svc.Name -StartupType Automatic
                        Get-Service $svc.Name | Select-Object -Property Name, StartType, Status  
                        Write-Host $svc "is now stopped & $(Get-Service $svc.Name | Select-Object -Property StartType) " -ForegroundColor Green 
                    }
                }


}



