#resource "null_resource" "simulate_workload" {
#  count = 60
#
#  provisioner "local-exec" {
#    command = "sleep 10"
#  }
#}

#output "simulation_complete" {
#  value = "Done simulating ${length(null_resource.simulate_workload)} resources!"
#}

resource "null_resource" "print_env" {
  provisioner "local-exec" {
    command = "env"
  }
}
