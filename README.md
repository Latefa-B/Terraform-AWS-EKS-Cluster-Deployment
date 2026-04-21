# Step-by-step Guide to Deploying a Kubernetes Cluster (EKS) on AWS with Terraform
Kubernetes is an open-source platform for automating deployment, scaling, and management of containerized applications. It introduces the Pod as the smallest deployable unit. The Pod encapsulates one or more containers that share the same network, namespace and can access shared storage volumes. This abstraction allows Kubernetes to manage groups of tightly coupled containers as a single logical unit, simplifying communication and coordination. Kubernetes as an orchestration tool for containers, allows them to run reliably, scale up and down, and communicate with each other across many servers, making sure the application is always running and has enough resources.

Previously, we demonstrated how to deploy applications using Minikube and Kubernetes core concepts like : Pods, Deployments, Services, Persistent Storage, ConfigMaps, Secrets, and StatefulSets. Minikube is excellent for local development and learning, but in the real world, you need a highly available and scalable Kubernetes cluster.

To address this, Amazon Elastic Kubernetes Service (EKS) comes in as a solution. EKS is a fully managed Kubernetes service that makes it easy to run Kubernetes on AWS. AWS takes care of the Kubernetes control plane (the brains of the cluster), so you only need to worry about your worker nodes or use Fargate.

This comprehensive step-by-step guide walks you through the process of deploying a Kubernetes Cluster (EKS) on AWS with Terraform. In this project, we will use Terraform to provision an EKS cluster on AWS. This is a significant step, as it combines your knowledge of Infrastructure as Code with Kubernetes. You'll learn how to define an EKS cluster, its networking, and its worker nodes using Terraform code, and then connect your local kubectl to this cloud cluster. The aim of this project is to learn :  

- What AWS EKS is and its benefits.
- How to use Terraform to define and provision an EKS cluster.
- How to configure networking (VPC, subnets, security groups) for EKS.
- How to provision worker nodes (EC2 instances) for your EKS cluster.
- How to connect your local kubectl to your remote EKS cluster.
- The importance of IAM roles and policies for EKS.

## Prerequisites
- Have understood core Kubernetes concepts.
- Set up an AWS Account : With sufficient permissions to create VPCs, EC2 instances, IAM roles, and EKS clusters. 
- Have Terraform, kubectl and AWS CLI  Installed and AWS account credentials configured.
- Have aws-iam-authenticator Installed: This is a tool that allows kubectl to authenticate to EKS using AWS IAM credentials.
<img width="615" height="260" alt="0" src="https://github.com/user-attachments/assets/616c1bed-c448-47b7-9008-3da49ba6213a" />

## Step-by-step instructions :
### Step 1: Create Your Terraform Configuration for EKS
In this project, we will Deploy a Kubernetes Cluster (EKS) on AWS with Terraform. This involves several components: the EKS cluster itself, the IAM roles and policies it needs to operate, the networking (VPC, subnets, internet gateway, route tables), and the worker nodes where your applications will run. We'll put these into several .tf files for better organization. To complete Step 1 follow the instructions below : 
- Create a new folder on your computer named eks-cluster-terraform.
- Inside eks-cluster-terraform, create the following files: main.tf variables.tf outputs.tf vpc.tf eks-cluster.tf eks-nodes.tf iam.tf 
- Open each file and paste the corresponding content below.
<img width="1089" height="587" alt="1" src="https://github.com/user-attachments/assets/1d1b4340-8d43-45db-8385-70da84c2afad" />
<img width="788" height="771" alt="2" src="https://github.com/user-attachments/assets/d4fb15a2-5f50-4a6e-a9d0-36ec27a51517" />
<img width="613" height="466" alt="3" src="https://github.com/user-attachments/assets/49464a23-2033-4e4d-a40a-e408d2903729" />
<img width="802" height="822" alt="4" src="https://github.com/user-attachments/assets/6b54b99b-2c87-4f62-b5aa-7d2dbc1aaabc" />
<img width="835" height="374" alt="5" src="https://github.com/user-attachments/assets/8b0baac6-66b2-47f7-94a2-de55f00351e8" />
<img width="853" height="802" alt="6" src="https://github.com/user-attachments/assets/618c3d78-0973-4155-bbed-b634fb404312" />
<img width="847" height="198" alt="7" src="https://github.com/user-attachments/assets/518dcc17-9fdf-4c8e-b1f1-01f2147ccae1" />
<img width="715" height="357" alt="8" src="https://github.com/user-attachments/assets/86adc5f5-1752-419c-959c-2bb589def396" />
<img width="687" height="862" alt="9" src="https://github.com/user-attachments/assets/70921c4d-7bc2-45d4-a3bf-dbed8b34762d" />
<img width="903" height="867" alt="10" src="https://github.com/user-attachments/assets/364a4cf8-5f68-41f7-9995-624a56c4ecee" />
<img width="715" height="346" alt="11" src="https://github.com/user-attachments/assets/ad50b345-82ea-462c-8e90-d4f4b38c5da1" />

- Save all files. Your eks-cluster-terraform folder structure should look like this:
<img width="473" height="180" alt="12" src="https://github.com/user-attachments/assets/91df8ea1-855d-46f0-9e73-7bec69aaa77e" />


### Step 2: Initialize and Apply Terraform Configuration
Now that all your Terraform files are ready, you'll initialize Terraform to download providers and then apply the configuration to create the EKS cluster and its worker nodes in your AWS account. To complete Step 2 follow the instructions below : 
- Open your command line or terminal and navigate to your eks-cluster-terraform folder
- Initialize Terraform using the command : terraform init. 
**Expected output** : You should see messages indicating providers are being downloaded.
<img width="609" height="407" alt="13" src="https://github.com/user-attachments/assets/cbf368d5-fc6e-4602-a104-30a3957d65bc" />

- Plan your infrastructure changes using the command : terraform plan. Review the plan carefully. 
**Expected output** : You will see many resources (VPC, subnets, security groups, IAM roles, EKS cluster, EC2 instances, Auto Scaling Group) being added.
<img width="981" height="876" alt="14" src="https://github.com/user-attachments/assets/ddc5bfc5-08e4-40a4-9efd-04b6a0e348eb" />
<img width="627" height="839" alt="15" src="https://github.com/user-attachments/assets/6d9d8aba-44c6-4b56-89cb-40a1b759f6fa" />
<img width="562" height="872" alt="16" src="https://github.com/user-attachments/assets/694caf9c-b94e-4288-92ce-a74cad3e406a" />
<img width="695" height="878" alt="17" src="https://github.com/user-attachments/assets/4a7f4cad-9456-4d0d-9be7-452819a76b63" />
<img width="747" height="869" alt="18" src="https://github.com/user-attachments/assets/5cd2ea60-c3a1-4160-86f9-4b5b0d23d729" />
<img width="681" height="829" alt="19" src="https://github.com/user-attachments/assets/62f9248e-c939-434e-a10e-25a146e083ce" />
<img width="622" height="872" alt="20" src="https://github.com/user-attachments/assets/e121a9f5-f766-42c9-bca2-c910fa0048ab" />
<img width="599" height="872" alt="21" src="https://github.com/user-attachments/assets/ef01e39f-c994-44bd-872f-265bad528ec7" />
<img width="642" height="815" alt="22" src="https://github.com/user-attachments/assets/2435fd04-873f-4ee8-9d42-eac8fe79fc21" />
<img width="1112" height="587" alt="23" src="https://github.com/user-attachments/assets/f9db7a49-8100-45b6-b99c-18dce16edb43" />






















Apply your infrastructure changes using the command: terraform apply. Type yes to confirm when prompted.

Expected output : Be patient! Creating an EKS cluster is a complex process and takes a considerable amount of time. Terraform will provide progress updates.













Check your infrastructure on the AWS Console. The VPC my-k8s-cluster-vpc was created as well as its components : 

VPC





EC2  Instances : EKS worker nodes in a running state.


EKS Cluster : my-k8s-cluster


Security groups for the EKS cluster and worker nodes. 


Step 3: Configure kubectl to Connect to Your EKS Cluster
Once Terraform successfully creates the EKS cluster, your local kubectl tool doesn't automatically know how to connect to it. You need to configure your kubeconfig file, which tells kubectl about your clusters and how to authenticate them. The aws eks update-kubeconfig command simplifies this. To complete Step 3 follow the instructions below : 

After the terraform apply completes, run the following command to update your kubeconfig file. Replace my-k8s-cluster with your actual cluster_name if you changed it in variables.tf : aws eks update-kubeconfig --name my-k8s-cluster --region us-east-1
​Here is a breakdown of the command : 
aws eks update-kubeconfig: This AWS CLI command fetches the necessary cluster information and authentication details.
-name my-k8s-cluster: Specifies the name of your EKS cluster.
-region us-east-1: Specifies the AWS region where your cluster is located.

Expected output : You should see output indicating that your kubeconfig has been updated.

Verify kubectl connection to EKS using the commands : 
       kubectl get svc 
       kubectl get nodes
​
Expected output : kubectl get svc should show default Kubernetes services. kubectl get nodes should show your worker nodes (e.g., ip-10-0-1-XXX.ec2.internal, ip-10-0-2-YYY.ec2.internal) in a Ready state. This might take a few more minutes after the terraform apply finishes for the nodes to fully join the cluster. If they are not Ready immediately, wait a few minutes and try again.



Error : No resources found in the my-k8s-cluster. This means the worker nodes did not join the cluster !

Troubleshooting steps : 

Step 1 : Verify you are in the correct cluster using the command : kubectl config current-context

Step 2 : Check the EKS nodes in your cluster using the command : aws ec2 describe-instances--filters "Name=tag:eks:cluster-name,Values=<your-cluster-name>" "Name=instance-state-name,Values=running" --region <your-region>



Explanation : Your worker nodes should appear, in a running state. The output of the command shows that no worker node is part of the cluster. The instances are launched and running on the AWS cluster, however they are not part of the EKS cluster.

Step 3 : Check the IAM role permissions for the worker nodes
In order to allow nodes to join the cluster, we need to attach those policies to an IAM Role. The role will be assigned to the EC2 instances. 

Check the iam.tf terraform configuration file : The policies below have been properly defined in the terraform iam.tf configuration file, however the nodes are still not able to join the cluster. 

AmazonEKSClusterPolicy : This policy provides Kubernetes the permissions it requires to manage resources on your behalf.
AmazonEKSWorkerNodePolicy : This policy grants worker nodes the permissions they need to interact with the Amazon EKS service.
AmazonEKSVPCResourceController : is a required policy used by VPC Resource Controller to manage ENI and IPs for worker nodes.
AmazonEC2ContainerRegistryReadOnly : This policy allows the worker nodes to pull container images from the Amazon Elastic Container Registry (ECR).
EKS_node_role : is an IAM Role for the EKS Worker Nodes. This role grants permissions for worker nodes to join the EKS cluster and interact with AWS services.

Check if the IAM Role has been attached to the worker nodes on the AWS Console : The worker nodes have been properly launched and The IAM role and policies have been correctly defined in the terraform. However, the IAM role was not attached to any of the worker nodes and this might be the reason why they have not been able to join the EKS cluster !


Worker node 1 : 


Worker node 2 : 


Explanation : EC2 instances don’t take IAM roles directly. We need to create an aws_iam_instance_profile, which wraps the IAM role, then we tell the Launch Template to use that instance profile. At this point, your kubernetes cluster will have a control plane and worker nodes running. However, the worker nodes will not be able to join the kubernetes cluster without a required kubernetes configuration : the aws-auth ConfigMap. The EKS service does not provide a cluster-level API parameter or resource to automatically configure the underlying Kubernetes cluster to allow worker nodes to join the cluster via AWS IAM role authentication. 

Solution : Update your iam.tf terraform file to create aws_iam_instance_profile and create a new configuration terraform file aws-auth ConfigMap.
The aws_iam_instance_profile will attach the IAM Role to the EC2 Instances.
The  aws-auth ConfigMap will enable the worker nodes to join the cluster.
Step 4 : Update your iam.tf terraform file to create aws_iam_instance_profile.

Open your iam.tf terraform configuration file where all your policies and IAM role are defined and add the code below. The IAM instance profile will give the EC2 instances the permission to talk to EKS.

# IAM Instance Profile for Worker Nodes
resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "${var.cluster_name}-worker-profile"
  role = aws_iam_role.eks_node_role.name
}

Step 5 : Create an aws-auth ConfigMap.
Create a new terraform configuration file eks-aws-auth.tf and add the code below :

# Map the worker node IAM role to Kubernetes nodes
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.eks_node_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }
  depends_on = [
    aws_eks_cluster.eks_cluster,
  ]
}
Save your eks-aws-auth.tf file then create a new yaml file aws-auth.yaml and add the code below : 
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::694862618269:role/my-k8s-cluster-node-role
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
The aws-auth ConfigMap in the cluster tells EKS to trust the IAM role as a Kubernetes node.
Run the commands terraform init and terraform apply in your terminal to update the infrastructure. 







Check the AWS Console : The IAM Role was successfully attached to both EC2 instances 




On your terminal, check again the current context and switch to my-cluster-k8s context if it is a different one !
Run the command : kubectl get nodes to check the status of the worker nodes in your cluster !



Congratulations! Your local kubectl is now connected to a real Kubernetes cluster running in AWS !


Step 4: Deploy a Simple Application to EKS
Now that you have a working EKS cluster, let's deploy a simple application to it, just like you did with Minikube. We'll use our Nginx Deployment and a LoadBalancer Service to expose it to the internet. To complete Step 4 follow the instructions below : 

Go to your kubernetes-labs folder.
Create a new file named nginx-eks-deployment-service.yaml.
Open nginx-eks-deployment-service.yaml and paste the following content.
Save nginx-eks-deployment-service.yaml. 


Deploy the application to EKS using the command : kubectl apply -f nginx-eks-deployment-service.yaml
​
Expected output : You should see output indicating that the Deployment and Service are created.

Monitor the LoadBalancer Service using the command : kubectl get service eks-nginx-service -w. 

Expected output : The EXTERNAL-IP column will initially show <pending>. Wait several minutes (5-10 minutes) for AWS to provision the Load Balancer and for it to become ready. Eventually, you will see a public DNS name (e.g., a1234567890abcdef.us-east-1.elb.amazonaws.com) appear in the EXTERNAL-IP column.



Access your application in the cloud: Once the EXTERNAL-IP (DNS name) appears, copy it. Open your web browser and paste the DNS name (e.g., http://a1234567890abcdef.us-east-1.elb.amazonaws.com).

Expected output : You should see the default Nginx welcome page, served by your application running in your AWS EKS cluster!





Step 5 :  Clean Up (Extremely Crucial!)
Running an EKS cluster incurs costs (even the control plane has an hourly charge, plus the EC2 worker nodes, load balancers, etc.). It is absolutely critical to destroy all resources created in this lab when you are finished to avoid significant ongoing charges. Terraform makes this easy. To complete Step 5 follow the instructions below : 

Delete the application from EKS using the command : kubectl delete -f nginx-eks-deployment-service.yaml. 

Expected output : This will delete the Deployment, Pods, and the LoadBalancer Service, which in turn will de-provision the AWS Load Balancer. 




Verify application resources are gone using the command : kubectl get all -l app=eks-nginx-app. 

Expected output : Should show "No resources found..."



Destroy the EKS cluster and all associated AWS infrastructure using Terraform. Ensure you are in the correct directory using the command : cd eks-cluster-terraform and run terraform destroy. Type yes to confirm when prompted.

Expected output : Be patient! Destroying an EKS cluster and its related resources also takes a considerable amount of time (15-25 minutes or more). Terraform will provide progress updates. Wait for "Destroy complete!" message. This ensures you don't leave resources running and incur costs.



























Check all your infrastructure is gone on the AWS Console : EKS Cluster, worker nodes.


EKS Cluster



Worker nodes



Summary 
This breakdown provides a step-by-step guide to deploy a Kubernetes Cluster (EKS) on AWS with Terraform. By completing this lab, we had an overview on how : 

How to use Terraform to define and provision an EKS cluster.
How to configure networking (VPC, subnets, security groups) for EKS.
How to provision worker nodes (EC2 instances) for your EKS cluster.
How to connect your local kubectl to your remote EKS cluster.
The importance of IAM roles and policies for EKS.
By deploying the application in this lab, we demonstrated how ConfigMaps provide a way to manage non-sensitive settings such as environment variables or configuration files, while Secrets offer secure storage for sensitive information like passwords, tokens, and certificates. By leveraging these resources, applications become more flexible, secure, and portable across multiple environments.
By deploying and managing an EKS cluster on AWS using Terraform, we demonstrated the power of Infrastructure as Code for Kubernetes orchestration. We learned how Terraform automates the creation of all required AWS components, ensuring consistency and repeatability across environments. Overall, this lab highlights how EKS simplifies Kubernetes operations while Terraform enhances automation and scalability which is an essential combination for modern DevOps workflows in cloud-native environments.
