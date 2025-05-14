version = "v1"

policy "terraform_rules_tagging" {
  enabled = true
  enforcement_level = "advisory"
}

policy "workspace_name_convention" {
    enabled = true
    enforcement_level = "advisory"
}