# ex: syntax=puppet si sw=2 ts=2 et
class terraform (
  $version,
  $target_dir = '/usr/local/bin',
) {
  hashicorp::download { 'terraform':
    version    => $version,
    target_dir => $target_dir,
  }
}
