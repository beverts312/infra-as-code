#tfimport-terraform import google_compute_instance.openvpn_access_server_1_vm  __project__/us-central1-c/openvpn-access-server-1-vm
resource "google_compute_instance" "openvpn_access_server_1_vm" {
  provider = google-beta

  name = "openvpn-access-server-1-vm"
  can_ip_forward = true
  zone = "us-central1-c"
  machine_type = "g1-small"
  tags = [
    "openvpn-access-server-1-deployment"
  ]
  boot_disk {
    device_name = "autogen-vm-tmpl-boot-disk"
    auto_delete = true
    initialize_params {
      size = 20
      image = "https://www.googleapis.com/compute/v1/projects/openvpn-access-server-200800/global/images/aspub2113-20231113"
      type = "pd-standard"
    }
  }
  network_interface {
    network = "https://www.googleapis.com/compute/v1/projects/main-411208/global/networks/default"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/main-411208/regions/us-central1/subnetworks/default"
    access_config {
    }
  }
  metadata = {
    pwdgen = "ypesAg5+8hBk"
    google-monitoring-enable = "0"
    google-logging-enable = "0"
  }
  service_account {
    email = "default"
    scopes = ["https://www.googleapis.com/auth/cloud.useraccounts.readonly", "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write"]
  }
}

#tfimport-terraform import google_compute_firewall.openvpn_access_server_1_tcp_443  __project__/openvpn-access-server-1-tcp-443
resource "google_compute_firewall" "openvpn_access_server_1_tcp_443" {
  provider = google-beta

  name = "openvpn-access-server-1-tcp-443"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = "https://www.googleapis.com/compute/v1/projects/main-411208/global/networks/default"
  allow {
    protocol = "TCP"
    ports = ["443"]
  }
}

#tfimport-terraform import google_compute_firewall.openvpn_access_server_1_tcp_943  __project__/openvpn-access-server-1-tcp-943
resource "google_compute_firewall" "openvpn_access_server_1_tcp_943" {
  provider = google-beta

  name = "openvpn-access-server-1-tcp-943"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = "https://www.googleapis.com/compute/v1/projects/main-411208/global/networks/default"
  allow {
    protocol = "TCP"
    ports = ["943"]
  }
}

#tfimport-terraform import google_compute_firewall.openvpn_access_server_1_udp_1194  __project__/openvpn-access-server-1-udp-1194
resource "google_compute_firewall" "openvpn_access_server_1_udp_1194" {
  provider = google-beta

  name = "openvpn-access-server-1-udp-1194"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = "https://www.googleapis.com/compute/v1/projects/main-411208/global/networks/default"
  allow {
    protocol = "UDP"
    ports = ["1194"]
  }
}

#tfimport-terraform import google_compute_firewall.openvpn_access_server_1_tcp_945  __project__/openvpn-access-server-1-tcp-945
resource "google_compute_firewall" "openvpn_access_server_1_tcp_945" {
  provider = google-beta

  name = "openvpn-access-server-1-tcp-945"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = "https://www.googleapis.com/compute/v1/projects/main-411208/global/networks/default"
  allow {
    protocol = "TCP"
    ports = ["945"]
  }
}
