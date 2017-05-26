variable softlayer_username {}
variable softlayer_api_key {}

provider "ibmcloud" {
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

resource "ibmcloud_infra_virtual_guest" "schem-ex-1" {
  hostname = "ub-schem-1"
  domain = "colton.cc"
  os_reference_code = "UBUNTU_LATEST"
  datacenter = "mex01"
  cores = 1
  memory = 1024
  disks = [25]
  network_speed = 100
  local_disk = true
  private_network_only = true,
  hourly_billing = true,
  tags = ["schematics"]
}