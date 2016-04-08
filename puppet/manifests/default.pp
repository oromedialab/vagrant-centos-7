class { 'composer':
  command_name => 'composer',
  target_dir   => '/usr/local/bin'
}

include git
include composer