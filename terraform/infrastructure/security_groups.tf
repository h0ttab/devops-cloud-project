resource "yandex_vpc_security_group" "sg_ssh" {
  name        = "ssh-security-group"
  description = "SSH ingress allow security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }
}

resource "yandex_vpc_security_group" "sg_http" {
  name        = "http-security-group"
  description = "HTTP ingress allow security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow HTTP:8080"
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  ingress {
    description    = "Allow HTTP:80"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  ingress {
    description    = "Allow HTTPS:443"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }
}

resource "yandex_vpc_security_group" "sg_egress_all" {
  name        = "egress-all-security-group"
  description = "Allow all egress traffic security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  egress {
    description    = "Allow ALL"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_jenkins" {
  name        = "jenkins-security-group"
  description = "Jenkins security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow Jenkins agents"
    protocol       = "TCP"
    port           = 50000
    v4_cidr_blocks = local.cloud_subnets
  }

    ingress {
    description    = "Allow Jenkins HTTP UI"
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = [local.localhost_public_ip]
  }
}

resource "yandex_vpc_security_group" "sg_vault" {
  name        = "vault-security-group"
  description = "HashiCorp Vault security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow HashiCorp Vault API port"
    protocol       = "TCP"
    port           = 8200
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }

  ingress {
    description    = "Allow HashiCorp Vault cluster internal port"
    protocol       = "TCP"
    port           = 8201
    v4_cidr_blocks = local.cloud_subnets
  }
}

resource "yandex_vpc_security_group" "sg_grafana" {
  name        = "grafana-security-group"
  description = "Grafana dashboard security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow Grafana port"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = [local.localhost_public_ip]
  }
}

resource "yandex_vpc_security_group" "sg_prometheus" {
  name        = "prometheus-security-group"
  description = "Prometheus security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow Prometheus port ingress"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }
}

resource "yandex_vpc_security_group" "sg_node_exporter" {
  name        = "node-exporter-security-group"
  description = "Prometheus node exporter security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow Prometheus node exporter port"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = local.cloud_subnets
  }
}