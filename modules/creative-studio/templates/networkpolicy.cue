package templates

import netv1 "k8s.io/api/networking/v1"

#DenyAllNetworkPolicy: netv1.#NetworkPolicy & {
	#config: #Config

	apiVersion: "networking.k8s.io/v1"
	kind: "NetworkPolicy"

	metadata: {
		name: "deny-all"
		namespace: #config.metadata.namespace
	}

	spec: {
		podSelector: {}
		policyTypes: [
			"Ingress",
			"Egress",
		]
	}
}

#AllowEgressNetworkPolicy: netv1.#NetworkPolicy & {
	#config: #Config

	apiVersion: "networking.k8s.io/v1"
	kind: "NetworkPolicy"

	metadata: {
		name: "allow-egress"
		namespace: #config.metadata.namespace
	}

	spec: {
		podSelector: {
			matchLabels: {
				app: #config.metadata.name
			}
		}

		policyTypes: ["Egress"]

		egress: [
			{
				to: [
					{
						ipBlock: {
							cidr: "0.0.0.0/0"
						}
					}
				]
			}
		]
	}
}

#AllowAppIngressNetworkPolicy: netv1.#NetworkPolicy & {
	#config: #Config

	apiVersion: "networking.k8s.io/v1"
	kind: "NetworkPolicy"

	metadata: {
		name: "allow-creative-studio-ingress"
		namespace: #config.metadata.namespace
	}

	spec: {
		podSelector: {
			matchLabels: {
				app: #config.metadata.name
			}
		}

		policyTypes: ["Ingress"]

		ingress: [
			{
				from: [
					{
						ipBlock: {
							cidr: "0.0.0.0/0"
						}
					}
				]

				ports: [
					{
						protocol: "TCP"
						port: 3000
					}
				]
			}
		]
	}
}
