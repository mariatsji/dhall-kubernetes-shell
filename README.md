# Kubernetes yamls using Dhall

> nix-shell

> dhall-to-yaml <<< './examples/deploymentSimple.dhall'

> dhall-to-yaml <<< ./examples/ingress.dhall


## kubebuilder

> mkdir -p ~/kubebuilder-poc

> cd ~/kubebuilder-poc

> kubebuilder init --domain grevling --repo grevling/kubebuilder-poc