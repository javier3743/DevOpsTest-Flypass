# DevOpsTest-Flypass
Prueba de DevOps para la empresa FlyPass

## Requisitos para local
- Cuenta en AWS
- Terraform
- Docker
- Kubectl

## Funcionamiento
Este proyecto incluye la configuración y despliegue de dos contenedores Docker en un clúster de `Amazon EKS`, utilizando `Terraform` para la infraestructura, `Kubernetes` para el despliegue de los contenedores y `GitHub Actions` para automatizar todo el flujo del trabajo.


# Estructura del proyecto

## WorkFlows
```
├───.github
│   └───workflows
│           buildDocker.yaml
│           deployDevelop.yaml
│           deployFeature.yaml
│           destory.yaml
```
En esta carpeta se alojan los workflows de GitHub Actions, que habilitan el repositorio para desplegar y mantener al día nuestra infraestructura.

## Dockerfiles
```
│
├───DockerFiles
│   └───ip
│           Dockerfile
│           log_ip.sh
│   └───s3
│           Dockerfile
│           log_ip.sh
```
En esta carpeta se alojan los `DockerFiles`, que se construyen cuando se realiza algún cambio y se suben al repositorio de ECR (`buildDocker.yaml`).

## IaaC
En esta carpeta se aloja el código de nuestra infraestructura, que está separado en módulos para su manejo más fácil. Cuando se realiza algún cambio (feature), este se valida con Actions.
```
└───Terraform
    │   backend.tf
    │   main.tf
    │   output.tf
    │   provider.tf
    │   terraform.tfvars
    │   variables.tf
    │
    └───modules
        ├───ecr
        │       main.tf
        │       output.tf
        │       variables.tf
        │
        ├───eks
        │       data.tf
        │       main.tf
        │       output.tf
        │       variables.tf
        │
        ├───iam
        │       main.tf
        │       output.tf
        │       variables.tf
        │
        ├───kubernetes
        │       main.tf
        │       output.tf
        │       variables.tf
        │
        ├───s3
        │       main.tf
        │       output.tf
        │       variables.tf
        │
        └───vpc
                data_sources.tf
                main.tf
                output.tf
                variables.tf
```
## Concideraciones
- El `state.tf` se almacena en un bucket de S3 y se controla su estado con una entrada en `DynamoDB`.
- Nuestra estrategia para manejar las ramas, se basa en tener una rama `develop` que esta protegida y una rama `feature` donde trabajaremos. Para poder utilizar la una entrega a esta rama debemos de realizar un pull request, el cual debe de ser aprovado por una persona y el workflow de `feature` debe de haber completado exitosamente.
- Los datos sensibles se manejaron dentro del repositorio utilizando los secretos de GitHub.
**______________________________________________________________________________________________________________________________________________________**

## Nota
Agradezco mucho el esfuerzo que se invierte en estos procesos de reclutamiento. Lamentablemente, mi trabajo no quedó al 100% debido a dificultades que se presentaron. El principal punto de mejora de este proyecto es que los nodos nunca se conectan al clúster. Esto se debe a que los grupos de seguridad que intenté asignar para manejar el direccionamiento de la comunicación entre nodos y la consola de Kubernetes no se configuraron correctamente. Siempre terminaba con un grupo de seguridad por defecto que no se comunicaba con nadie más. Esto hubiera podido ser solventado fácilmente con el uso del módulo de EKS de Terraform, el cual tiene una opción para asignarle un grupo de seguridad a cada nodo. [Link docu aws](https://docs.aws.amazon.com/es_es/eks/latest/userguide/sec-group-reqs.html) [Link issue similar](https://github.com/hashicorp/terraform-provider-aws/issues/11458)

El proceso terminó alargándose demasiado y no se logró cumplir con el 100% del trabajo en el límite de tiempo. Con seguridad hay una manera de realizarlo además de la que propuse, pero no alcancé a encontrarla.

Agradecería cualquier feedback que se pueda brindar.
