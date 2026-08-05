# Jobs

## 01. Create a Basic job

This exercise will create a job that runs “/bin/sleep 10” on busybox. 

```bash
kubectl apply -f basic-job.yaml
```

Watch the pods with `kubectl get pods -w` and monitor the behavior.

## 02. Create a Extended job

This exercise will create a job that runs “/bin/sleep 10” on busybox. 

- Makes the job run to 5 completions.
- 2 can run in parallel.

```bash
kubectl apply -f extended-job.yaml
```

Watch the pods with `kubectl get pods -w` and monitor the behavior.

## 03. Create a Cron job

This exercise will create a cron job that runs “/bin/sleep 10” on busybox, every minute (cron schedule: */1 * * * *).

Optionally create a basic job from this.

```bash
kubectl apply -f cronjob.yaml
```

Watch the pods with `kubectl get pods -w` and monitor the behavior.

## 04. Create a Initcontainer

Create an nginx pod that has a busybox init container that sleeps for 10 seconds.

```bash
kubectl apply -f init-container.yaml
```

Watch the pods with `kubectl get pods -w` and monitor the behavior.
