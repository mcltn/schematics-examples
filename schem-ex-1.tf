variable softlayer_username {}
variable softlayer_api_key {}
variable template_password {}

provider "ibmcloud" {
  softlayer_username = "${var.softlayer_username}"
  softlayer_api_key = "${var.softlayer_api_key}"
}

data "ibmcloud_infra_image_template" "compute_template" {
  name = "template-cn"
}

resource "ibmcloud_infra_virtual_guest" "dal-computenode" {
  count = 1
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

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -sta -ExecutionPolicy Unrestricted -Command 'c:\\installs\\configurenode.ps1'",
      "powershell.exe -sta -ExecutionPolicy Unrestricted -Command 'BuildComputeNode -password ${var.template_password}'"
    ],
    connection {
      type = "winrm"
      host = "${ibmcloud_infra_virtual_guest.dal-computenode.ipv4_address}"
      user = "templateadmin"
      password = "${var.template_password}"
      timeout = "2m"
    }
  }
}