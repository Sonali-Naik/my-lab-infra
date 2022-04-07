terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}
provider "docker" {}
resource "docker_image" "targetserver" {
  name         = "nishanthkp/targetserver:ubuntu16"
  keep_locally = true
}
resource "docker_container" "web_server" {
  image = docker_image.targetserver.name # Calling Line 12
  name  = "web_server"
  ports {
    internal = 5000
    external = 5000
  }
}
resource "docker_container" "db_server" {
  image = docker_image.targetserver.name # Caling line 12
  name  = "db_server"
  ports {
    internal = 3306
    external = 3306
  }
}

# Print DB Server IP
output "db_server_container_ip" {
  value = docker_container.db_server.ip_address
  description = "IP of the DB Docker Container"
}

# Print Web Server IP
output "web_server_container_ip" {
  value = docker_container.web_server.ip_address
  description = "IP of the Web Docker Container"
}


resource "local_file" "db_inventory" {
  content = templatefile("../ansibleinfracm/host_vars/db_server.template",{
    db_ip = "${docker_container.db_server.ip_address}"
  })
  filename = "../ansibleinfracm/host_vars/db_server.yml"
}

resource "local_file" "web_inventory" {
  content = templatefile("../ansibleinfracm/host_vars/web_server.template",{
    web_ip = "${docker_container.web_server.ip_address}"
  })
  filename = "../ansibleinfracm/host_vars/web_server.yml"
}