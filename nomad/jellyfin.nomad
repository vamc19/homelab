job "jellyfin" {
  datacenters = ["dc1"]
  type = "service"

  group "jellyfin" {
    count = 1
    
    network {
      mode = "host"
      port "http" {
        static = "8096"
      }
    }
    
    task "jellyfin-server" {
      driver = "podman"
      config {
        image = "docker://linuxserver/jellyfin:10.7.7"
        ports = ["http"]
        volumes = [
          "/mnt/data/jellyfin/config:/config",
          "/mnt/data/jellyfin/cache:/cache",
          "/mnt/media:/media"
        ]
      }
      
      resources {
        cpu = 2000
        memory = 1000
      }
    }
    
    service {
      name = "jellyfin"
      port = "http"
      tags = [
        "urlprefix-/jellyfin strip=/jellyfin",
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

