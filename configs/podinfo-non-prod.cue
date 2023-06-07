values: {
  metadata: name: "podinfo"
  replicas: 2
  image: {
    repository: "ghcr.io/stefanprodan/podinfo"
  }
  container: {
    livenessPath: "/healthz"
    readinessPath: "/readyz"
    port: 9898
  }
  resources: requests: {
      cpu: "10m"
      memory: "50Mi"
    }
  resources: limits: {
      cpu: "100m"
      memory: "100Mi"
    }
  securityContext: {
    allowPrivilegeEscalation: true
    capabilities: drop: ["ALL"]
    capabilities: add: ["NET_BIND_SERVICE"]
  }
  configuration: {
    PODINFO_UI_MESSAGE: "${echo_message}"
    PODINFO_BACKEND_URL: "http://podinfo.apps/echo"
  }
}
