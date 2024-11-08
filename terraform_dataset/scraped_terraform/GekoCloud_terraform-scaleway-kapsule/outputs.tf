output "scaleway_k8s_cluster_name" {
  value = scaleway_k8s_cluster.this.name
}

output "scaleway_k8s_cluster_id" {
  value = scaleway_k8s_cluster.this.id
}

output "scaleway_k8s_cluster_created_at" {
  value = scaleway_k8s_cluster.this.created_at
}

output "scaleway_k8s_cluster_updated_at" {
  value = scaleway_k8s_cluster.this.updated_at
}

output "scaleway_k8s_cluster_apiserver_url" {
  value = scaleway_k8s_cluster.this.apiserver_url
}

output "scaleway_k8s_cluster_wildcard_dns" {
  value = scaleway_k8s_cluster.this.wildcard_dns
}

output "scaleway_k8s_cluster_config_file" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].config_file
}

output "scaleway_k8s_cluster_host" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].host
}

output "scaleway_k8s_cluster_cluster_ca_certificate" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].cluster_ca_certificate
}

output "scaleway_k8s_cluster_token" {
  value = scaleway_k8s_cluster.this.kubeconfig[0].token
}

output "scaleway_k8s_cluster_status" {
  value = scaleway_k8s_cluster.this.status
}

output "scaleway_k8s_cluster_upgrade_available" {
  value = scaleway_k8s_cluster.this.upgrade_available
}
