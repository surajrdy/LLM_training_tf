output "cluster_endpoint" {
  value = "${aws_eks_cluster.uat.endpoint}"
}

output "certificate_authority" {
    value = "${aws_eks_cluster.uat.certificate_authority.0.data}" 
}

/*
output "token" {
    value = "${data.aws_eks_cluster_auth.demo.token}"
} 
*/

output "kubeconfig" {
  value = "${local.kubeconfig}"
}


//get eks kubeconfig file 
/*
output "kubeconfig" {
    value = "${aws_eks_cluster.demo.kubeconfig}"
}
*/

// get eks token file 
