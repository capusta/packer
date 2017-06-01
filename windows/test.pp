include chocolatey
Package { provider => chocolatey, }

$working_dirs = [
	'c:\var',
	'c:\var\consul',
	'c:\var\consul-template\'
	'c:\var\consul-template\config'
	'c:\var\consul-template\templates' 
	]
	
file { $working_dirs:
	ensure => directory
}
package { ['nssm','consul','consul-template']:
	ensure => latest
}