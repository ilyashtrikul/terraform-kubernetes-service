resource "kubernetes_service" "service" {
  metadata {
    name        = var.app_name
    namespace   = var.app_namespace
    annotations = var.annotations
    labels      = local.labels
  }
  spec {
    selector                    = local.labels
    type                        = var.type
    load_balancer_ip            = var.type == "LoadBalancer" ? var.load_balancer_ip : null
    load_balancer_source_ranges = var.type == "LoadBalancer" ? var.load_balancer_ips_whitelist : null
    dynamic "port" {
      iterator = port
      for_each = var.port_mapping
      content {
        name        = port.value.name
        port        = port.value.external_port
        protocol    = port.value.protocol
        node_port   = port.value.node_port
        target_port = port.value.internal_port
      }
    }
  }
}