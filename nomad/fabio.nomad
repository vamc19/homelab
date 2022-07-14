job "fabio" {
  datacenters = ["homelab"]
  type = "system"

  group "fabio" {

    network {
      port "lb" { static = 9999 }
      port "ui" { static = 9998 }
    }
    
    task "fabio" {
      driver = "podman"
      config {
        image = "docker://blmhemu/fabio:latest"
        network_mode = "host"
        ports = ["lb", "ui"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
