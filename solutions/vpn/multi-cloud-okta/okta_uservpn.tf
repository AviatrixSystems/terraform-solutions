provider "okta" {
  org_name  = var.OKTA_ORG_NAME
  base_url  = var.OKTA_BASE_URL
  api_token = var.OKTA_API_TOKEN
}

# Create user.
resource "okta_user" "vpn_users" {
  for_each                  = var.okta_vpn_users
  first_name                = each.value.first_name
  last_name                 = each.value.last_name
  login                     = each.value.login
  email                     = each.value.email
  custom_profile_attributes = "{\"aviatrixProfile\":\"${each.value.aviatrixProfile}\"}"
}

locals {
  okta_app_dest_url = "https://${var.AVX_CONTROLLER_IP}/flask/saml/sso/${var.saml_endpoint_name}"
}

# Create Aviatrix app.
resource "okta_app_saml" "tf-uservpn" {
  accessibility_self_service = false
  app_settings_json          = jsonencode({})
  assertion_signed           = true
  audience                   = "https://${var.AVX_CONTROLLER_IP}"
  authn_context_class_ref    = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  auto_submit_toolbar        = false
  destination                = local.okta_app_dest_url
  digest_algorithm           = "SHA256"
  honor_force_authn          = true
  label                      = var.okta_app_name
  recipient                  = local.okta_app_dest_url
  signature_algorithm        = "RSA_SHA256"
  sso_url                    = local.okta_app_dest_url
  subject_name_id_format     = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
  subject_name_id_template   = "$${user.userName}"

  attribute_statements {
    name      = "FirstName"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values = [
      "user.firstName",
    ]
  }
  attribute_statements {
    name      = "LastName"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values = [
      "user.lastName",
    ]
  }
  attribute_statements {
    name      = "Email"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values = [
      "user.email",
    ]
  }
  attribute_statements {
    name      = "Profile"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:unspecified"
    type      = "EXPRESSION"
    values = [
      "user.aviatrixProfile",
    ]
  }

  dynamic users {
    for_each = okta_user.vpn_users
    content {
      id       = users.value.id
      username = users.value.login
    }
  }
}

# Available in Okta GUI, but not yet exposed via Terraform attribute.
# Need to build the string ourselves.
# https://github.com/terraform-providers/terraform-provider-okta/issues/72
# "Add IdP metadata URL attribute to okta_app_saml resource"
locals {
  okta_app_metadata_url = "https://${var.OKTA_ORG_NAME}.${var.OKTA_BASE_URL}/app/${okta_app_saml.tf-uservpn.entity_key}/sso/saml/metadata"
}
