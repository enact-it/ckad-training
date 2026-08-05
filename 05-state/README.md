# Deployment configuration

## 01. Create a stateless deployment using nginx

Examine `registry.sh` in this folder. Run it using:

```bash
kubectl apply -f deployment.yaml
``` 

Verify the Pods are up and running using the `selector label`.

```bash
kubectl get pods -l app=nginx
```

It should return three (3) replicas.

## 02. Now scale the number of pods to four (4) replicas

```bash
kubectl scale --replicas 4 deployment nginx
```

Now verify if all pods are running as expected.

## 03. Validate the status of the rollout 

```bash
kubectl rollout status deployment nginx
```

The status should be `successfully rolled out`.

Now let's put the deployment to pause.

```bash
kubectl rollout pause deployment nginx
```


## 04. Introduce breaking change to rollout

```bash
kubectl set image deployments nginx nginx=nginx:23.1
```

Verify the current `rollout status` again.

```bash
kubectl rollout status deployment nginx
```

Explain the behavior.

You may want to resume the rollout.

```bash
kubectl rollout resume deployment nginx
```

Again check the status.

```bash
kubectl rollout status deployment nginx
```

Maybe we need to restart in a controlled matter? To fix the replica pods...

```bash
kubectl rollout restart deployment nginx
```

The deployment still seems to be broken. Let's fix this later.
First try to explain which *default*  StrategyType and RollingUpdateStrategy are used. You may want to `describe` the deployment.

## 05. Fix a broken rollout with a rollback

First let's see the actual `rollout history` of the deployment.

```bash
kubectl rollout history deployment nginx
```

Now try to `undo` your previous change (in step 5) by executing and `rollover undo`.

```bash
kubectl rollout undo deployment nginx
```

Now check the `rollout history` again. What is the difference?
Also check if your rollout status, deployment, including pods are healthy again.

If your pods are not *healthy* you may want to load an earlier revision using `--to-revision 3` flag.

## 06. Apply a custom Pod Disruption Budget (pdb)

First take a look at the manifest file [pdb.yaml](pdb.yaml) and explain to youself what it configures. 

Now apply the manifest file.

```bash
kubectl apply -f pdb.yaml
```

## 07. Understand the differences between a Deployments, ReplicaSets and Pods

This small exercise you will lookup both active `Deployments` and `ReplicaSets`. As mentioned a `Deployment` is a controller that manages `ReplicaSets` to ensure the desired number of `Pods` are running.

First get a list of `Deployments`.

```bash
kubectl get deployments.apps
```

Now request the list of `ReplicaSets`.

```bash
kubectl get replicasets.apps
```

Last request the list of Pods and try to relate them to the `ReplicaSets`. Are all `Pods` available?

```bash
kubectl get pods
```

Validate that you should see the desired number of `Pods` and a related `deployment` for nginx.  You may want to filter using the parameter `-l app=nginx`.
