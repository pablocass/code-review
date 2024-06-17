output "kubeconfig" {
  value = module.aks.kube_config
}

output "sever_fqdn" {
  value = module.database.db_host
}