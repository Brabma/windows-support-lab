# Run INSIDE DC01 or PC01. Read-only queries; output stays private until reviewed.
[CmdletBinding()]
param([Parameter(Mandatory)][string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
if ($env:COMPUTERNAME -notin @('DC01','PC01')) { throw 'Run inside DC01 or PC01, not on the host.' }
$null = New-Item -ItemType Directory -Path $OutputDirectory -Force
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$report = Join-Path $OutputDirectory "$($env:COMPUTERNAME)-$stamp.txt"
& {
  Get-Date -Format o
  Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber
  Get-CimInstance Win32_ComputerSystem | Select-Object Name,Domain,PartOfDomain
  whoami.exe
  ipconfig.exe /all
  Get-Service DNS,NTDS,Netlogon -ErrorAction SilentlyContinue
  try { Resolve-DnsName -Name '_ldap._tcp.dc._msdcs.lab.example.test' -Type SRV -ErrorAction Stop } catch { $_.Exception.Message }
  nltest.exe /dsgetdc:lab.example.test
  gpresult.exe /r
} | Out-File -LiteralPath $report -Encoding utf8
Write-Output "Private diagnostic report: $report"
