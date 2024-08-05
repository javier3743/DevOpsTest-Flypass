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

**______________________________________________________________________________________________________________________________________________________**

## Nota
Agradezco mucho el esfuerzo que se invierte en estos procesos de reclutamiento. Lamentablemente, mi trabajo no quedó al 100% debido a situaciones externas. El principal punto de mejora de este proyecto es que los nodos nunca se conectan al clúster. Esto se debe a que los grupos de seguridad que intenté asignar para manejar los flujos de datos entre nodos y la consola de Kubernetes no se configuraron correctamente. Siempre terminaban con uno por defecto que no se comunicaba con nadie más. Debido a esto, el proceso se alargó demasiado y no se logró cumplir con el 100% del trabajo en el límite de tiempo. Agradecería cualquier feedback que se pueda brindar.
