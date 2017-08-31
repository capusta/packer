include chocolatey
Package { provider => chocolatey }

package { ['nssm', 'consul', 'consul-template', 'python3', 'ruby','rsync','pip']:
  ensure => latest
}

$working_dirs = [
  'c:\var',
  'c:\var\consul',
  'c:\var\lib',
  'c:\var\logs',
  'c:\var\consul-template',
  'c:\var\consul-template\conf',
  'c:\var\consul-template\templates',
	]

file { $working_dirs:
  ensure => directory
}

# Set up something more relative
$pwd = inline_template("<%= Dir.pwd %>")

file { 'c:\var\consul-template\conf\_config.conf':
  ensure  => file,
  content => template("$pwd\\templates\\_config.conf"),
  notify  => Service['consul-template']
}

file { 'c:\var\consul-template\templates\allhosts.tmpl':
  ensure  => file,
  content => template("$pwd\\templates\\allhosts.tmpl"),
  notify  => Service['consul-template']
}

file { 'c:\var\consul-template\templates\services.tmpl':
  ensure  => file,
  content => template("$pwd\\templates\\services.tmpl"),
  notify  => Service['consul-template']
}

file { 'c:\var\lib\genrdp.py':
  ensure  => file,
  content => template("$pwd\\templates\\genrdp.py"),
  mode    => '0774'
}

service { 'consul':
  ensure => 'running',
  enable => true
}

service { 'consul-template':
  ensure => 'running',
  enable => true
}

notify {'Completed common configuration':}
