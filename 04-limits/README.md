# Limits

## 01. Maximize CPU & Memory usage using Stresser

This exercise you will learn about the difference when `resource limits` are in-place. For this we either use the `vish/stress` for X86_64 or `ghcr.io/enact-it/stresser:latest` for AARCH architecture.

```bash
kubectl apply -f stresser.yaml
```

Watch the node(s) and pods with kubectl top ... They should be maximized the resource usage by the stresser `Pod`.

Now let's limit the `Pod` resources by applying another configuration, which includes `resource limits`.

```bash
kubectl apply -f limited-stresser.yaml
```

What is the difference with the previous pod metrics?