# ex: syntax=puppet si sw=2 ts=2 et
class terraform (
  $version = '0.6.11',
) {

  $_os = $::kernel ? {
    'Linux' => 'linux',
    'FreeBSD' => 'freebsd',
    'OpenBSD' => 'openbsd',
  }

  $_arch = $::architecture ? {
    'amd64' => 'amd64',
    'x86_64' => 'amd64',
    'i386' => '386',
    'i486' => '386',
    'i586' => '386',
    'x86' => '386',
  }

  staging::deploy { "terraform_${version}_${_os}_${_arch}.zip":
    source  => "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${_os}_${_arch}.zip",
    target  => '/usr/local/bin',
    creates => '/usr/local/bin/terraform',
  }
}
