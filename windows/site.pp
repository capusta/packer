include chocolatey
Package { provider => chocolatey }

$working_dirs = [
  'c:\var',
  'c:\var\consul',
  'c:\var\consul-template',
  'c:\var\consul-template\conf',
  'c:\var\consul-template\templates',
	]

$pwd = inline_template("<%= Dir.pwd %>")

file { 'c:\var\consul-template\conf\_config.conf':
  ensure  => file,
  content => template("$pwd\\templates\\_config.conf"),
  notify  => Service['consul-template']
}
