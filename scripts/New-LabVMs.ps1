# Creates only new powered-off VM profiles. Never starts a VM or changes host features.
[CmdletBinding()]
param(
  [string]$VBoxManage = 'VBoxManage.exe',
  [string]$VMDirectory = (Join-Path (Split-Path $PSScriptRoot -Parent) 'private\vms')
)
$ErrorActionPreference = 'Stop'
$VBoxManage = (Get-Command $VBoxManage -ErrorAction Stop).Source
$target = [IO.Path]::GetFullPath($VMDirectory)
if (-not $target.StartsWith('D:\',[StringComparison]::OrdinalIgnoreCase)) { throw 'VM storage must be on D:.' }
function Invoke-VBox {
  param([string[]]$Arguments)
  & $VBoxManage @Arguments
  if ($LASTEXITCODE -ne 0) { throw "VBoxManage failed: $($Arguments[0])" }
}
$existing = & $VBoxManage list vms
if ($LASTEXITCODE -ne 0) { throw 'Cannot read VM inventory.' }
foreach ($name in @('DC01','PC01')) {
  if ($existing -match ('^"' + [regex]::Escape($name) + '" ')) { throw "$name exists; do not overwrite it. Inspect partial preparation manually." }
  if (Test-Path -LiteralPath (Join-Path $target $name)) { throw "$name directory exists; preserve it and inspect first." }
}
$null = New-Item -ItemType Directory -Path $target -Force
foreach ($vm in @(@{Name='DC01';Type='Windows2025_64';Disk=65536},@{Name='PC01';Type='Windows11_64';Disk=81920})) {
  $name = $vm.Name
  Invoke-VBox @('createvm','--name',$name,'--ostype',$vm.Type,'--basefolder',$target,'--register')
  Invoke-VBox @('modifyvm',$name,'--memory','4096','--cpus','2','--ioapic','on','--firmware','efi','--tpm-type','2.0','--graphicscontroller','vboxsvga','--vram','128','--nic1','intnet','--intnet1','windows-support-isolated','--nic2','none','--clipboard-mode','disabled','--drag-and-drop','disabled','--audio-enabled','off','--boot1','dvd','--boot2','disk','--boot3','none','--boot4','none')
  Invoke-VBox @('modifynvram',$name,'inituefivarstore')
  Invoke-VBox @('modifynvram',$name,'enrollmssignatures')
  Invoke-VBox @('modifynvram',$name,'enrollorclpk')
  Invoke-VBox @('modifynvram',$name,'secureboot','--enable')
  $disk = Join-Path (Join-Path $target $name) "$name.vdi"
  Invoke-VBox @('createmedium','disk','--filename',$disk,'--size',[string]$vm.Disk,'--format','VDI','--variant','Standard')
  Invoke-VBox @('storagectl',$name,'--name','SATA','--add','sata','--controller','IntelAhci','--portcount','2')
  Invoke-VBox @('storageattach',$name,'--storagectl','SATA','--port','0','--device','0','--type','hdd','--medium',$disk)
  Invoke-VBox @('storageattach',$name,'--storagectl','SATA','--port','1','--device','0','--type','dvddrive','--medium','emptydrive')
  Invoke-VBox @('showvminfo',$name,'--machinereadable')
}
