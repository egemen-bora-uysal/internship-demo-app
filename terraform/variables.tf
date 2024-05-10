#Terraform Variables Declaration
variable "project_id" {
  type = string
}

variable "project_number" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "demo_name" {
  type = string
}

variable "region" {
  type = string
}

variable "subnet_ip_range" {
  type = string
}

variable "subnet_pod_ip_range" {
  type = string
}

variable "subnet_svc_ip_range" {
  type = string
}

variable "ip_range_pods" {
  type = string
}

variable "ip_range_services" {
  type = string
}

variable "zone" {
  type = string
}

variable "master_pod_ip_range" {
  type = string
}

variable "node_pool_name" {
  type = string
}

variable "tfstate_bucket" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "kubernetes_config" {
  type = string
}

variable "cloudbuild_config" {
  type = string
}

variable "app_name" {
  type = string
}
