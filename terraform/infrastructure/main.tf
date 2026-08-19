resource "local_file" "ansible_inventory" {
  content  = <<-EOT
  [app_nodes]
  ${yandex_compute_instance.node["app-server"].network_interface.0.nat_ip_address}

  [ci_nodes]
  ${yandex_compute_instance.node["ci-server"].network_interface.0.nat_ip_address}

  [all:vars]
  ansible_user = ubuntu
  ansible_python_interpreter=/usr/bin/python3
  ansible_ssh_private_key_file = ${var.ssh_private_key}
  EOT
  filename = "${path.module}/../../ansible/inventory.ini"
}

resource "local_file" "vault_server_ip" {
  content  = <<-EOT
  vault_server_ip = "${yandex_compute_instance.node["ci-server"].network_interface.0.nat_ip_address}"
  EOT
  filename = "${path.module}/../vault/terraform.tfvars"
}

resource "local_file" "jcasc_ips" {
  content  = <<-EOT
  vault_server_ip: "${yandex_compute_instance.node["ci-server"].network_interface.0.ip_address}"
  app_server_ip: "${yandex_compute_instance.node["app-server"].network_interface.0.ip_address}"
  EOT
  filename = "${path.module}/../../ansible/roles/jenkins/vars/ips.yml"
}

locals {
  localhost_public_ip = "${chomp(data.http.public_ip.response_body)}/32"
  cloud_subnets       = concat(var.cidr_a, var.cidr_b)
}

data "http" "public_ip" {
  url = "https://checkip.amazonaws.com"
}