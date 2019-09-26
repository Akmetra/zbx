# zbx
Zabbix Scripts and snippets

A few useful scripts that I've collected / written. Zabbix queries for clients.

<B>Disk S.M.A.R.T. Utilities</B>


Discovers SMART-compatible disks, creates items and triggers for them.

<I>Requirements:</I>
smartctl - available at https://smartmontools.org
a reasonably up-to-date version of PowerShell (Convert-To-JSON specifically)

DiscoverSMARTDisks.ps1 - lists all the available disks, reports them to Zabbix.
GetSMARTValues - queries a specific disk for a specific value.
A Zabbix template is provided.

Currently supported values:
 bad_sectors; power_cycle; power_hours; temperature
 
Snippet for zabbix_agentd.conf:

<pre>
# Increase timeout for scripts
Timeout=12

# Custom fields
UserParameter=smartdata.GetValues[*],"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix\Scripts\GetSMARTValues.ps1" $1 $2
UserParameter=smartdata.discovery,"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix\Scripts\DiscoverSMARTDisks.ps1"</pre>
