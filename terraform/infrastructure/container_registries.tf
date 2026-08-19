resource "yandex_container_registry" "container_registry" {
  folder_id = var.folder_id
  name      = "container-registry"

  labels = {
    managed_by = "terraform"
  }
}

output "container_registry_id" {
  value = "Yandex Container Registry ID: ${yandex_container_registry.container_registry.id}"
}

resource "local_file" "ycr_id_file" {
  filename = "${path.module}/../../secrets/jenkins/ycr_id"
  content  = yandex_container_registry.container_registry.id
}

resource "yandex_container_repository" "container_repositories" {
  for_each = var.repositories
  name     = "${yandex_container_registry.container_registry.id}/${each.value}"

}

variable "repositories" {
  type = set(string)
  default = [
    "shareit-server",
    "shareit-gateway"
  ]
}

resource "yandex_container_repository_lifecycle_policy" "container_repository_lifecycle_policy" {
  for_each      = yandex_container_repository.container_repositories
  name          = "lifecycle-policy-${each.key}"
  repository_id = each.value.id
  status        = "active"


  rule {
    description   = "Delete all untagged images and images older than 24h. Keep only two latest image."
    untagged      = true
    tag_regexp    = ".*"
    retained_top  = 2
    expire_period = "24h"
  }
}