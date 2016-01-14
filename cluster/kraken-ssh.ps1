<#
  title           :kraken-ssh.ps1
  description     :ssh to a remotely managed cluster node
  author          :Samsung SDSRA
#>

Param(
  [Parameter(Mandatory=$true)] 
  [string]$dmname = "",
  [Parameter(Mandatory=$true)]
  [string]$clustername = "",
  [Parameter(Mandatory=$true)] 
  [string]$node = ""
)

# kraken root folder
$krakenRoot = "$(split-path -parent $MyInvocation.MyCommand.Definition)\.."
. "$krakenRoot\cluster\utils.ps1"

$success = Invoke-Expression "docker-machine ls -q | out-string -stream | findstr -s '$dmname'"
If ($LASTEXITCODE -eq 0) {
  inf "Machine $dmname already exists."
} Else {
  error "Docker Machine $dmname does not exist."
  exit 1
}

Invoke-Expression "docker-machine.exe env --shell=powershell $dmname | Invoke-Expression"

Invoke-Expression "docker run -it --volumes-from kraken_data samsung_ag/kraken ssh -F /kraken_data/$clustername/ssh_config $node"