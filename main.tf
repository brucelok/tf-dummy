resource "null_resource" "simulate_workload" {
  count = 60

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

output "simulation_complete" {
  value = "Done simulating ${length(null_resource.simulate_workload)} resources!"
}
