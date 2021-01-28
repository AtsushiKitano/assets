variable "cron_job_conf" {
  type = list(object({
    enable = bool
    region = string

    scheduler_job_conf = object({
      name      = string
      time_zone = string
      schedule  = string
      data      = string
      opt_var   = map(string)
    })

    pubsub_topic_conf = object({
      name    = string
      opt_var = map(string)
    })

    function_conf = object({
      name        = string
      url         = string
      runtime     = string
      entry_point = string
      opt_var     = map(string)
    })
  }))
}
