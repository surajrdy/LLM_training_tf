/*This terraform file has been generated programmatically using terraform-generator.*/
/*All the commented lines, if any, are optional. Remove comment characters, if required, before using.*/
/*Refer https://github.com/sushil46in/terraform_modules.git for more details.*/

resource "aws_cloudwatch_event_bus" "resname" {
  #event_source_name = var.cloudwatch_event_bus_event_source_name
  name = var.cloudwatch_event_bus_name
  #tags = var.cloudwatch_event_bus_tags

}

