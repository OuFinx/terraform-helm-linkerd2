resource "tls_private_key" "ca_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "ca_cert" {
  key_algorithm         = tls_private_key.ca_key.algorithm
  private_key_pem       = tls_private_key.ca_key.private_key_pem
  validity_period_hours = var.validity_period_hours_ca
  is_ca_certificate     = true

  subject {
    common_name  = var.subject_common_name
    organization = var.subject_organization
  }

  allowed_uses = var.allowed_uses
}

resource "tls_private_key" "issuer_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "issuer_cert" {
  key_algorithm   = tls_private_key.issuer_key.algorithm
  private_key_pem = tls_private_key.issuer_key.private_key_pem

  subject {
    common_name  = var.subject_common_name
    organization = var.subject_organization
  }
}

resource "tls_locally_signed_cert" "issuer_cert" {
  cert_request_pem      = tls_cert_request.issuer_cert.cert_request_pem
  ca_key_algorithm      = tls_private_key.ca_key.algorithm
  ca_private_key_pem    = tls_private_key.ca_key.private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca_cert.cert_pem
  validity_period_hours = var.validity_period_hours_issuer
  is_ca_certificate     = true

  allowed_uses = var.allowed_uses
}
