
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster1"
        eks_subnet_ids = ["subnet-0bb7a202dd89cac8c","subnet-00260b7b47694aae0","subnet-08917e0601656a793","subnet-0a4c0cab61513bc57"]
        tags = {
             "Name" =  "demo-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-0bb7a202dd89cac8c","subnet-00260b7b47694aae0","subnet-08917e0601656a793","subnet-0a4c0cab61513bc57"]

        tags = {
             "Name" =  "node1"
         } 
  }
}