package templates

import (
	timoniv1 "timoni.sh/core/v1alpha1"
)

#Config: {

	kubeVersion!:   string
	moduleVersion!: string

	metadata: {
		name!: string
		namespace!: string
	}

	app!: string

	image!: timoniv1.#Image

	replicas: int

	service: {
		port:     int
		nodePort?: int   // optional (only for NodePort)
	}

	// secretName is the name of an existing Secret in the same namespace.
	// It is not created by this module.
	secretName: *"creative-studio-secrets" | string

	strategy?: {
		maxUnavailable: int
		maxSurge:       int
		minReadySeconds: int
	}

	resources?: {
		requests: {
			cpu:    string
			memory: string
		}
		limits: {
			cpu:    string
			memory: string
		}
	}

	quota?: {
		requests: {
			cpu:    string
			memory: string
		}
		limits: {
			cpu:    string
			memory: string
		}
		pods: string
	}

	limits?: {
		default: {
			cpu:    string
			memory: string
		}
		defaultRequest: {
			cpu:    string
			memory: string
		}
	}

	storage?: {
		enabled: bool
		size:    string
		class?:  string
	}

	message!: string
}

#Instance: {
	config: #Config

	objects: {

		deployment: #Deployment & {
			#config: config
		}

		service: #Service & {
			#config: config
		}

		denyNetwork: #DenyAllNetworkPolicy & {
			#config: config
		}

		allowEgress: #AllowEgressNetworkPolicy & {
			#config: config
		}

		allowIngress: #AllowAppIngressNetworkPolicy & {
			#config: config
		}

		if config.quota != _|_ {
			resourceQuota: #ResourceQuota & {
				#config: config
			}
		}

		if config.limits != _|_ {
			limitRange: #LimitRange & {
				#config: config
			}
		}

		if config.storage != _|_ && config.storage.enabled == true {
			pvc: #PVC & {
				#config: config
			}
		}
	}
}
