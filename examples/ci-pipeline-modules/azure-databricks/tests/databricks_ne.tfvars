environment = "ci"
application = "testbrick"
location    = "northeurope"

sku = "standard"
spark_version = "7.1.x-scala2.12"
node_type_id = "Standard_DS3_v2"
autotermination_minutes = 120
autoscale = {
    autoscale_min_workers = 1
    autoscale_max_workers = 2
}