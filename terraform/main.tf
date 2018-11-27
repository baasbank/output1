provider "google" {
  credentials = "${file("/Users/andeladeveloper/Desktop/projects/outputs/output2/ci-cd-36590e1a7ee5.json")}"
  project     = "ci-cd-223510"
  region      = "europe-west3"
  version     = "~> 1.19"
}

resource "google_compute_instance" "default" {
  name         = "lamp-instance"
  description  = "An instance to deploy a LAMP application on."
  machine_type = "n1-standard-1"
  zone         = "europe-west3-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20181004"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "git clone https://github.com/baasbank/devopsOutputs.git; cd devopsOutputs; . deploy_lamp_stack.sh"

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "all-outbound-allow" {
  name               = "all-outbound-allow"
  description        = "Allow all outbound connections access across the firewall of the Virtual Private Cloud."
  direction          = "EGRESS"
  network            = "default"
  allow {
    protocol    = "tcp"
    ports       = ["80", "8080", "443"]
  }
  destination_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-inbound_http" {
  name          = "allow-inbound-http"
  description   = "Allow inbound HTTP request"
  network       = "default"
  allow {
    protocol    = "tcp"
    ports       = ["80", "8080", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}