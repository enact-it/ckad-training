# Kustomize

## 01. Implement Development environment using Kustomize templates

Inspect the [base](./base/) baseline and [overlays](./overlays/). Only a single overlay with *patches* for Development exists. 

First deploy the dev environment.

```bash
kubectl create ns dev
kubectl apply -k overlays/dev
```

## 02. Implement Accepance environment using Kustomize templates

Just copy the `dev` folder inside [overlays](./overlays/) to a new folder called `acc`. Ensure this new folder is part of the `overlays`.

The requirement is to ensure *acc* has 3 replicas, which you can adjust in the `patch.yaml`.

Kustomize is so easy.

Now deploy the acc environment and validate if 3 replicas are active.

```bash
cp -r overlays/dev overlays/acc
# Don't forget to edit the patch.yaml
kubectl create ns acc
kubectl apply -k overlays/acc
```

## 03. Implement Production environment using Kustomize templates

Now try it yourself for production, which has a requirement of 6 replicas.

## 04. Implement a PostgreSQL environment using Kustomize templates

Now try to build your own `Kustomize` scripts. For inspiration have a look at [postgres_example](./postgres_example/).