
#
#
#
Set-Location -Path "C:\Program Files\Zabbix\Scripts"


# Scan ONLY for SATA devices
$ScanJSON = ( .\smartctl.exe --scan  -j) -join "`n";
$PSOutput = ConvertFrom-Json $ScanJSON;



$ReturnObject=@();

ForEach ( $Disk in $PSOutput.devices) { 
#    Write-Host "Processing: " $Disk.name;
    
    $DiskInfoJSON = ( .\smartctl.exe --info $Disk.name -j) -join "`n";
    $PSOutput = ConvertFrom-Json $DiskInfoJSON;

    #Write-Host "Disk ID: " $Disk.name;
    #Write-Host "Disk model: " $PSOutput.model_name;
    #Write-Host "Disk serial: " $PSOutput.serial_number;
    #Write-Host "In database: " $PSOutput.in_smartctl_database;

    $BuildingObject = New-Object PSObject 

    If (( Get-Member -InputObject $PSOutput -Name "in_smartctl_database" -MemberType Properties) -and ( $PSOutput.in_smartctl_database -eq 'true')) {
            Add-Member -InputObject $BuildingObject -MemberType NoteProperty -Name '{#SMART.DISKID}' -Value $($Disk.name);
            Add-Member -InputObject $BuildingObject -MemberType NoteProperty -Name '{#SMART.MODEL}' -Value $($PSOutput.model_name);
            Add-Member -InputObject $BuildingObject -MemberType NoteProperty -Name '{#SMART.SERIAL}' -Value $($PSOutput.serial_number);
            Add-Member -InputObject $BuildingObject -MemberType NoteProperty -Name '{#SMART.INDB}' -Value $($PSOutput.in_smartctl_database);
        }
        #Write-Host $BuildingObject;
    $ReturnObject += $BuildingObject;
    }
$ReturnJSON = ConvertTo-Json $ReturnObject -Compress;
Write-Host -NoNewline ( $ReturnJSON);