resource "null_resource" "print_env" {
  provisioner "local-exec" {
    command = "env"
  }
}

resource "null_resource" "simulate_workload" {
  provisioner "local-exec" {
    command = "sleep 3600"
  }
}
