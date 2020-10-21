
terraform {
## This code follows 0.12 syntax of HCL, its not compatible with any versions below 0.12.
  required_version = ">= 0.12"
}

provider "google" {
  version = "3.5.0"


  credentials = file("account.json")
  
  project     = var.var_project
  region      = var.var_region
  zone        = var.var_zone
}

# # ----------------------------------------------------------------
# Create the mynetwork network
# # --------------------------------------------------------------
resource "google_compute_network" "my_network" {
  name                    = "my_network"
  auto_create_subnetworks = true
}


# # --------------------------------------------------------------
# Add a firewall rule to allow HTTP, SSH, RDP, and ICMP traffic on mynetwork
# # --------------------------------------------------------------
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name    = "my-compute-network-firewall"
  description = "This allows http ssh rdp icmp"
  network = google_compute_network.my_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# # -----------------------------------------------------------------------------------------
// Creating compute Instance resource
# # -----------------------------------------------------------------------------------------
resource "google_compute_instance" "vm_instance" {
  name                  = "my-vm-instance"
  description           = "This is Johns vm"
  machine_type          = var.var_machine_type
  project               = var.var_project
  zone                  = var.var_zone

  tags             = ["tag-1", "tag-2"]

  deletion_protection   = "false" 

  boot_disk {
    initialize_params {
      image      = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network      = var.var_network

    access_config {
    nat_ip  = "" 
     }

  }


}

