resource "yandex_vpc_security_group" "sg_common" {
  name        = "common-security-group"
  description = "Allow any egress, SSH ingress and node exporter ingress security group"
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

  ingress {
    description    = "Allow Prometheus node exporter port"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = local.cloud_subnets
  }

  egress {
    description    = "Allow ALL"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
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

resource "yandex_vpc_security_group" "sg_metrics" {
  name        = "metrics-security-group"
  description = "Grafana and Prometheus security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow Grafana UI"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = [local.localhost_public_ip]
  }

  ingress {
    description    = "Allow Prometheus ingress"
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = flatten([local.localhost_public_ip, local.cloud_subnets])
  }
}

resource "yandex_vpc_security_group" "sg_logs" {
  name        = "logs-security-group"
  description = "OpenSearch and OpenSearch Dashboards security group"
  folder_id   = var.folder_id
  network_id  = yandex_vpc_network.vpc_net.id

  labels = {
    managed_by = "terraform"
  }

  ingress {
    description    = "Allow OpenSearch ingress port for logs shipping by FluentBit agents"
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = flatten([local.cloud_subnets])
  }

  ingress {
    description    = "Allow OpenSearch Dashboards UI"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = [local.localhost_public_ip]
  }
}