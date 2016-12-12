# ex: syntax=puppet si sw=2 ts=2 et
class terraform (
  $version,
  $base_url      = 'https://releases.hashicorp.com/terraform',
  $target_dir    = '/usr/local/bin',
  $bin_name      = 'terraform',
  $tmp_dir       = '/tmp',
  $checksum_type = undef,
  $checksum      = undef
) {

  case $::kernel {
    'Linux': { $_os = 'linux' }
    'FreeBSD': { $_os ='freebsd' }
    'OpenBSD': { $_os = 'openbsd' }
    'Darwin': { $_os = 'darwin' }
    default: { fail("Unknown kernel ${::kernel}") }
  }

  case $::architecture {
    'amd64', 'x86_64': { $_arch = 'amd64' }
    'i386', 'i486', 'i586', 'x86': { $_arch = '386' }
    default: { fail("Unknown architecture: ${::architecture}") }
  }

  $archive_filename = "terraform_${version}_${_os}_${_arch}.zip"
  archive { "${tmp_dir}/${archive_filename}":
    ensure        => present,
    checksum      => $checksum,
    checksum_type => $checksum_type,
    extract       => true,
    extract_path  => $tmp_dir,
    source        => "${base_url}/${version}/${archive_filename}",
    creates       => "${target_dir}/${bin_name}-${version}",
  }

  exec { '/usr/local/bin/terraform-version':
    command     => "mv ${tmp_dir}/${bin_name} ${target_dir}/${bin_name}-${version}",
    path        => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/rvm/bin',
    subscribe   => Archive["${tmp_dir}/${archive_filename}"],
    path        => ['/bin'],
    refreshonly => true,
  }

  file { "${target_dir}/${bin_name}":
    ensure => link,
    target => "${target_dir}/${bin_name}-${version}",
  }
}
