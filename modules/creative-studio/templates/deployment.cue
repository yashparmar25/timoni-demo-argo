package templates

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

#Deployment: appsv1.#Deployment & {
	#config: #Config

	apiVersion: "apps/v1"
	kind:       "Deployment"

	metadata: #config.metadata

	spec: {
		replicas: #config.replicas

		strategy: {
			type: "RollingUpdate"
			rollingUpdate: {
				maxUnavailable: #config.strategy.maxUnavailable
				maxSurge:       #config.strategy.maxSurge
			}
		}

		minReadySeconds: #config.strategy.minReadySeconds

		selector: matchLabels: {
			app: #config.metadata.name
		}

		template: {
			metadata: labels: {
				app: #config.metadata.name
			}

			spec: corev1.#PodSpec & {

				imagePullSecrets: [
					{
						name: "harbor-secret"
					},
				]

				containers: [
					{
						name: #config.metadata.name

						image:
							#config.image.repository +
							"@" +
							#config.image.digest

						ports: [
							{
								containerPort: 5000
							},
						]

						envFrom: [
							{
								secretRef: corev1.#SecretEnvSource & {
									name: #config.secretName
								}
							},
						]

						resources: {
							requests: {
								cpu:    #config.resources.requests.cpu
								memory: #config.resources.requests.memory
							}
							limits: {
								cpu:    #config.resources.limits.cpu
								memory: #config.resources.limits.memory
							}
						}

						if #config.storage.enabled {
							volumeMounts: [
								{
									name:      "app-storage"
									mountPath: "/app/data"
								},
							]
						}
					},
				]

				if #config.storage.enabled {
					volumes: [
						{
							name: "app-storage"
							persistentVolumeClaim: {
								claimName: #config.metadata.name + "-pvc"
							}
						},
					]
				}
			}
		}
	}
}
