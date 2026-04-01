package templates

import corev1 "k8s.io/api/core/v1"

#PVC: corev1.#PersistentVolumeClaim & {
	#config: #Config

	if #config.storage.enabled {

		apiVersion: "v1"
		kind:       "PersistentVolumeClaim"

		metadata: {
			name:      #config.metadata.name + "-pvc"
			namespace: #config.metadata.namespace
		}

		spec: {
			accessModes: ["ReadWriteOnce"]

			resources: {
				requests: {
					storage: #config.storage.size
				}
			}

			if #config.storage.class != _|_ {
				storageClassName: #config.storage.class
			}
		}
	}
}
