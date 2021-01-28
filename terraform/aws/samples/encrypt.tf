locals {
  encrypt_sample_enabled = true

  _encrypt_sample_config = local.encrypt_sample_enabled ? [
    {
      name      = "sample"
      plaintext = file("files/secret_sample.json")
    }
  ] : []
}

module "encrypt_sample" {
  for_each = { for v in local._encrypt_sample_config : v.name => v }
  source   = "../modules/secret/encrypt"

  config = {
    key_id    = module.encrypt_sample_kms[each.value.name].kms_id
    plaintext = each.value.plaintext
  }
}

module "encrypt_sample_kms" {
  for_each = { for v in local._encrypt_sample_config : v.name => v }
  source   = "../modules/secret/kms"

  config = {
    name = each.value.name

    grants = []
  }
}

output "encrypt_sample" {
  value = local.encrypt_sample_enabled ? module.encrypt_sample["sample"].ciphertext : null
}
