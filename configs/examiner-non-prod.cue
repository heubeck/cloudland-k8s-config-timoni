values: {
  metadata: name: "examiner"

  image: {
    repository: "quay.io/heubeck/examiner"
  }
  container: {
    livenessPath: "/.well-known/live"
    readinessPath: "/.well-known/ready"
    port: 8080
  }
  resources: requests: {
      cpu: "10m"
      memory: "50Mi"
    }
  resources: limits: {
      cpu: "100m"
      memory: "100Mi"
    }
  configuration: {
    ECHO_VALUE: "${echo_message}"
  }
}
