# GCP Artifact Images Uploader

<h4>What you gonna do when your GKE nodes doesn't have internet access and you need to pull images from GCP Artifact-Registry? </h4>

This script is for collecting docker images in helm-charts from artifact-hub and push them into GCP Artifact-Registry in a specified artifact.  
This script is not used as Oh-My-Zsh plugin becuase of the spinner annimation.  

## Preperation
1. Clone the repository and copy the script to ```/usr/local/bin```
```
git clone https://github.com/danielyaba/oh-my-zsh-plugins.git && cd oh-my-zsh-plugins
cd gcp_artifact_images_uploader
cp gcp_artifact_images_uploader /usr/local/bin
chmod +x gcp_artifact_images_uploader
```

## Creating an GCP Artifact-Registry
You can use the Terraform module located in artifact-registry directory
```
module "docker_artifact_registry" {
  source     = "./artifact-registry"
  project_id = "myproject"
  location   = "europe-west1"
  name       = "myregistry"
  iam = {
    "roles/artifactregistry.admin" = ["group:cicd@example.com"]
  }
}
```

## Usage
1. Define the following values in variables (let's use External-Secrets chart for example):
  * Helm-chart repository URL
  * Chart name
  * GCP Project-ID
  * GCP Artifact-Registry name
```
REPO_URL=https://charts.external-secrets.io
CHART_NAME=external-secrets
GCP_PROJECT_ID=myproject
GCP_ARTIFACT=myregistry
```

2. Execute the script:
```
gcp_artifact_images_uploader $REPO_URL $CHART_NAME $GCP_PROJECT_ID $GCP_ARTIFACT
```

#### Optional Arguments:
You can also specify a values file-path in order to specify only the images you want to download.  
for exmaple in External-Secrets chart there are 3 deployments: cert-controller, external-secrets and webhook.  
Let's say you want to upload just cert-controller and external-secrets images without the webhook docker image.  

1. Create a ```values.yaml``` with false value on the webhook value
```
webhook:
  create: false
```

2. Define the values path file in a variable:
```
VALUES=values.yaml
```

3. Execute the script:
```
gcp_artifact_images_uploader $REPO_URL $CHART_NAME $GCP_PROJECT_ID $GCP_ARTIFACT $VALUES
```
