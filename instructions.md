# Basic GCP Architecture with Terraform

## Scenario

The end goal is to deploy the sample application (located at the Cloud Source Repository *demo-app*) to the GKE cluster via a Cloud Build pipeline. The application lists the objects inside a Cloud Storage bucket every 30 seconds.

## Required tools

- gcloud CLI (for Terraform to authenticate with GCP with your credentials)
- Terraform
- kubectl (to interact with the Kubernetes cluster as well as for Terraform to authenticate with the kubeconfig file)

## Components

Except a few resources such as Terraform state bucket and Cloud Source Repositories, all components are meant to be deployed via Terraform.

### Cloud Source Repositories

Two Cloud Source Repositories should be created, one for the application (based on *demo-app*), and the other one is for the infrastructure (Terraform). Repositories should be created manually.

### Cloud Storage Buckets

Two GCS buckets are needed. Terraform state (backend) bucket should be created before initializing Terraform, and it should be created manually. The other bucket is for the application that will list the files inside this bucket and it should be created with Terraform. A [bucket object](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) (an uploaded file) should be created with Terraform. Both buckets can be Regional Standard.

### VPC

A [VPC](https://cloud.google.com/vpc/docs/vpc) with regional routing mode should be created for base networking layer. For VPC components, a [subnet](https://cloud.google.com/vpc/docs/subnets) (with private Google access enabled) and [firewall](https://cloud.google.com/vpc/docs/firewalls) rules (e.g. allow internal communication), as well as two [secondary ranges](https://cloud.google.com/vpc/docs/alias-ip) (for GKE pods and services) are required. [Network module](https://registry.terraform.io/modules/terraform-google-modules/network/google/latest) can be used for this part.

### Cloud NAT - Cloud Router

While it's not strictly required for this application, it's better to have [Cloud NAT](https://cloud.google.com/nat/docs/overview) as it allows resources without external IP addresses connect to the Internet. Cloud NAT requires [Cloud Router](https://cloud.google.com/network-connectivity/docs/router/concepts/overview) to manage its static routing to the Internet. 

### GKE

A **private**, **zonal** [GKE cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters) with a single e2-small node without node autoscaling should be deployed with [GKE Private Cluster Submodule](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/private-cluster).

- Nodes should be private, Masters should be public
- Registry access should be granted
- No need to create a new (GCP) service account, you can use the "default" one
- If e2-small node is not sufficient, try recreating the node group with an e2-medium node

### IAM

The "default" Kubernetes service account does not have enough permissions to list the objects inside a GCS bucket. You can use [GKE Workload Identity Submodule](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/workload-identity) to create a Kubernetes service account with specific roles inside a namespace, then you can use it in your Kubernetes manifests.

Cloud Build, by default, has no GKE authentication access. You can add *container.developer* role to the default Cloud Build service account (PROJECT-NUMBER@cloudbuild.gserviceaccount.com) via [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam). Only use **google_project_iam_member** resource to give the role to the service account, as the other resources mentioned in this link can be destructive.

### Cloud Build

[Cloud Build Trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger#example-usage---cloudbuild-trigger-filename) should be used to watch the application repository and start the pipeline steps on push to master branch. Use a simple filename trigger. All the build steps will be declared in that file.

### Sample Application

The application needs an environment variable called "BUCKET_NAME" pointed at the GCS bucket. There are two missing files, one is the Kubernetes deployment manifest, the other one is the Cloud Build manifest.

In Kubernetes deployment file, you should define an environment variable for the GCS bucket. Also, service account should be given for accessing the bucket.

In Cloud Build file, there should be *Docker build*, *Docker push* and *GKE deploy* steps. Environment variables can be used for templating. You can see the default environment variables [here](https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values). You can also use Cloud Build trigger to define environment variables dynamically, e.g. for "BUCKET_NAME", relevant Terraform GCS bucket block's output (google_storage_bucket.<resource_name>.name) can be given to Cloud Build trigger block as a substitution. 

## Notes

- Terraform, provider and module versions should be pinned down, e.g. if you use Terraform v1.1.0, then it should be explicitly set to that version in relevant Terraform block. That would prevent dependency conflicts.
- All resource names should be suffixed with your name, e.g. for a GCS bucket it may be "test-bucket-{YOUR-NAME}".
- Resources should be located at *us-east1*.
- Terraform state should be stored in a GCS bucket.
- Destroy the infrastructure if you are not going to use it for more than a few hours. Recreating the infrastructure would not take more than 10 minutes. Manually created resources (Terraform state bucket, Source Repositories) can stay as they don't cost much.