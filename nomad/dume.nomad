job "dume" {
  datacenters = ["homelab"]
  type = "service"

  group "dume" {
    count = 1
    network {
      port "http" {}
    }
    
    task "dume-server" {
      driver = "podman"
      config {
        image = "docker://ghcr.io/vamc19/dum-e:0.1.0"
        ports = ["http"]
        args = [
          "--host",
          "0.0.0.0",
          "--port",
          "${NOMAD_PORT_http}"
        ]
      }
      
      resources {
        cpu    = 50
        memory = 64
      }
    }
    
    service {
      name = "dume"
      port = "http"
      tags = [
        "urlprefix-/dume strip=/dume",
      ]
      check {
        type = "http"
        path = "/health"
        interval = "30s"
        timeout = "2s"
      }
    }
  }
}

