.PHONY: kind-create-cluster
kind-create-cluster:
	kind create cluster --config=kind.yaml --kubeconfig=kubeconfig
	@echo '\ncluster created, to interact run: \n\nexport KUBECONFIG=$$PWD/kubeconfig'

.PHONY: kind-delete-cluster
kind-delete-cluster:
	kind delete cluster
