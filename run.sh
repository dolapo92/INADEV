## Automation script

export BUCKET_NAME=""
export BUCKET_KEY=""
export REGION="us-east-2"
export ENV="dev"
export AWS_ACCOUNT=""

##Provisioning cluster
cd provisioning/${ENV}/cluster/kc1
terraform init -backend-config="bucket=${BUCKET_NAME}" -backend-config="key=${BUCKET_KEY}/terraform.tfstate" -backend-config="region=${REGION}"
terraform plan
terraform apply -auto-approve
cd ../../../..

##Setting up Jenkins
kubectl apply -f jenkins/init/nfs.yml
## Getting the IP
POD_NAME=$(kubectl get pods -n jenkins -o custom-columns=POD:.metadata.name | grep nfs)
IP=$(kubectl get pod $POD_NAME -n jenkins -o jsonpath='{.status.podIP}')
sed -i 's/{IP_ADDRESS}/ '$IP'g' jenkins/base/volume.yaml

## creating service account, storage and volume
kubectl apply -k jenkins/overlay/dev/

## Using helm let's deploy jenkins
helm repo add jenkinsci https://charts.jenkins.io

## Updating the repo
helm repo update
## Installing jenkins
helm install jenkins -n jenkins -f jenkins/overlay/dev/values.yaml jenkinsci/jenkins

## jenkins is install.

## Lets create dockerconfig for accessing private access
kubectl create secret docker-registry regcred \
  --docker-server=${AWS_ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace=default

## Do create jenkins pipeline job and privude your scm url



