# Beetroot — Go App Deployment on Kubernetes

A small Go REST API ("Beetroot") containerized with Docker and deployed to a Kubernetes cluster behind a choice of three reverse proxies: **Nginx**, **Apache**, or **Traefik**.

Part of the **IKT210 — Cloud Infrastructure** course at the University of Agder.

## Components

### Application
- Go REST API entrypoint at [`cmd/beetroot/main.go`](cmd/beetroot/main.go), listening on port `8080`
- Routes defined in [`api/`](api/), config loading in [`config/`](config/), DB layer in [`db/`](db/)
- Multi-stage [`Dockerfile`](Dockerfile) builds a small Alpine-based image

### Kubernetes manifests
| Folder | Purpose |
|--------|---------|
| `k8s/` | Beetroot `Deployment` and `Service` |
| `nginx-reverse-proxy/` | Nginx as a reverse proxy (Deployment, Service, ConfigMap) |
| `apache-reverse-proxy/` | Apache as a reverse proxy (Deployment, Service, ConfigMap) |
| `traefik-reverse-proxy/` | Traefik with `IngressRoute`, ConfigMap, Service, and full manifests bundle |

## Build & push the image

```bash
docker build -t <your-registry>/beetroot:latest .
docker push <your-registry>/beetroot:latest
```

Update the image reference in `k8s/beetroot-deployment.yaml` if needed.

## Deploy to Kubernetes

Deploy the app first:

```bash
kubectl apply -f k8s/
```

Then pick **one** of the reverse proxies:

```bash
# Option A — Nginx
kubectl apply -f nginx-reverse-proxy/

# Option B — Apache
kubectl apply -f apache-reverse-proxy/

# Option C — Traefik
kubectl apply -f traefik-reverse-proxy/
```

## Verify

```bash
kubectl get pods
kubectl get svc
```

Reach the app via the proxy's external IP / NodePort, depending on the manifests used.

## Cleanup

```bash
kubectl delete -f k8s/
kubectl delete -f nginx-reverse-proxy/   # or apache- / traefik-
```
