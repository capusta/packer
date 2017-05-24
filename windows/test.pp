include chocolatey
Package { provider => chocolatey, }

file { ['c:\var','c:\var\consul']:
	ensure => directory
}
package { ['nssm','consul','consul-template']:
	ensure => latest
}