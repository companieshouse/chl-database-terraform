module "rds-stop" {
  source  = "diodonfrost/lambda-scheduler-stop-start/aws"
  version = "1.4.3"

  name                           = "stop-rds-dev-hours"
  cloudwatch_schedule_expression = "cron(0 20 ? * MON-FRI *)"
  schedule_action                = "stop"
  rds_schedule                   = "true"

  resources_tag = {
    key   = "AutoStop"
    value = "true"
  }
}

module "rds-start" {
  source  = "diodonfrost/lambda-scheduler-stop-start/aws"
  version = "1.4.3"

  name                           = "start-rds-dev-hours"
  cloudwatch_schedule_expression = "cron(0 6 ? * MON-FRI *)"
  schedule_action                = "start"
  rds_schedule                   = "true"

  resources_tag = {
    key   = "AutoStop"
    value = "true"
  }
}
