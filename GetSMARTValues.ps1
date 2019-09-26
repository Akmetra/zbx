#
#
#
#
#
Set-Location -Path "C:\Program Files\Zabbix\Scripts"

#$DiskID = 'sdb'; 
#$RequestedValue = 'temperature';

#Param( [String]$DiskID='sdb');
#Param( [String]$RequestedValue='temperature');

$DiskID = $args[0];
$RequestedValue = $args[1];

$JSONOutput = ( .\smartctl.exe -j --attributes $DiskID) -join "`n"
#Write-Host $JSONOutput;
$PSOutput = ConvertFrom-Json $JSONOutput;

$OutputValue = 666;

Switch( $RequestedValue){
    'bad_sectors' { 
        $OutputValue = ( $PSOutput.ata_smart_attributes.table -match 'Reallocated_Sector_Ct').raw.value;
        break;}

    'power_cycle' {
        $OutputValue = ( $PSOutput.ata_smart_attributes.table -match 'Power_Cycle_Count').raw.value;
        break;}
            
# Some disks (Kingston SSD) return two values, msec and a string: 12345h+10m+15.254s". We will try and use the string and cut it down to size... 
    'power_hours' { 
#   Original line below
#        $OutputValue = ( $PSOutput.ata_smart_attributes.table -match 'Power_On_Hours').raw.value;
        $OutputValue = ( $PSOutput.ata_smart_attributes.table -match 'Power_On_Hours').raw.string.Split('h')[0];
        break;}
            
    'temperature' {
        $OutputValue = ( $PSOutput.temperature.current);
        break;}
    
    'sector_size' { $OutputValue = 'bs';}
    
    'lba_written' { $OutputValue = 'bs';}
    
    'lba_read' { $OutputValue = 'bs';}
    
    'nand_writes' { $OutputValue = 'bs';}
    
    };

#$OutputValue = '';

#Write-Host $PSOutput.$RequestedValue -NoNewline
Write-Host $OutputValue -NoNewline;
