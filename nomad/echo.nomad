job "echo" {
  datacenters = ["homelab"]
  type = "service"

  group "echo" {
    count = 1
    network {
      mode = "host"
      port "http" {}
    }
    
    task "echo-server" {
      driver = "podman"
      config {
        image = "docker://jxlwqq/http-echo"
        ports = ["http"]
        args = [
          "--text",
          "Hello, welcome to ${NOMAD_IP_http} running on port ${NOMAD_PORT_http}",
          "--addr",
          ":${NOMAD_PORT_http}"
        ]
      }
      
      resources {
        cpu    = 50
        memory = 64
      }
    }
    
    service {
      name = "http-echo"
      port = "http"
      tags = [
        "urlprefix-/echo strip=/echo",
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
