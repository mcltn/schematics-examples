variable softlayer_username {}
variable softlayer_api_key {}
variable template_image {}
variable domain {}
variable domain_username {}
variable domain_password {}
variable dns_server {}
variable headnode {}
variable compute_nodes {}

provider "ibmcloud" {
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

data "ibmcloud_infra_image_template" "compute_template" {
  name = "${var.template_image}"
}

resource "ibmcloud_infra_virtual_guest" "dal-computenode" {
  count = ${var.compute_nodes}
  hostname = "dal-cn${count.index}"
  domain = "grid.local"
  image_id = "${data.ibmcloud_infra_image_template.compute_template.id}"
  datacenter = "dal13"
  cores = 2
  memory = 2048
  network_speed = 1000
  local_disk = false
  private_network_only = false,
  hourly_billing = true,
  tags = ["schematics","compute"]
  user_metadata = "#ps1_sysnative\nscript: |\n<powershell>\nc:\\installs\\configurecomputenode.ps1 -domain ${var.domain} -username ${var.domain_username} -password ${var.domain_password} -dns_server ${var.dns_server} -headnode ${var.headnode}\n</powershell>"
}