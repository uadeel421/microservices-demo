mysql_server_name    = "rwdbserver"
mysql_server_version = "8.0.21"
mysql_sku_name       = "B_Standard_B1ms"  
mysql_username = "MYSQLUSER"
mysql_password = "MYSQLPASSWORD"



aks_cluster_name    = "kpk8s"
kubernetes_version  = "1.32.3"
default_node_pool_name = "default"
user_node_pool         =  "stagingpool"

vm_size                = "Standard_D2pls_v6"
os_sku                 = "AzureLinux"

# System Node Pool Autoscaling and Labels 

min_count              = 2
max_count              = 4
max_pods               = 50

# User Node Pool Autoscaling and Labels 

user_node_pool_labels = {
  workload-type = "staging-pool"
  environment   = "staging"
}
user_node_pool_min_count = 2
user_node_pool_max_count = 4




