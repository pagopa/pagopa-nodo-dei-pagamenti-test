
# Mock EC
 
## ENV REQUIREMENTS
  
 ```
 JAVA 1.8
 Docker
 ```
 
## How to run

Go in the root folder of the project and then:

### Build image
```
docker build -f Dockerfile -t mock-ec-prf-image:latest .
```

### Run

To run the docker:

```
docker run --name mock-ec-prf-cont mock-ec-prf-image:latest
```

or, with Kubernetes:

```
kubectl apply --kustomize kustomize/local/
```