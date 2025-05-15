# Cluster setup

In this lab, we're going to set up our Kubernetes "cluster" using kind.


## 01. Create the cluster

First, let's create our cluster. This assumes you're already connected to a lab machine or you have kind available locally.

```bash
kind create cluster --config cluster.yaml
```

## 02. Set the kubeconfig

Especially if you have multiple clusters to manage on your machine, you'll want to explicitly set the context you're using.

```bash
kubectl config set-context kind-ckad-training
```

## 03. Set up metrics-server

If you want to see any statistics on node or pod CPU/memory usage, you'll need something like metrics-server installed. Let's install it.

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system
```

This will install `metrics-server` in the `kube-system` namespace. Wait a bit and check if you can reach it using `kubectl top nodes`

## 04. Set up an ingress controller

We need a way to expose services running on kubernetes to the outside world. One of the (recommended) ways is to use an ingress controller:

```bash
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
```

## 05. Test the ingress controller

Let's see if everything's working correctly!

```bash
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml
```

Now, try:
```bash
curl localhost/foo
curl localhost/bar
```
