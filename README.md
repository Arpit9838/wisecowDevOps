# Wisecow App - Kubernetes Deployment with CI/CD

This project is part of the **Accuknox DevOps Trainee Practical Assessment**.  
The goal is to **containerize, deploy, secure, and automate** the Wisecow application.

---

## Problem Statement 1 – Containerisation & Deployment

- **Dockerization**:  
  A `Dockerfile` is included to build a container image for the Wisecow application.  

- **Kubernetes Deployment**:  
  Manifests are stored in the [`k8s/`](./k8s) directory:
  - `namespace.yaml`
  - `deployment.yaml`
  - `service.yaml`
  - `ingress.yaml`
  - `ingress-nginx-svc.yaml`
  - `cadvisor.yaml`
  - `kubearmor-policy.yaml` (optional, Zero-Trust security)

- **Ingress + TLS**:  
  The app is exposed via `https://wisecow.local` using a self-signed certificate (`wisecow.crt` + `wisecow.key`).  
  TLS secret must be created manually inside Kubernetes:  

  ```bash
  kubectl create secret tls wisecow-tls \
    --cert=wisecow.crt \
    --key=wisecow.key \
    -n wisecow


Problem Statement 2 – System Health Monitoring

A script scripts/system_health_check.sh monitors:

CPU usage

Memory usage

Disk usage

Running processes

⚠️ If CPU > 80%, it prints an alert.

Run inside Minikube:

minikube ssh
sh /home/docker/system_health_check.sh

📌 Problem Statement 3 – Zero-Trust (Optional)

A sample KubeArmor policy is included in k8s/kubearmor-policy.yaml.

Requires KubeArmor to be installed in the cluster:

helm repo add kubearmor https://kubearmor.github.io/charts
helm install kubearmor kubearmor/kubearmor -n kubearmor --create-namespace
kubectl apply -f k8s/kubearmor-policy.yaml -n wisecow