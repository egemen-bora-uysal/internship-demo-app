#Terraform variables
project_id = "project-id"
project_number = "number"

region = "region"
zone = "zone"

demo_name = "demo-app-borauysal"

tfstate_bucket = "tfstate-demoapp-borauysal"

branch_name = "master"
repo_name = "demo-app-borauysal"
app_name = "demo-app"

cluster_name = "gke-demo-cluster-borauysal"

node_pool_name = "node-pool-borauysal"

subnet_ip_range = "range/##" #16
subnet_pod_ip_range = "range/##" #16
subnet_svc_ip_range = "range/##" #16
master_pod_ip_range = "range/##" #28

ip_range_pods = "pod-secondary-range-borauysal"
ip_range_services = "svc-secondary-range-borauysal"

kubernetes_config = "deployment.yaml"
cloudbuild_config = "cloudbuild.yaml"