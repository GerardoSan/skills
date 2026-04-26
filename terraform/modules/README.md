# Módulos Terraform

Este directorio contiene los módulos reutilizables de Terraform para la infraestructura GKE.

## Estructura de Módulos

### gke-cluster/
Módulo para crear y configurar clusters de Google Kubernetes Engine.

**Características:**
- Configuración de red y políticas de seguridad
- Soporte para clusters privados
- Configuración de addons y balanceadores
- Encriptación de base de datos
- Exportación de métricas

**Variables principales:**
- `cluster_name`: Nombre del cluster
- `region`: Región de despliegue
- `enable_network_policy`: Habilitar políticas de red
- `enable_private_nodes`: Habilitar nodos privados

### node-pool/
Módulo para crear y configurar node pools en clusters GKE.

**Características:**
- Configuración de máquinas y almacenamiento
- Autoscaling automático
- Gestión de actualizaciones
- Seguridad (secure boot, integrity monitoring)
- Soporte para GPUs y aceleradores

**Variables principales:**
- `node_pool_name`: Nombre del node pool
- `node_count`: Número inicial de nodos
- `machine_type`: Tipo de máquina
- `min_node_count`/`max_node_count`: Límites de autoscaling

## Uso

Los módulos se consumen desde el archivo `main.tf` principal:

```hcl
module "gke_cluster" {
  source = "./modules/gke-cluster"
  
  cluster_name = var.cluster_name
  region       = var.region
  # ... otras variables
}

module "node_pool" {
  source = "./modules/node-pool"
  
  node_pool_name = var.node_pool_name
  region         = var.region
  cluster_name   = module.gke_cluster.name
  # ... otras variables
}
```

## Beneficios de la Arquitectura Modular

- **Reutilización**: Los módulos pueden ser usados en diferentes proyectos
- **Mantenimiento**: Cambios centralizados en un solo lugar
- **Testing**: Cada módulo puede ser probado independientemente
- **Escalabilidad**: Fácil adición de nuevas configuraciones
- **Legibilidad**: Código más organizado y comprensible
