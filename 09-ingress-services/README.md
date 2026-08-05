# Expose applications

## 01. Creating a service to expose a resource

This exercise we are going to expose our previously created `nginx` deployment, which you have created during the [State](../05-state/deployment.yaml) exercises.

First validate if the deployment is still running? You may want to use the label.

```bash
kubectl get deployment -l app=nginx
```

If it's not running, no problem, just `kubectl apply` the manifest again.

Now that we have the `Deployment` available we can start creating the `Service`. You can create this in various ways, like using a manifest or executing `kubectl create service`.

We will use the command, since it's a simple way.

- We tell it's a `Service` type `ClusterIP`.
- We tell the name of the `Service`.
- We provide the expected `port` and `targetPort`.

```bash
kubectl create service clusterip nginx --tcp=8080:80
```

Now try to validate if the `Service` is available. Again you have to lookup the IP or use the `default` (core)DNS behaviour.

```bash
kubectl run curly --rm -it --restart=Never --image=curlimages/curl -- curl 10.96.152.3:8080
```

This should also work.

```bash
kubectl run curly --rm -it --restart=Never --image=curlimages/curl -- curl http://nginx.default.svc.cluster.local:8080
```

Great have successfully exposed the `Deployment` within your cluster.

## 02. Use an Ingress to expose outside the cluster

You may configure to `Service` as type `LoadBalancer`, but for webtraffic it's a common practice to use an `Ingress`. As Ingress controller various options exist, but we already deployed a Nginx Ingress Controller.

In our particular scenario we want to achieve the following:

- The `Ingress` must find available `Endpoints` through the previously configured `ClusterIP` based `Service` on port *8080*.
- The `Pod` is running the application on path '/', using port *80*, but is abstracted away by the `Service`.
- The actual `Ingress` will serve the application on path `/hello` using port *80*.

I already prepared a manifest, which you can inspect [nginx-ingress.yaml](./nginx-ingress.yaml). Take notice that I configured the *ingressClassName*. For this environment it's optional, but keep this in mind.

Let's now do `kubectl apply ....`.

Now when it's applied, you could test the acces directly from the lab host.

```bash
curl localhost/hello
```

Did you get the expected `Welcome page`?

Since we are using `pathType` *Prefix* we have to provide an additional *rewrite-rule* to fix the path `/hello` to `/`.
This can be easily done by adding an `Annotation`.

```bash
kubectl annotate ingress nginx-ingress nginx.ingress.kubernetes.io/rewrite-target=/
```

Now try again and you should see the famous `Welcome page`.


