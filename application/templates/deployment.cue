package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	_config:    #Config
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   _config.metadata
	spec:       appsv1.#DeploymentSpec & {
    replicas: _config.replicas
		selector: matchLabels: _config.selectorLabels
		template: {
			metadata: {
				labels: _config.selectorLabels
			}
			spec: corev1.#PodSpec & {
				serviceAccountName: _config.metadata.name
				containers: [
					{
						name: _config.metadata.name
            image: "\(_config.image.repository):\(_config.image.tag)"
						imagePullPolicy: _config.image.pullPolicy
						ports: [
							{
								name:          "http"
								containerPort: _config.container.port
								protocol:      "TCP"
							},
						]
            if _config.container.livenessPath != _|_ {
              livenessProbe: {
                httpGet: {
                  path: _config.container.livenessPath
                  port: "http"
                }
              }
            }
            if _config.container.readinessPath != _|_ {
              readinessProbe: {
                httpGet: {
                  path: _config.container.readinessPath
                  port: "http"
                }
              }
            }
            if _config.configuration != _|_ {
              env: [
                for n, v in _config.configuration {
                  name: "\(n)",
                  value: "\(v)"
                }
              ]
            }
						if _config.resources != _|_ {
							resources: _config.resources
						}
						if _config.securityContext != _|_ {
							securityContext: _config.securityContext
						}
            if _config.container.command != _|_ {
              command: _config.container.command
            }
					},
				]
			}
		}
	}
}
