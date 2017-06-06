variable bluemix_api_key {}
variable softlayer_username {}
variable softlayer_api_key {}

provider "ibmcloud" {
  bluemix_api_key = "${var.bluemix_api_key}"
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

data "ibmcloud_infra_image_template" "compute_template" {
  name = "compute-node"
}

resource "ibmcloud_infra_virtual_guest" "dal-computenode" {
  count = 0
  hostname = "dal-cn-n"
  domain = "grid.local"
  image_id = "${data.ibmcloud_infra_image_template.compute_template.id}"
  datacenter = "dal13"
  cores = 2
  memory = 2048
  network_speed = 1000
  local_disk = false
  private_network_only = true,
  hourly_billing = true,
  tags = ["schematics","compute"]
}