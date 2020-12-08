locals {
  admin_cidrs    = values(data.vault_generic_secret.internal_cidrs.data)
}
