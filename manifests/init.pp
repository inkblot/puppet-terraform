# ex: syntax=puppet si sw=2 ts=2 et
class terraform (
  $version,
) {
  hashicorp::download { 'terraform':
    version    => $version,
  }
}
