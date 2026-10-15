# Run inside the laboratory guest in elevated Windows PowerShell 5.1 or newer.
# Read-only checks. No repair, credential storage or file export.
[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
if ($env:COMPUTERNAME -notin @('DC01','PC01')) { throw 'Run only inside DC01 or PC01, not on the host.' }
$identity=[Security.Principal.WindowsIdentity]::GetCurrent()
$principal=New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'Run elevated; the client secure-channel check requires administrator rights.' }
$checks=New-Object 'System.Collections.Generic.List[object]'
function Add-Check([string]$Name,[scriptblock]$Probe) {
  try {
    $value=& $Probe
    $checks.Add([pscustomobject]@{Name=$Name;Passed=[bool]$value.Passed;Observed=$value.Observed;Error=$null})
  } catch {
    $checks.Add([pscustomobject]@{Name=$Name;Passed=$false;Observed=$null;Error=$_.Exception.Message})
  }
}
Add-Check 'DomainMembership' {
  $system=Get-CimInstance Win32_ComputerSystem
  @{Passed=$system.PartOfDomain -and $system.Domain -eq 'lab.example.test';Observed=@{Domain=$system.Domain;PartOfDomain=$system.PartOfDomain}}
}
Add-Check 'IPv4Configuration' {
  $expected=if($env:COMPUTERNAME -eq 'DC01'){'10.10.10.10'}else{'10.10.10.20'}
  $ip=@(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -eq $expected -and $_.PrefixLength -eq 24})
  @{Passed=$ip.Count -eq 1;Observed=@($ip | Select-Object IPAddress,PrefixLength)}
}
Add-Check 'ClientDNS' {
  $addresses=@(Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notmatch 'Loopback'} | ForEach-Object {$_.ServerAddresses})
  $allowed=if($env:COMPUTERNAME -eq 'DC01'){@('10.10.10.10','127.0.0.1')}else{@('10.10.10.10')}
  $unexpected=@($addresses | Where-Object {$_ -notin $allowed})
  @{Passed=$addresses.Count -gt 0 -and $unexpected.Count -eq 0;Observed=$addresses}
}
Add-Check 'IsolatedNoDefaultRoute' {
  $routes=@(Get-NetRoute -AddressFamily IPv4 -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue)
  @{Passed=$routes.Count -eq 0;Observed=@($routes | Select-Object DestinationPrefix,NextHop)}
}
Add-Check 'DNSHostA' {
  $addresses=@(Resolve-DnsName dc01.lab.example.test -Type A -DnsOnly | Where-Object IPAddress | ForEach-Object {$_.IPAddress})
  @{Passed='10.10.10.10' -in $addresses;Observed=$addresses}
}
Add-Check 'DNSLdapSrv' {
  $records=@(Resolve-DnsName '_ldap._tcp.dc._msdcs.lab.example.test' -Type SRV -DnsOnly | Where-Object {$_.Type -eq 'SRV'})
  $matching=@($records | Where-Object {$_.NameTarget.TrimEnd('.') -ieq 'dc01.lab.example.test' -and $_.Port -eq 389})
  @{Passed=$matching.Count -gt 0;Observed=@($records | Select-Object NameTarget,Port)}
}
Add-Check 'SMBTcp445' {
  $socket=New-Object Net.Sockets.TcpClient
  try {
    $connection=$socket.ConnectAsync('10.10.10.10',445)
    if(-not $connection.Wait(3000)){throw 'TCP connection timed out'}
    @{Passed=$socket.Connected;Observed=@{Address='10.10.10.10';Port=445;Connected=$socket.Connected}}
  } finally { $socket.Dispose() }
}
if ($env:COMPUTERNAME -eq 'PC01') {
  Add-Check 'SecureChannel' { $ok=Test-ComputerSecureChannel; @{Passed=$ok;Observed=$ok} }
} else {
  foreach($serviceName in @('DNS','NTDS','Netlogon','ADWS','DFSR')) {
    Add-Check ('Service-'+$serviceName) { $service=Get-Service $serviceName; @{Passed=$service.Status -eq 'Running';Observed=[string]$service.Status} }
  }
  Add-Check 'LabSharePublished' {
    $share=Get-SmbShare -Name LabShare
    @{Passed=$share.Path -eq 'C:\LabShare';Observed=@{Name=$share.Name;Path=$share.Path}}
  }
}
$report=[ordered]@{
  ObservedAtUtc=[DateTime]::UtcNow.ToString('o')
  Computer=$env:COMPUTERNAME
  ScriptSha256=if($PSCommandPath){(Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash}else{$null}
  Scope='Laboratory configuration and reachability; does not prove normal-user access, GPO effect, updates or backup'
  Passed=@($checks | Where-Object {-not $_.Passed}).Count -eq 0
  Checks=@($checks.ToArray())
}
$report | ConvertTo-Json -Depth 8
if(-not $report.Passed){throw 'Some lab checks failed; inspect the JSON report. No repair was attempted.'}
