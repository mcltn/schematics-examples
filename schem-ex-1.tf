variable softlayer_username {}
variable softlayer_api_key {}
variable template_password {}

provider "ibmcloud" {
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

resource "ibmcloud_infra_virtual_guest" "dal-computenode" {
  count = 2
  hostname = "dal-cn${count.index+1}"
  domain = "grid.local"
  image_id = 1657043
  datacenter = "dal13"
  cores = 2
  memory = 2048
  network_speed = 1000
  local_disk = false
  private_network_only = false,
  hourly_billing = true,
  tags = ["schematics","compute"]

}