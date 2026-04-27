# Cluster GKE con Aplicación Python en Kubernetes

## Objetivo
Desplegar una infraestructura en Google Cloud Platform (GCP) con un cluster de Kubernetes que contiene 2 nodos, cada uno ejecutando un pod con una página web sencilla en Python.

## Caso de uso
Demostración de despliegue de aplicaciones web en Kubernetes con alta disponibilidad y balanceo de carga.

## Arquitectura
- **Infraestructura**: Terraform para GCP
- **Cluster**: Google Kubernetes Engine (GKE) con 2 nodos
- **Aplicación**: Flask (Python) con página web responsive
- **Contenerización**: Docker
- **Exposición**: LoadBalancer Service
- **Replicas**: 2 pods (1 por nodo)

## Requisitos
- Cuenta de GCP con billing habilitado
- Google Cloud CLI instalado
- Terraform instalado
- Docker instalado
- kubectl instalado

## Implementación

### 1. Configurar variables de Terraform
```bash
cd cloud/terraform
# Editar variables.tf con tu project_id
```

### 2. Desplegar infraestructura
```bash
terraform init
terraform plan
terraform apply
```

### 3. Construir y subir imagen Docker
```bash
cd ../app
docker build -t python-web-app .
docker tag python-web-app gcr.io/your-project-id/python-web-app:latest
docker push gcr.io/your-project-id/python-web-app:latest
```

### 4. Configurar kubectl y desplegar aplicación
```bash
gcloud container clusters get-credentials web-app-cluster --region us-central1
cd ../k8s
# Actualizar deployment con tu project_id
sed -i 's/your-project-id/tu-project-id/g' deployment.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 5. Obtener IP externa
```bash
kubectl get service python-web-app-service --watch
```

## Buenas prácticas
- Uso de límites de recursos para los pods
- Variables de entorno inyectadas desde Kubernetes
- Health check endpoint incluido
- Imágenes optimizadas (slim Python)
- Separación de configuración por entorno

## Riesgos
- Costos asociados a GCP resources
- Seguridad de credenciales de GCP
- Gestión de imágenes Docker en registry

## Evidencias
- Página web accesible vía LoadBalancer IP
- 2 pods corriendo en nodos diferentes
- Información de hostname y pod desplegada