##########################
#Turn Off Windows Firewall
#
#
#

Set-NetFirewallProfile -Profile domain,public,private -Enabled false