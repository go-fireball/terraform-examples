provider "kubernetes" {
  host                     = "https://localhost:6443"
  config_path              = "~/.kube/config"
  config_context_auth_info = "docker-desktop"
  config_context_cluster   = "docker-desktop"
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name = "hello"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello"
        }
      }

      spec {
        container {
          image = "nginxdemos/hello"
          name  = "hello"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "hello" {
  metadata {
    name = "hello"
  }

  spec {
    selector = {
      app = "hello"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
