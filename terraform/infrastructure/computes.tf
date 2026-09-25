resource "yandex_compute_instance" "node" {
  for_each    = local.vms
  name        = each.key
  folder_id   = var.folder_id
  zone        = var.zone_a
  platform_id = "standard-v3"

  resources {
    cores         = each.value.cores
    core_fraction = 20
    memory        = each.value.memory
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
      size     = each.value.disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_a.id
    security_group_ids = each.value.security_group_ids
    nat                = true
  }

  scheduling_policy {
    preemptible = true # https://yandex.cloud/ru/docs/compute/concepts/preemptible-vm
  }

  # YandexCloud required ssh-key to be passed in the format "{username}:{key_itself}"
  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key)}" # "ubuntu" - username, ${} - formatted string
  }

  labels = {
    managed_by = "terraform"
  }
}

locals {
  vms = {
    "app-server" = {
      cores     = 2
      memory    = 2
      disk_size = 20
      security_group_ids = [
        yandex_vpc_security_group.sg_common.id,
        yandex_vpc_security_group.sg_http.id
      ]
    }

    "ci-server" = {
      cores     = 2
      memory    = 4
      disk_size = 30
      security_group_ids = [
        yandex_vpc_security_group.sg_common.id,
        yandex_vpc_security_group.sg_jenkins.id,
        yandex_vpc_security_group.sg_vault.id
      ]
    }

    "obs-server" = {
      cores     = 2
      memory    = 6
      disk_size = 30
      security_group_ids = [
        yandex_vpc_security_group.sg_common.id,
        yandex_vpc_security_group.sg_metrics.id,
        yandex_vpc_security_group.sg_logs.id
      ]
    }
  }
}

data "yandex_compute_image" "ubuntu_image" {
  family = var.ubuntu_family
}