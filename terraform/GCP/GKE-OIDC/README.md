# Cluster GKE con Aplicación Python en Kubernetes - CI/CD con OIDC

## Objetivo
Desplegar una infraestructura completa en Google Cloud Platform (GCP) con un cluster de Kubernetes que ejecuta una aplicación web Python, utilizando GitHub Actions con autenticación OIDC para CI/CD automatizado.

## Caso de uso
Demostración de infraestructura como código con despliegue automatizado, mostrando mejores prácticas de DevOps en la nube.

## Arquitectura
- **Infraestructura**: Terraform modular para GCP
- **Cluster**: Google Kubernetes Engine (GKE) con 1 nodo (escalable)
- **Aplicación**: Flask (Python) con información del pod y health check
- **Contenerización**: Docker con imagen optimizada
- **Registry**: Google Artifact Registry (reemplazo de GCR)
- **CI/CD**: GitHub Actions con Workload Identity Federation (OIDC)
- **Exposición**: LoadBalancer Service
- **State Management**: Terraform state en Google Cloud Storage

## Componentes del Proyecto

### Estructura de Directorios
```
terraform/GCP/GKE-OIDC/
├── terraform/
│   ├── main.tf              # Configuración principal de GKE
│   ├── variables.tf         # Variables de entrada
│   ├── outputs.tf          # Salidas del despliegue
├── app/
│   ├── app.py             # Aplicación Flask
│   ├── requirements.txt     # Dependencias Python
│   └── Dockerfile         # Definición de imagen
├── k8s/
│   ├── deployment.yaml     # Deployment de Kubernetes
│   └── service.yaml       # Service LoadBalancer
├── .github/
│   └── workflows/
│       └── terraform.yml   # CI/CD de infraestructura
```

### Infraestructura Terraform
- **Cluster GKE**: Con networking policies y addons configurados
- **Node Pool**: Máquinas e2-medium con disco estándar
- **Security**: Workload Identity Federation sin secrets estáticos
- **State Management**: Backend en GCS con versionamiento

### Aplicación Python
- **Framework**: Flask con endpoints `/` y `/health` 
- **Información**: Muestra hostname, pod name y node name
- **Health Check**: Endpoint `/health` para monitoreo
- **Recursos**: Límites de CPU y memoria definidos

### CI/CD Pipeline
- **Trigger**: Push a rama main
- **Autenticación**: OIDC con Workload Identity Federation
- **Steps**: Terraform → Docker → Kubernetes Deploy
- **Registry**: Google Artifact Registry
- **Secrets Management**: Sin credenciales estáticas

## Implementación

### Opción 1: GitHub Actions CI/CD (Recomendado)

#### Paso 1: Configurar Workload Identity Federation

**Crear el pool:**
```bash
gcloud iam workload-identity-pools create github-gcp \
  --project=$PROJECT_ID \
  --location=global \
  --display-name="GitHub Pool"
```

**Crear el provider:**
```bash
gcloud iam workload-identity-pools providers create-oidc github \
  --project=$PROJECT_ID \
  --location=global \
  --workload-identity-pool=github-gcp \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository"
```

**Verificación:**
Consola GCP → Workload Identity Pool creado

**Paso 2: Vincular GitHub con Service Account**
```bash
gcloud iam service-accounts add-iam-policy-binding \
"github@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-gcp/attribute.repository/GerardoSan/skills"
```

#### Prerrequisitos
1. **Workload Identity Federation**: Configurado con los comandos anteriores
2. **GitHub Secrets**:
   - `GCP_PROJECT_ID`: Tu ID de proyecto GCP
   - `GCP_WORKLOAD_IDENTITY_PROVIDER`: ID del provider (output del script)
   - `GCP_SERVICE_ACCOUNT`: Email del service account
3. **Activar Workflow**:
   - Hacer push a la rama main
   - O ejecutar manualmente desde GitHub Actions

#### Flujo Automático
1. **Terraform Apply**: Crea/actualiza infraestructura
2. **Docker Build**: Construye y sube imagen a Artifact Registry
3. **Kubernetes Deploy**: Despliega aplicación con la nueva imagen
4. **Health Check**: Verifica que los pods estén funcionando

## Seguridad

### Workload Identity Federation
- **Sin secrets estáticos**: Autenticación temporal con tokens OIDC
- **Principio de mínimo privilegio**: Service account con permisos específicos
- **Rotación automática**: Tokens de corta duración

## Costos Estimados

### Recursos Mensuales (us-central1)
- **GKE Cluster**: ~$10 (management fee)
- **Nodo e2-medium**: ~$15 (1 nodo x 730 horas)
- **LoadBalancer**: ~$18 (1 LB x 730 horas)
- **Artifact Registry**: ~$5 (storage + egress)
- **GCS Storage**: ~$1 (Terraform state)

**Total estimado**: ~$49/mes

## Referencias y Documentación

### Enlaces Útiles
- [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine)
- [Artifact Registry](https://cloud.google.com/artifact-registry)
- [GitHub Actions OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers)
- [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)

### Mejores Prácticas
- **Infrastructure as Code**: Todo versionado en Git
- **CI/CD Pipeline**: Despliegues automatizados y consistentes
- **Security First**: OIDC, principios de mínimo privilegio
- **Observability**: Logs, métricas y alertas
- **Cost Optimization**: Recursos apropiados y escalado automático

## Resultados Esperados

<img width="886" height="300" alt="image" src="https://github.com/user-attachments/assets/665fcb5c-93ad-4216-950e-6d6efc798b4f" />


### Evidencias de Funcionamiento
- **Aplicación accesible**: LoadBalancer IP responde con página web
- **Información del pod**: Muestra hostname, pod name y node name
- **Health check**: Endpoint `/health` responde correctamente
- **Alta disponibilidad**: LoadBalancer distribuye tráfico
- **CI/CD funcional**: Pipeline automatizado funciona
- **Seguridad implementada**: OIDC sin secrets estáticos

---

**Proyecto implementado exitosamente con infraestructura moderna, seguridad avanzada y automatización completa.** 
