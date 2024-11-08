output "ssh_control_plane" {
  description = "Command to SSH into the Control Plane using its Public IP"
  value       = "ssh -i ${local.ssh_key_file_location} ubuntu@${module.control_plane.public_ip}"
}

output "ssh_worker_node" {
  description = "Command to SSH into the Worker Node using its Public IP"
  value       = "ssh -i ${local.ssh_key_file_location} ubuntu@${module.worker_node.public_ip}"
}

output "cloudinit_config_controlPlane" {
  description = "Cloud-init config for the Control Plane"
  value       = data.cloudinit_config.controlPlane.rendered
}

output "cloudinit_config_workerNode" {
  description = "Cloud-init config for the Worker Node"
  value       = data.cloudinit_config.workerNode.rendered
}
