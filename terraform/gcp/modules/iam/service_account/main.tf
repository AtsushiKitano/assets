locals {
  _pubsub_topic_iam_bindings = flatten([for v in var.pubsub_topic_iam_bindings : [for w in v.roles :
    {
      project = v.project
      name    = v.name
      role    = w
    }
  ]])
}

resource "google_service_account" "main" {
  account_id   = var.name
  display_name = var.display_name
  description  = var.description
  project      = var.project
}

resource "google_project_iam_member" "main" {
  for_each = toset(var.roles)

  member  = join(":", ["serviceAccount", google_service_account.main.email])
  role    = each.value
  project = var.project

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []

    content {
      expression = var.condition.expression
      title      = var.condition.title
    }
  }
}

resource "google_pubsub_topic_iam_member" "main" {
  for_each = { for v in local._pubsub_topic_iam_bindings : format("%s/%s/%s", v.project, v.topic, v.role) => v }

  topic   = data.google_pubsub_topic.main.name
  project = each.value.project
  member  = format("serviceAccount:%s", google_service_account.main.email)
  role    = each.value.role
}

data "google_pubsub_topic" "main" {
  for_each = { for v in var.pubsub_topic_iam_bindings : format("%s/%s", v.project, v.topic) => v }

  name    = each.value.name
  project = each.value.project
}

resource "google_pubsub_subscription_iam_member" "main" {
  for_each = { for v in var.pubsub_subscription_iam_bindings : format("%s/%s/%s", v.project, v.subscriber, v.role) => v }

  subscription = each.value.subscription
  role         = each.value.role
  member       = format("serviceAccount:%s", google_service_account.main.email)
  project      = each.value.project
}

resource "google_cloud_run_service_iam_member" "main" {
  for_each = { for v in var.cloud_run_iam_bindings : format("%s/%s/%s", v.project, v.service, v.role) => v }

  service = data.google_cloud_run_service.main[format("%s/%s", each.value.project, each.value.service)].name
  project = each.value.project
  member  = format("serviceAccount:%s", google_service_account.main.email)

}

data "google_cloud_run_service" "main" {
  for_each = { for v in var.cloud_run_iam_bindings : format("%s/%s", v.project, v.service) => v }

  name     = each.value.name
  project  = each.value.project
  location = each.value.location
}

