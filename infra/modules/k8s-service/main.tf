resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = true
  chart            = "${path.module}/chart"

  values = [yamlencode({
    replicaCount  = var.replicas
    containerPort = var.port
    env           = var.env
    secretEnv     = var.secret_env

    image = {
      repository = var.image
      tag        = var.tag
      pullPolicy = var.tag == "latest" ? "Always" : "IfNotPresent"
    }

    # Public services get an internet-facing load balancer on port 80
    # (in the public subnets); private ones a ClusterIP on the container port.
    service = {
      type = var.public ? "LoadBalancer" : "ClusterIP"
      port = var.public ? 80 : var.port
    }
  })]

  wait    = true
  timeout = 600
}
