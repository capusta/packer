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
