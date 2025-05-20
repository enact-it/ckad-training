# Building applications

## 01. Set up the registry

Examine `registry.sh` in this folder. Run it using:

```bash
./registry.sh
``` 

Verify the registry is working correctly:

```bash
curl localhost:5001/v2/_catalog
```

It should return an empty list of repositories.

## 02. Build and push a container image

```bash
docker build . -t localhost:5001/sample
docker push localhost:5001/sample
```

## 03. Run the new application in a deployment

```bash
kubectl create deployment sample --image localhost:5001/sample
```

## 04. Scale the new application to 6 replicas

```bash
kubectl scale deployment sample --replicas 6
```

## 05. Configure a readinessProbe

First let's create a raw deployment manifest.

```bash
kubectl create deployment --image=localhost:5001/sample sample -o yaml --dry-run=client > sample.yaml
```

[You should be able to create something yourself!](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#configure-probes)

## 06. Configure a livenessProbe

Try to set a livenessProbe that failes deliberately!
