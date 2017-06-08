$hostname = $(get-childitem -path env:computername).value
$ipaddress = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | out-null; $Matches[1])

$puppet = 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat'
Test-Path $puppet
if($?){
    Write-Host "puppet-agent OK"
    choco upgrade puppet-agent
} else {
    choco install puppet-agent --force -y
}
& $puppet module install puppetlabs-chocolatey --version 2.0.2
& puppet module install KyleAnderson-consul --version 3.0.0

nssm set consul Application (Get-Command consul).Path
nssm set consul AppParameters agent -bootstrap -domain local -server -ui -node $hostname -advertise $ipaddress --data-dir c:\var\consul

nssm set consul-template Application (Get-Command consul-template).Path
nssm set consul-template AppParameters -config=c:\var\consul-template\conf -consul-addr $ipaddress:8500

& $puppet apply --test .
Write-Host "Finished setting up.  Please run 'puppet apply --tags <tag> to continue'"

