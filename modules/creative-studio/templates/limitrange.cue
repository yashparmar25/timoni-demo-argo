package templates

import corev1 "k8s.io/api/core/v1"

#LimitRange: corev1.#LimitRange & {
	#config: #Config

	apiVersion: "v1"
	kind:       "LimitRange"

	metadata: {
		name:      #config.metadata.name + "-limits"
		namespace: #config.metadata.namespace
	}

	spec: {
		limits: [
			{
				type: "Container"

				default: {
					cpu:    #config.limits.default.cpu
					memory: #config.limits.default.memory
				}

				defaultRequest: {
					cpu:    #config.limits.defaultRequest.cpu
					memory: #config.limits.defaultRequest.memory
				}
			},
		]
	}
}
