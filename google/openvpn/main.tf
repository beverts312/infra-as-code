data "google_compute_subnetwork" "my-subnetwork" {
  name   = var.subnetwork
  region = var.region
}

resource "google_compute_instance" "openvpn_access_server_1_vm" {
  provider = google-beta
  project = var.project_id
  name = var.name
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
    network = var.network
    subnetwork = data.google_compute_subnetwork.my-subnetwork.self_link
    access_config {
    }
  }
  metadata = {
    pwdgen = var.init_password
    google-monitoring-enable = "0"
    google-logging-enable = "0"
  }
  service_account {
    email = "default"
    scopes = ["https://www.googleapis.com/auth/cloud.useraccounts.readonly", "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write"]
  }
}

resource "google_compute_firewall" "openvpn_access_server_1_tcp_443" {
  provider = google-beta
  project = var.project_id

  name = "openvpn-access-server-1-tcp-443"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = var.network
  allow {
    protocol = "TCP"
    ports = ["443"]
  }
}

resource "google_compute_firewall" "openvpn_access_server_1_tcp_943" {
  provider = google-beta
  project = var.project_id

  name = "openvpn-access-server-1-tcp-943"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = var.network
  allow {
    protocol = "TCP"
    ports = ["943"]
  }
}

resource "google_compute_firewall" "openvpn_access_server_1_udp_1194" {
  provider = google-beta
  project = var.project_id

  name = "openvpn-access-server-1-udp-1194"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = var.network
  allow {
    protocol = "UDP"
    ports = ["1194"]
  }
}

resource "google_compute_firewall" "openvpn_access_server_1_tcp_945" {
  provider = google-beta
  project = var.project_id

  name = "openvpn-access-server-1-tcp-945"
  source_ranges = [
    "0.0.0.0/0"
  ]
  target_tags = [
    "openvpn-access-server-1-deployment"
  ]
  network = var.network
  allow {
    protocol = "TCP"
    ports = ["945"]
  }
}

output "ip" {
  value = google_compute_instance.openvpn_access_server_1_vm.network_interface.0.access_config.0.nat_ip
}