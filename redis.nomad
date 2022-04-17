job "redis" {
  datacenters = ["homelab"]
  type = "service"

  group "redis" {
    count = 1
    
    network {
      port "db" { to = 6379 }
    }

    task "redis" {
      driver = "podman"

      config {
        image = "docker://redis:6.2"
        ports = ["db"]
      }

      resources {
        cpu    = 100
        memory = 256
      }

      service {
        name = "redis"
        port = "db"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

