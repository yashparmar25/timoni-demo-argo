package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#Service: corev1.#Service & {
	#config: #Config

	apiVersion: "v1"
	kind: "Service"

	metadata: {
		name: #config.metadata.name + "-service"
		namespace: #config.metadata.namespace
	}

	spec: corev1.#ServiceSpec & {
		type: "NodePort"

		selector: {
			app: #config.metadata.name
		}

		ports: [
			{
				port: 5000
				targetPort: 3000
				//nodePort: 32000
				protocol: "TCP"
				name: "http"
			},
		]
	}
}
