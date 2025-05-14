package terraform.rules.tagging

required_tags := ["environment", "managed-by", "owner"]

deny[msg] {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "digitalocean_droplet"
  not has_required_tags(resource.values.tags)
  msg := sprintf("Droplet %s is missing required tags", [resource.address])
}

has_required_tags(tags) {
  count([tag | tag := tags[_]; contains(tag, required_tags[_])]) == count(required_tags)
}