package main

import (
	templates "timoni.sh/creative-studio/templates"
)

values: templates.#Config

timoni: {
	apiVersion: "v1alpha1"

	instance: templates.#Instance & {
		config: values

		config: {
			moduleVersion: *"0.1.0" | string @tag(mv, var=moduleVersion)
			kubeVersion:   *"1.29" | string @tag(kv, var=kubeVersion)
		
			metadata: {
				name: *values.metadata.name | string @tag(name)
				namespace: *values.metadata.namespace | string @tag(namespace)
			
				#Version: moduleVersion
			}

			app: *"creative-studio" | string

			replicas: *1 | int

			service: {
				port: *5000 | int
			}

			strategy: *{
				maxUnavailable: 1
				maxSurge:       1
				minReadySeconds: 5
			} | _

			resources: *{
				requests: {
					cpu:    "100m"
					memory: "128Mi"
				}
				limits: {
					cpu:    "300m"
					memory: "256Mi"
				}
			} | _

			storage: *{
				enabled: false
				size:    "1Gi"
			} | _
			image: _
			message: _
		}
	}

	apply: app: [
		for k, v in instance.objects {
			if v != _|_ {
				v
			}
		}
	]
}
