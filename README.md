# Node.js 3-Tier Application CI/CD Pipeline on AWS EKS

This repository demonstrates an **end-to-end CI/CD pipeline** for a 3-tier Node.js application deployed on **AWS EKS** using **eksctl**. The pipeline is built with **Jenkins** and integrates essential tools for code quality, security, containerization, access control, and monitoring. The application is exposed using **NGINX Ingress** with **HTTPS** enabled via **cert-manager** for a custom domain.

---

## 🚀 Features

✅ **CI/CD Automation**  
Automated build, test, and deployment processes using Jenkins pipelines triggered on code changes.

✅ **Code Quality & Security**  
- **SonarQube** for static code analysis and improving code quality  
- **Trivy** for scanning container images for vulnerabilities  
- **Gitleaks** for detecting hardcoded secrets and sensitive data in the repository

✅ **Containerization & Deployment**  
- Docker-based container builds  
- Kubernetes orchestration on AWS EKS  
- Zero-downtime rolling updates for seamless deployment

✅ **Secure Access Control**  
- RBAC implemented using Kubernetes service accounts to enforce least privilege access

✅ **Monitoring & Observability**  
- **Prometheus** for metrics collection  
- **Grafana** for real-time dashboards and alerts to monitor application health

✅ **Ingress & HTTPS Setup**  
- Exposed the application using **NGINX Ingress Controller**  
- Configured **cert-manager** to automatically provision and renew TLS certificates for a custom domain  
- Ensured secure communication via HTTPS for production-ready deployments

---

## 📦 Technologies Used

- **AWS EKS (eksctl)** – Kubernetes cluster provisioning  
- **Jenkins** – CI/CD automation server  
- **Docker** – Containerization platform  
- **SonarQube** – Code quality and analysis  
- **Trivy** – Vulnerability scanning  
- **Gitleaks** – Secret scanning  
- **Prometheus & Grafana** – Monitoring and observability  
- **NGINX Ingress Controller** – HTTP/HTTPS routing into the cluster  
- **cert-manager** – Automated TLS certificate management  
- **RBAC** – Role-based access control in Kubernetes
- **Helm** – Kubernetes package manager


