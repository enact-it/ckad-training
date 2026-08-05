# Configmaps and secrets

## 01. Create a Configmap from file path

`Configmap`can be created using a manifest, but also using a `create --from-file`.

This exercise you are going to create a `Configmap` from a file path. let's first create a file path.

```bash
mkdir -p test
echo "red" > test/1
echo "blue" > test/2
echo "green" > test/3 
ls -1 test
```

Verify if the files are shown and continue with creating the actual `Configmap`.

```bash
kubectl create configmap test --from-file=test/
kubectl get cm test -o yaml
```

Are all keys and values as expected?

## 02. Add a new key/value using manifest

This situation we have to add a new key/value, named `4/purple`. We can do this either through the `manifest`, direct `edit` or applying a patch.

```bash
kubectl patch cm test  --type json -p '[{"op":"add","path":"/data/4","value":"purple\n"}]'
```

Now get the `cm` test and look if key *4* with value *purple*.

## 03 Create a Secret from Literal

This exercise we are going to use literals to create a `secret` called `secret`.

```bash
kubectl create secret generic secret --from-literal=username=username --from-literal=password=password
kubectl get secret secret -o yaml
```

Are all keys and values as expected? Did you know you can use `base64` to crypt/decrypt the actual value.
For example what is the password?

```bash
echo cGFzc3dvcmQ= | base64 -d
```

## 04 Using Secrets within Pods

Now that we have both a `Configmap` and a `Secret` we make these available within a `Pod`.

For this an example manifest is available, examine [secret-pod.yaml](secret-pod.yaml).

```bash
kubectl apply -f secret-pod.yaml
```

Now `kubectl exec` into the Pod, verify the variables and mounted volume that expose the `Secret`.

Did you know that only `mounted volumes` are updated in realtime without recreating the pod?

Let's give it a try.

```bash
echo GreatestPassword | base64
kubectl patch secret secret --type json -p '[{"op":"add","path":"/data/password","value":"R3JlYXRlc3RQYXNzd29yZAo="}]'
```

Validate the 'password` values again, which are available within the Pod. Which is reflecting your change? Variable or the mounted volume'.

## 05 Using Configmap within Pods

This exercise you are going to create a new manifest file, which uses `secret-pod.yaml` as startingpoint.
Save the new file as `config-pod.yaml`.

Start with inspecting the changes that are made for adding the `Configmap` as `volume Mount`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
    - name: nginx
      image: nginx
      env:
        - name: USERNAME
          valueFrom:
            secretKeyRef:
              name: secret
              key: username
        - name: PASSWORD
          valueFrom:
            secretKeyRef:
              name: secret
              key: password
      volumeMounts:
        - name: secret-volume
          mountPath: "/etc/secret"
          readOnly: true
        - name: config-volume
          mountPath: "/etc/config"
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: secret
    - name: config-volume
      configMap:
        name: test
```

```bash
kubectl apply -f secret-pod.yaml
```

Now `kubectl exec` into the Pod, verify the variables and mounted volume that expose the newly added `Configmap`.
