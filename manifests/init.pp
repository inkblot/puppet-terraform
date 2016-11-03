# ex: syntax=puppet si sw=2 ts=2 et
class terraform (
  $version,
  $base_url = 'https://releases.hashicorp.com/terraform',
  $target_dir = '/usr/local/bin',
  $bin_name = 'terraform',
  $checksum_type = undef,
  $checksum = undef
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
  archive{ "/tmp/${archive_filename}":
    ensure       => present,
    checksum     => $checksum,
    checksum_type => $checksum_type,
    extract      => true,
    extract_path => $target_dir,
    source       => "${base_url}/${version}/${archive_filename}",
    creates      => "${target_dir}/${bin_name}",
  }

}
