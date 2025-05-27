provider "hcloud" {
  token = var.hcloud_token
}

data "http" "ip" {
  url = "http://ipecho.net/plain"
}

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "ssh_keys" {
  type        = map(string)
  description = "Map of SSH key names to SSH public keys"
}

resource "hcloud_firewall" "fw" {
  name = "firewall"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "${data.http.ip.response_body}/32"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "1-65535"
    source_ips = [
      "${data.http.ip.response_body}/32"
    ]
  }
}

resource "hcloud_ssh_key" "key" {
  for_each   = var.ssh_keys
  name       = each.key
  public_key = each.value
}

resource "hcloud_server" "lab" {
  for_each = var.ssh_keys

  name         = each.key
  image        = "ubuntu-24.04"
  server_type  = "cax21"
  location     = "fsn1"
  ssh_keys     = [each.key]
  firewall_ids = [hcloud_firewall.fw.id]

  user_data = file("${path.module}/cloud-init.yaml")
}

output "lab_ips" {
  value = {
    for name, server in hcloud_server.lab :
    name => { "ipv4" = server.ipv4_address, "ipv6" = server.ipv6_address }
  }
}
