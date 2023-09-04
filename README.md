## EKS | Microservice

This Repo creates the EKS Cluster using terraform and deploy jenkins as CI/CD tool

#### Prerequisite
> Tools or Access required

1- AWS Account

2- Terraform 

3- kubectl

4- Helm

5- Python

#### Code Structure
```bash
|--app ## contains the Flask API
  |--templates ## Contains UI part
    |--index.html
  |--app.py ## Flask API
  |--Dockerfile ## Containerization
  |--requirements.txt ## py packages
  |--deploy ## k8s deployable manifest
|--jenkins ## Jenkins setup files
  |--init
    |--nfs.yaml ## k8s manifest file for nfs server and namespace
  |--base
    |--kustomization ## kustomize conf 
    |--storage ## manifest file for storage class
    |--volume ## manifest for PV and PVC
    |--sa ## Service Account manifest
  |--overlay
    |--dev ## Env
      |--kustomization.yaml ## kustomize conf
      |-- values ## Jenkinsci/jenkins helm chart paraemeters
|--modules ## contains the terraform module
  |--k8s-cluster
  |--k8s-nodegroup
|--provisioning
  |--dev
    |--cluster
      |--kc1 ## cluster alias

```

#### Terraform commands for provisioning
```hcl
cd provisioning/dev/cluster/kc1

terraform init -backend-config="bucket=<ENTER_YOUR_BUCKET_NAME>" -backend-config="key=<ENTER_YOUR_BUCKET_NAME>/terraform.tfstate" -backend-config="region=<ENTER_YOUR_AWS_REGION>"

terraform plan

terraform apply

```

#### Cluster Provisioning | Terraform module 

*Fields* | *Example Values* | *Description* | *Required* |
---| --- | --- | -- |
ENV | dev/prod | Type of Environment | yes |
PRODUCT_NAME | demo | Cluster prefix | yes
CLUSTER_ALAIAS | kc1 | K8s cluster alias | yes |
CLUSTER_VERSION | 1.25 | EKS Cluster Version | yes |
AWS_REGION | us-east-1 | AWS Region  | yes |
VPC_NAME | Default | AWS VPC NAME | yes |
SUBNETS_NAMES | ["Public-subnet-1", "Public-subnet-2", "Public-subnet-3"] | AWS Subnets name where to launch the EKS Cluster | yes |
PUBLIC_ENDPOINT_ACCESS | true/false | Enable Public endpoint access, Default is True | No |
PRIVATE_ENDPOINT_ACCESS | true/false | Enable Public endpoint access, Default is False | No |


### NodeGroup Provisioning | Terraform module

*Fields* | *Example Values* | *Description* | *Required* |
---| --- | --- | -- |
ENV | dev/prod | Type of Environment | yes |
PRODUCT_NAME | demo | Cluster prefix to which nodegroup need to be attached | yes
CLUSTER_ALAIAS | kc1 | K8s cluster alias | yes |
NODE_GROUP_NAME | infra | Worker node name | yes |
INSTANCE_TYPE | [t3.medium] | Type of Instances | yes |
AMI_TYPE | AL2_x86_64 | AMI Type| yes |
AWS_REGION | us-east-2 | AWS Region  | yes |
CAPACITY_TYPE | ON_Demand | Type of Instances required like RESERVED or ON DEMAND | yes |
DISK_SIZE | 30 | EBS Volume | yes|
DESIRED_INSTANCE | 1 | Desired number of instances | yes |
MAX_INSTANCE | 2 | Max number of instance in case of aut-scale | yes |
MIN_INSTANCE | 1 | Min number of instances | yes|
ENV | dev | Env type | yes |
SUBNETS_NAMES | ["Public-subnet-1", "Public-subnet-2", "Public-subnet-3"] | AWS Subnets name where to launch the work nodes | yes |
MANAGED_POLICY | arn:aws:iam:** | AWS managed policy needs to be attached to worker node | yes |
IAM_POLICY | [policy.json](./jenkins/base/volume.yaml) | yes |
labels | stack=infra | labeling the worker node | yes |

> Once provisioned successfully - aws eks update-kubeconfig --name <Cluster_Name> --region <AWS_REGION> --profile <AWSCLI_PROFILE_NAME>

--------------
#### Setting Up Jenkins 

> After successfully provisioning EKS Cluster, Lets setup jenkins

* Init Steps

> This step creates the namespace and NFS Server for storing the Jenkins data

```bash
kubectl apply -f jenkins/init/nfs.yml

## Getting the IP
POD_NAME=$(kubectl get pods -n jenkins -o custom-columns=POD:.metadata.name | grep nfs)
IP=$(kubectl get pod $POD_NAME -n jenkins -o jsonpath='{.status.podIP}')
```

* Creating Namespace, Volume and Service Account

> do update the NFS IP address to the [volume.yml](./jenkins/base/volume.yaml)

```bash
kubectl apply -k jenkins/overlay/dev/

```

* Using helm deploying jenkins

```bash
helm repo add jenkinsci https://charts.jenkins.io

## Updating the repo
helm repo update

## Installing jenkins
helm install jenkins -n jenkins -f jenkins/overlay/dev/values.yaml jenkinsci/jenkins

## For getting the Admin Password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo

## NOTES:
1. Get the Jenkins URL to visit by running these commands in the same shell:
  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        You can watch the status of by running 'kubectl get svc --namespace jenkins -w jenkins'
  export SERVICE_IP=$(kubectl get svc --namespace jenkins jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo http://$SERVICE_IP:8080

3. Login with the password from step 1 and the username: admin
4. Configure security realm and authorization strategy

```
----------------

#### Deploying Wheather forecast API

> After provisiong the Cluster and Jenkins for CI/CD, lets deploy the Weather Forecasting API

*NOTE -- We will be using flask as its for development purpose, for production purpose use gunicorn*

* Init Steps

> Before moving to deployment lets setup the secret. I have used openwheather api for the forecating.

creating secret for pulling image from private registry i.e,
```bash
kubectl create secret docker-registry regcred \
  --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=default

```
Openwhether API KEY is stored in jenkins credentials and manage via jenkins.

> if you wish to create Creating secret for storing openwheather api key

> ```kubectl create secret generic apikey --from-literal=api_key=${API_KEY}```

CI/CD is handled via [Jenkinsfile](app/jenkinsfile)

#### All Together
[run.sh](run.sh)



#### Author
Adedolapo (Dola) Diko



