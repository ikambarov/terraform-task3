output "dns_record" {
  value = aws_route53_record.web.fqdn
}

output "rds_cluster_endpoint" {
  sensitive = true
  value     = module.cluster.cluster_endpoint
}

output "rds_database_name" {
  sensitive = true
  value     = module.cluster.cluster_database_name
}

output "rds_master_username" {
  sensitive = true
  value     = module.cluster.cluster_master_username
}

output "rds_master_password" {
  sensitive = true
  value     = module.cluster.cluster_master_password
}
