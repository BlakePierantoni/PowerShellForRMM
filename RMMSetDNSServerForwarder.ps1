#################################################################
# Title: Set DNS Server Forwarder
# Author: Blake Pierantoni
# Date: 2019/11/22
# Description: Command to set custom DNS Server Forwarders for Windows Server 2012+ by using DattoRMM to push the script
#################################################################
Write-host "The current DNS Server Forwarders are:"
    Get-DNSServerForwarder -Verbose

Write-host "Removing DNS Server Forwarders..."
    Get-DnsServerForwarder | Remove-DnsServerForwarder -IPAddress {$_.IPaddress -NotLike "999.999.999.999"} -Force

#Add Primary DNS Server Forwarder
Write-Host "Adding Primary DNS Server Forwarder."
    Add-DNSServerForwarder -IPAddress $Env:DNSForwarder1 

#Add Secondary DNS Server Forwarder

Write-Host "Adding Secondary DNS Server Forwarder."
    Add-DnsServerForwarder -IPAddress $Env:DNSForwarder2 

#Clear DNS Cache
Write-Host "Clearing DNS Cache"
    Clear-DnsClientCache

Write-Host "The following IP Addresses are currently set as the DNS Forwarders for this machine: "
    Get-DNSServerForwarder -Verbose