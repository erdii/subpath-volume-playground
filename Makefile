.PHONY: kind-create-cluster
kind-create-cluster:
	kind create cluster --config=kind.yaml --kubeconfig=kubeconfig
	@echo 'cluster created, to interact run:'
	@echo 'export KUBECONFIG=$$PWD/kubeconfig'

.PHONY: kind-delete-cluster
kind-delete-cluster:
	kind delete cluster
