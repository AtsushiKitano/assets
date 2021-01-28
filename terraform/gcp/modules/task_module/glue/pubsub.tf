locals {
  _pubsub_config = var.conf.pubsub != null ? [var.conf.pubsub] : []
}

resource "google_pubsub_topic" "main" {
  for_each = { for v in local._pubsub_config : v.name => v }

  name = each.value.name
}
