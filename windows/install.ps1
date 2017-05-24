(Get-Command consul).Path
if($?) {
    Write-Host "Consul OK"
    choco update consul
} else {
choco install consul --force -y
}
