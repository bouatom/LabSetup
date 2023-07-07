function Show-Menu
{
     param (
           [string]$Title = ‘Computer DNS Network Settings’
     )
     cls
     Write-Host “================ $Title ================”
    
     Write-Host “1: Press ‘1’ to setup this computer for Internal Use.”
     Write-Host “2: Press ‘2’ to setup this computer for Lab Use.”
     Write-Host “3: Press ‘3’ to reset all DNS settings.”
     Write-Host “Q: Press ‘Q’ to quit.”
}
do
{
     Show-Menu
     $input = Read-Host “Please make a selection”
     switch ($input)
     {
           ‘1’ {
                cls
                ‘Configuring Internal Network Access’
                # Get your adapter's interface id
$interface = Get-NetIPInterface | 
  Where { $_.ConnectionState -eq 'Connected' -and $_.InterfaceAlias -notlike 'Loopback*' }

# Check the current DNS Server(s) on that interface:
$DNSCurrent = $interface | Get-DnsClientServerAddress

# fill in new dns server info:
$dns1 = '10.0.2.100'
$dns2 = $DNSCurrent.ServerAddresses[0]  # make current primary server secondary
$dns3 = $DNSCurrent.ServerAddresses[1]  # optional third


# if the first address is wrong, then set it
if ($DNSCurrent.ServerAddresses[0] -NE $dns1) {
  $interface | Set-DnsClientServerAddress -ServerAddresses $dns1,$dns2,$dns3
}
ipconfig /all
           } ‘2’ {
                cls
                ‘Configuring Lab Network Access’
                # Get your adapter's interface id
$interface = Get-NetIPInterface | 
  Where { $_.ConnectionState -eq 'Connected' -and $_.InterfaceAlias -notlike 'Loopback*' }

# Check the current DNS Server(s) on that interface:
$DNSCurrent = $interface | Get-DnsClientServerAddress

# fill in new dns server info:
$dns1 = '10.0.5.100'
$dns2 = $DNSCurrent.ServerAddresses[0]  # make current primary server secondary
$dns3 = $DNSCurrent.ServerAddresses[1]  # optional third


# if the first address is wrong, then set it
if ($DNSCurrent.ServerAddresses[0] -NE $dns1) {
  $interface | Set-DnsClientServerAddress -ServerAddresses $dns1,$dns2,$dns3
}
ipconfig /all
pause
exit

           } ‘3’ {
                cls
                ‘Resetting DNS Settings’
                                # Get your adapter's interface id
$interface = Get-NetIPInterface | 
  Where { $_.ConnectionState -eq 'Connected' -and $_.InterfaceAlias -notlike 'Loopback*' }
Set-DnsClientServerAddress -InterfaceIndex $interface -ResetServerAddresses
                ipconfig /all
                pause
                exit
           } ‘q’ {
                return
           }
     }
     pause
}
until ($input -eq ‘q’)