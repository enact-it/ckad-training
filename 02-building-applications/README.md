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

## 02. Build a docker image

