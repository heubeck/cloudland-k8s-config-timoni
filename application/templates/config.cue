package templates

import (
	"strings"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	corev1 "k8s.io/api/core/v1"
)

// Config defines the schema and defaults for the Instance values.
#Config: {
	// Metadata (common to all resources)
	metadata: metav1.#ObjectMeta
	metadata: name:      *"application" | string & =~"^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$" & strings.MaxRunes(63)
	metadata: namespace: *"default" | string & strings.MaxRunes(63)
	metadata: labels:    *selectorLabels | {[ string]: string}
	metadata: labels: "app.kubernetes.io/version": image.tag
	metadata: annotations?: {[ string]:            string}

	// Redis
	redis?: string

	// Deployment
	replicas:       *1 | int & >0
	selectorLabels: *{"app.kubernetes.io/name": metadata.name} | {[ string]: string}

  configuration?: {[string]: string}

	// Container
	image: {
		repository: *"image-repository" | string
		tag:        *"image-tag" | string
		pullPolicy:  *"IfNotPresent" | string
	}
  container: {
    port:           *8080 | int & >0 & <=65535
    livenessPath?:  string
    readinessPath?: string
    command?: [ ...string]
  }
	resources?:       corev1.#ResourceRequirements
	securityContext?: corev1.#SecurityContext

	// Service
	service: port: *80 | int & >0 & <=65535
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		"\(config.metadata.name)-sa":     #ServiceAccount & {_config: config}
		"\(config.metadata.name)-svc":    #Service & {_config:        config}
		"\(config.metadata.name)-deploy": #Deployment & {_config:     config}
	}
}
