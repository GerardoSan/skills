## Enrique Sánchez | Cloud Architect | AIOps | Multi-Cloud

Bienvenido a mi portafolio técnico.

Este espacio reúne mi experiencia práctica en diseño, implementación y optimización de soluciones en la nube, integrando Cloud, Data e Inteligencia Artificial para resolver problemas reales de negocio.

Mi enfoque se centra en:

Arquitecturas resilientes, seguras y costo-eficientes,
Infraestructura como código con Terraform,
Automatización de operaciones (AIOps),
Data Engineering y pipelines de datos,
Integración de IA en procesos IT (RAG, agentes, clasificación de incidentes),
Gobierno cloud y optimización (FinOps + Well-Architected)

Este portafolio no es teórico: cada componente está pensado para ser reutilizable en entornos productivos.

## Estructura

Cada skill contiene:

- Objetivo
- Caso de uso
- Arquitectura
- Requisitos
- Implementación
- Buenas prácticas
- Riesgos
- Evidencias
- Próximas mejoras

## Skills destacadas

- Pipelines CI/CD con Workload Identity
- Cluster GKE con aplicación Python en Kubernetes

---

## Cluster GKE con Aplicación Python en Kubernetes

### Objetivo
Desplegar una infraestructura en Google Cloud Platform (GCP) con un cluster de Kubernetes que contiene 2 nodos, cada uno ejecutando un pod con una página web sencilla en Python.

### Caso de uso
Demostración de despliegue de aplicaciones web en Kubernetes con alta disponibilidad y balanceo de carga.

### Arquitectura
- **Infraestructura**: Terraform modular para GCP
- **Cluster**: Google Kubernetes Engine (GKE) con 2 nodos
- **Aplicación**: Flask (Python) con página web responsive
- **Contenerización**: Docker
- **Exposición**: LoadBalancer Service
- **Replicas**: 2 pods (1 por nodo)
- **Módulos Terraform**: 
  - `gke-cluster`: Configuración del cluster GKE
  - `node-pool`: Configuración de node pools con autoscaling

### Requisitos
- Cuenta de GCP con billing habilitado
- Google Cloud CLI instalado
- Terraform instalado
- Docker instalado
- kubectl instalado

### Implementación

#### Opción 1: GitHub Actions CI/CD (Recomendado)

1. **Configurar Workload Identity Federation**:
   ```bash
   cd terraform
   chmod +x setup-oidc.sh
   ./setup-oidc.sh [PROJECT_ID] [REPO_OWNER] [REPO_NAME]
   ```

2. **Configurar GitHub Secrets**:
   - `GCP_PROJECT_ID`: ID del proyecto GCP
   - `GCP_WORKLOAD_IDENTITY_PROVIDER`: ID del provider (output del script)
   - `GCP_SERVICE_ACCOUNT`: Email del service account
   - `STATE_ENCRYPTION_KEY`: ID de la clave KMS (opcional)

3. **Activar CI/CD**:
   - Hacer push a la rama `main` para desplegar automáticamente
   - Los PRs mostrarán el plan de Terraform
   - Las imágenes Docker se construirán y subirán automáticamente

#### Opción 2: Manual

1. **Configurar variables de Terraform**:
   ```bash
   cd terraform
   # Editar variables.tf con tu project_id
   ```

2. **Crear bucket para state**:
   ```bash
   gsutil mb gs://terraform-state-[PROJECT_ID]
   gsutil versioning set on gs://terraform-state-[PROJECT_ID]
   ```

3. **Desplegar infraestructura**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Construir y subir imagen Docker**:
   ```bash
   cd app
   docker build -t python-web-app .
   docker tag python-web-app gcr.io/[PROJECT_ID]/python-web-app:latest
   docker push gcr.io/[PROJECT_ID]/python-web-app:latest
   ```

5. **Configurar kubectl y desplegar aplicación**:
   ```bash
   gcloud container clusters get-credentials web-app-cluster --region us-central1
   cd ../k8s
   # Actualizar deployment con tu project_id
   sed -i 's/your-project-id/[PROJECT_ID]/g' deployment.yaml
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

6. **Obtener IP externa**:
   ```bash
   kubectl get service python-web-app-service --watch
   ```

### Buenas prácticas
- **Infraestructura**: Arquitectura modular con Terraform
- **CI/CD**: GitHub Actions con OIDC (sin secrets estáticos)
- **Seguridad**: Secure boot, integrity monitoring, sandboxing
- **State Management**: GCS bucket con versioning y encriptación KMS
- **Escalabilidad**: Autoscaling configurado para node pools
- **Recursos**: Límites de recursos para los pods
- **Monitoreo**: Health check endpoint incluido
- **Optimización**: Imágenes Docker optimizadas (slim Python)
- **Configuración**: Variables de entorno inyectadas desde Kubernetes
- **Separación**: Configuración modular por componente

### Riesgos
- Costos asociados a GCP resources
- Seguridad de credenciales de GCP
- Gestión de imágenes Docker en registry

### Evidencias
- Página web accesible vía LoadBalancer IP
- 2 pods corriendo en nodos diferentes
- Información de hostname y pod desplegada

