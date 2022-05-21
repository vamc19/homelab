job "fabio" {
  datacenters = ["homelab"]
  type = "system"

  group "fabio" {

    network {
      port "lb" { static = 80 }
      port "ui" { static = 9998 }
    }
    
    task "fabio" {
      driver = "podman"
      
      config {
        image = "docker://blmhemu/fabio:latest"  
        network_mode = "host"
        
        ports = [
          "lb", 
          "ui"
        ]
        
        volumes = [
          "local/fabio.properties:/etc/fabio/fabio.properties:Z"
        ]
      }
      
      template {
        data = <<EOF
proxy.addr = :80
EOF
        
        destination = "local/fabio.properties"
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}

