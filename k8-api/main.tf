# Configure the Kubernetes provider to connect to a local Kubernetes cluster using the specified context
provider "kubernetes" {
  host                     = "https://localhost:6443"
  config_path              = "~/.kube/config"
  config_context_auth_info = "docker-desktop"
  config_context_cluster   = "docker-desktop"
}

# Define a Kubernetes deployment named "hello" running the "nginxdemos/hello" image
resource "kubernetes_deployment" "hello" {
  metadata {
    name = "hello"
  }

  spec {
    replicas = 1

    # Specify the label selector to match with the pod template
    selector {
      match_labels = {
        app = "hello"
      }
    }

    # Define the pod template for the deployment
    template {
      metadata {
        # Specify the labels to apply to the pod
        labels = {
          app = "hello"
        }
      }

      spec {
        # Define the container specification for the pod
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

# Define a Kubernetes service named "hello" that routes traffic to the "hello" deployment
resource "kubernetes_service" "hello" {
  metadata {
    name = "hello"
  }

  spec {
    # Specify the label selector to match with the pods to be exposed by the service
    selector = {
      app = "hello"
    }

    # Define the port specification for the service
    port {
      port        = 80
      target_port = 80
    }

    # Specify that the service should be exposed as a NodePort
    type = "NodePort"
  }
}
