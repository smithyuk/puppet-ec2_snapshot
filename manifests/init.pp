# == Class: ec2_snapshot
#
# === Parameters
#
# [*tag*]
# Tag key to look for in EC2 (should be applied to EBS volume)
#
# [*tag_value*]
# Tag value to look for in EC2
#
# [*region*]
# Region to run backup script against
#
# [*extra_opts*]
# An array of single flag arguments to apply to command
#
# [*purge*]
# Boolean on whether to purge old backup snapshots
#
# [*purge_after*]
# Integer specifying days of age after which to delete snapshots
#
# [*git_url*]
# URL of git project for aws-missing-tools
#
# [*git_rev*]
# Revision of aws-missing-tools project to fetch
#
# [*mailto*]
# Email address to mail command output to
#
class ec2_snapshot (
  $tag         = 'Backup',
  $tag_value   = 'true',
  $region      = 'us-east-1',
  $extra_opts  = [],
  $purge       = false,
  $purge_after = 30,
  $git_url     = 'https://github.com/colinbjohnson/aws-missing-tools.git',
  $git_rev     = '6cf0b19dd202d2abe4237fb98618f1c72aea9e44',
  $mailto      = undef,
) {
  $tag_full = "${tag},Values=${tag_value}"
  $extra_opts_s = join($extra_opts, ' ')

  validate_bool($purge)
  validate_integer($purge_after)

  group { 'ec2_snapshot':
    ensure => present,
  }

  user { 'ec2_snapshot':
    ensure     => present,
    comment    => 'ec2_snapshot backup user',
    home       => '/home/ec2_snapshot',
    managehome => true,
    gid        => 'ec2_snapshot',
    require    => Group['ec2_snapshot'],
  }

  vcsrepo { '/home/ec2_snapshot/ec2_tools':
    ensure   => present,
    provider => git,
    source   => $git_url,
    revision => $git_rev,
    require  => User['ec2_snapshot'],
  }

  file { '/etc/cron.d/ec2_snapshot':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('ec2_snapshot/ec2_snapshot.cron.erb'),
    require => Vcsrepo['/home/ec2_snapshot/ec2_tools'],
  }
}
