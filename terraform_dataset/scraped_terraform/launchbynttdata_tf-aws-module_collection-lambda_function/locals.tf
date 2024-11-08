// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

locals {

  default_tags = {
    provisioner = "Terraform"
  }

  # Inject tags to target group
  target_groups = [for tg in var.target_groups : merge(tg, {
    tags = {
      resource_name = module.resource_names["alb_tg"].standard
    } }, {
    targets = {
      lambda_with_allowed_triggers = {
        target_id = module.lambda_function.lambda_function_arn
      }
    }
    }
  )]

  domainfqn = "${module.lambda_function.lambda_function_name}.${var.zone_name}"

  elb_trigger = {
    AllowExecutionFromELB = {
      service    = "elasticloadbalancing"
      source_arn = var.create_alb ? module.alb[0].target_group_arns[0] : ""
    }
  }

  eventbridge_trigger = {
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = var.create_schedule ? module.eventbridge[0].eventbridge_rule_arns["${module.lambda_function.lambda_function_name}_cron"] : ""
    }
  }

  allowed_triggers = merge(
    var.create_schedule ? local.eventbridge_trigger : {},
    var.create_alb ? local.elb_trigger : {}
  )

  tags = merge(local.default_tags, var.tags)
}
