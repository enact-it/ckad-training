# Volumes and data

## 01. Create a pod with a mounted emptyDir volume

Inspect the manifest [emptydir-pod.yaml](emptydir-pod.yaml) and learn that it start two containers, called `redis` and `nginx`.

```bash
kubectl apply -f emptydir-pod.yaml
``` 

Now `kubectl exec` into the *redis* container, create a file and exit the container. Now try to see if you can read that newly created file from the *nginx* container.

```bash
kubectl exec -it -c redis emptydir-pod -- touch /usr/share/data/hello-nginx
kubectl exec -it -c nginx emptydir-pod -- ls -atlr /usr/share/data/hello-nginx
```

Now say `thanks back`. Analyze the differences when not implicitly using `sh -c`.
               
```bash
kubectl exec -it -c nginx emptydir-pod -- sh -c 'echo thanks redis > /usr/share/data/hello-nginx'
kubectl exec -it -c nginx emptydir-pod -- sh -c 'cat /usr/share/data/hello-nginx'
```

## 02. Understanding persistent volumes

This exercise you will get an understanding of using *persistent volumes*.

Persistency is important when you are deploying applications with a need for *persistency* like databases or other data volumes.

Inspect the manifest [hostpath-pvc.yaml](hostpath-pvc.yaml) and learn that it creates a `persistence volume claim` with access mode *ReadWriteOnce* and storage size of *3 Mi*.

```bash
kubectl apply -f hostpath-pvc.yaml
``` 

Validate if the `pvc` is created using `kubectl get pvc` and learn it's still in *Pending* state, since it's not yet bind.

Now create a `Pod` that will request that specific `pvc`. You first may want to inspect [hostpath-pod.yaml](hostpath-pod.yaml).

```bash
kubectl apply -f hostpath-pod.yaml
``` 

now validate with `kubectl describe` if the `pvc` is mounted and a refering `pv` is created.

Did you notice the *Reclaim policy* ? Try to add a `file` and remove the corresponding `pod`. Look what happens.

```bash
kubectl get pv
kubectl exec -it hostpath-pod -- touch /tmp/data/survivor
kubectl delete pod hostpath-pod
kubectl apply -f hostpath-pod.yaml
kubectl exec -it hostpath-pod -- ls /tmp/data
kubectl delete pod hostpath-pod
kubectl delete pvc hostpath-pvc
kubectl apply -f hostpath-pvc.yaml
kubectl apply -f hostpath-pod.yaml
kubectl exec -it hostpath-pod -- ls /tmp/data
```

Does it survive a `Pod` recreation?
Does it survive a `PVC` recreation?

## 03. Forcing a certain Reclaim policy

You may have lost some data, but now we are to survive. For this we will first create the persistent volume `pv` with a certain configuration that ensures `Retain` behavior. You want to add `persistentVolumeReclaimPolicy: Retain`

Also we have to patch our `pvc` manifest. Just copy the code snippet from below and save this as `hostpath-pvc-retain.yaml`.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hostpath-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Mi
  storageClassName: ""
  volumeName: hostpath-pv
```

Do you spot the differences with the previous applied manifest [hostpath-pvc.yaml](hostpath-pvc.yaml)?

No try to remove the `Pod` and `PVC` again see what happens.

```bash
kubectl apply -f hostpath-pv.yaml
sleep 5
kubectl apply -f hostpath-pvc-retain.yaml
sleep 5
kubectl apply -f hostpath-pod.yaml
sleep 5
kubectl exec -it hostpath-pod -- touch /tmp/data/survivor
kubectl delete pod hostpath-pod
kubectl apply -f hostpath-pod.yaml
kubectl exec -it hostpath-pod -- ls /tmp/data
kubectl delete pod hostpath-pod
kubectl delete pvc hostpath-pvc
kubectl patch pv hostpath-pv --type json -p '[{"op":"remove","path":"/spec/claimRef"}]'
kubectl apply -f hostpath-pvc-retain.yaml
sleep 5
kubectl apply -f hostpath-pod.yaml
sleep 5
kubectl exec -it hostpath-pod -- ls /tmp/data
kubectl get pv
```

Some situations you may have to `edit`the `pv`.

```bash
kubectl edit pv hostpath-pv
```

The outcome is that the provisioned `pv` keeps available and can be bound to a new `Pod` by clearing the `/spec/claimRef`.
