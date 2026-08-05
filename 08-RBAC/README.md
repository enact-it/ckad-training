# Security and RBAC

## 01. Create a secure pod

This exercise we are going to create a `hardened` pod.  For this we have used the following specs:

- Ensure the container runs the `alpine` version of `nginx`.
- Ensure the container does not run with `root` privileges.
- Ensure the user ID (UID) is set to '1000;.
- Ensure the container does not has any syscall privileges.
- Ensure the container mounts the root filesystem as read-only.
- Ensure the application still works as expected and loads temporary, caching volumes as `emptyDir`.

Take a look and inspect the provided manifest [secure-pod.yaml](secure-pod.yaml).

Apply the manifest to create the Pod.

```bash
kubectl apply -f secure-pod.yaml
```

Now `kubectl exec` into the Pod, verify the following.

- Check who is running the workload with `whoami`.
- Try to delete root folders, such as `rm -rf /etc/`.
- Validate if all capabilities are subzero, using `cat /proc/1/status | grep -i cap`.

## 02. Setup a log-reader-pod using RBAC

This exercise you are going to learn how to setup a `Role`, necessary `Rolebinding` and `Pod` to validate the configuration.

First inspect both manifests that creates all required resources. Do you know what is used as identity by the actual `Pod`?

Create the corresponding `ServiceAccount` first.

```bash
kubectl create serviceaccount ckad
```

Now apply the manifests.

```bash
kubectl apply -f log-role.yaml
kubectl apply -f log-rolebinding.yaml
kubectl apply -f log-pod.yaml
```

Now `kubectl exec` into the Pod, verify the following.

- Can you list the `Pods` using `kubectl get pods`?
- Can you also list the `Nodes` using `kubectl get nodes`?
- Which other `kubectl` command is working?

## 03. Protect traffic to a namespace using Network Policies

Some applications require additional protection, such as only allowing `https` traffic. This example you are going to implement a protected namespace, called *protected*.

For simplicity we gimmic `https` traffic by just changing the port.

First create the `Namespace`.

```bash
kubectl create ns protected
```

Validate that you now see the namespace using `kubectl get`.

Now let's first create the `Pod`, which is our protected resource.

Inspect the manifest and apply it using `kubectl apply`. Ensure it's applied in the *protected* namespace.

Now let's test the current access on both port *80* and port *443*. For this assignment you need to use the current ip address of the pod. You can get this using `kubectl get pods -o wide`.

```bash
kubectl run curly --rm -it --restart=Never --image=curlimages/curl -n protected -- curl 100.64.1.247:80
kubectl run curly --rm -it --restart=Never --image=curlimages/curl -n protected -- curl 100.64.1.247:443
```

Now let's apply the `NetworkPolicy`, which acts on *L4*.

```bash
kubectl apply -f protected-netpol.yaml
```

Now test both ports again. Which one does succeed?

You have completed all labs.
