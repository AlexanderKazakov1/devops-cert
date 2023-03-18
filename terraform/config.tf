terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.87.0"
    }
  }
}

variable "token" { type = string }
variable "cloud_id" { type = string }
variable "folder_id" { type = string }

provider "yandex" {
  token                    = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

variable "subnet_id" { type = string }

resource "yandex_compute_instance" "build" {
  name = "ubuntu-18-4-build"

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8c3dv7t6prd7j4n162"
      type = "network-ssd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

resource "yandex_compute_instance" "deploy" {
  name = "ubuntu-18-4-deploy"

  resources {
    cores  = "2"
    memory = "4"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8c3dv7t6prd7j4n162"
      type = "network-ssd"
      size = "10"
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    user-data = file("./meta.txt")
  }
}

resource "local_file" "address" {
  content  = "{ \"build_ip\" : \"${yandex_compute_instance.build.network_interface.0.ip_address}\", \"deploy_ip\" : \"${yandex_compute_instance.deploy.network_interface.0.ip_address}\" }"
  filename = "../address.json"
}