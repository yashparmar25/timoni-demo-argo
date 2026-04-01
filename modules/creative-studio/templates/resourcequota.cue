package templates

import corev1 "k8s.io/api/core/v1"

#ResourceQuota: corev1.#ResourceQuota & {
	#config: #Config

	apiVersion: "v1"
	kind:       "ResourceQuota"

	metadata: {
		name:      #config.metadata.name + "-quota"
		namespace: #config.metadata.namespace
	}

	spec: {
		hard: {
			"requests.cpu":    #config.quota.requests.cpu
			"limits.cpu":      #config.quota.limits.cpu

			"requests.memory": #config.quota.requests.memory
			"limits.memory":   #config.quota.limits.memory

			"pods":            #config.quota.pods
		}
	}
}
