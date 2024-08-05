# DevOpsTest-Flypass
Prueba de DevOps.
# Estructura del proyecto
`C:.
│   README.md
│
├───.github
│   └───workflows
│           buildDocker.yaml
│           deployDevelop.yaml
│           deployFeature.yaml
│           destory.yaml
│
├───DockerFiles
│   └───ip
│           Dockerfile
│           log_ip.sh
│
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
                variables.tf`
