module "armor" {
  source = "../modules/task_module/armor"

  files_rule = {
    action         = "allow"
    versioned_expr = "SRC_IPS_V1"
    file_path      = "../files/monitoring_ip_list.json"
    file_type      = "json"
    priority_base  = 1000
    ip_prefix      = "ipAddress"
  }

  armor_conf = [
    {
      armor_enable = false
      name         = "monitoring"
      default_rule = {
        action         = "deny(403)"
        priority       = 2147483647
        versioned_expr = "SRC_IPS_V1"
        src_ip_ranges  = ["*"]
      }
    }
  ]
}
