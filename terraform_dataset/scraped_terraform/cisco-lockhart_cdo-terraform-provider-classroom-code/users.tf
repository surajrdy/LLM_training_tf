resource "cdo_user" "msp_employees" {
  for_each         = var.msp_employees
  name             = each.key
  role             = "ROLE_SUPER_ADMIN"
  is_api_only_user = false
}
