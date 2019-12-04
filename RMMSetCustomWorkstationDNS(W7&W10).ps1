#################################################################
# Title: Set Custom DNS
# Author: BlakeP
# Date: 2019/06/28
# Description: Set Custom DNS Servers for Windows 7 and Windows 10 Workstations
#################################################################



#Look for active NICs using Win32. If an active NIC is found, Custom DNS information will be set. 

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $env:COMPUTERNAME |where{$_.IPEnabled -eq “TRUE” <# -and $_.DHCPEnabled -ne 'True'  #>}
  Foreach($NIC in $NICs) {
$DNSServers = "$env:DNS1","$env:DNS2" # the new DNS entries
 $NIC.SetDNSServerSearchOrder($DNSServers)  | Out-Null
 $NIC.SetDynamicDNSRegistration("TRUE")  | Out-Null
 Write-Host "Successfully set Primary DNS as $env:DNS1 and Secondary DNS as $env:DNS2 on $env:COMPUTERNAME" -f green
}

#Clear DNS Cache W10
Clear-DNSClientCache -ErrorAction SilentlyContinue  

#Clear DNS Cache for Windows 7
ipconfig /flushDNS
Write-Host "DNS Cache has been cleared. The Script is now complete"

#Net IP Configuration sent to RMM Output
Get-NetIPConfiguration -Verbose