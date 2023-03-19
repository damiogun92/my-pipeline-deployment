# WEB APP DEPLOYMENT USING JENKINS PIPELINE
## Prerequisites;
####  Creating a key pair.In this case the key pair is named jenkins-server

## Step1:Creating a key pair
#### This can be done by going into the Ec2 instance and creating it.It is important that it comes with .pem extension.

## Step2: Create a Jenkins Server with all the dependencies, libraries and packagies needed.
### The following files were created:
#### Backend.tf: which is used to store the terraform state file in an s3 bucket.The s3 bucket was created from AWS.
#### jenkins-server.tf: This was created using a module.The image,image type,the resource,the instance type and other details about the machine is declared and all defined to create the server that the jenkins pipeline would use
#### jenkins-server-script.sh: This is used to install artifacts to that server and we are using the bash script for installation.There are several packages installed including terraform and kubernetes
#### outputs.tf : Used to declare the public ip of the instance created.
#### providers.tf : To declare the provider and availabilty zone.
#### Terraform.tfvars: To define the cidr block,machine type and prefix we want to use in our enviroment.
#### Vpc.tf : As we i am putting this server on a vpc. It includes the subnets,internet gateway,route table,security group which must include port 22 so i am able to ssh.port 8080 is also opened as it is default port for jenkins.
#### After this set up,we would run the following commands:

       cd server-jenkins
       terraform init
       terraform apply --auto-approve


#### The public ip of the instance would be displayed after terraform has succesfully run.

## Step3:  Once completed, access the Jenkins server and Set it up
#### once completed the publicipaddress:8080 would be pasted to the web and jenkins server is displayed.we then connect to the instance and I sudo cat the /var/lib/jenkins/secrets/initialpassword to display password needed to install jenkins.
#### once its setup i gave the details to set up admin user and i clicked on manage credentials to connect jenkins to aws account by providing my credentials and also github credentials,
## 4. Run the jenkins-pipeline-deploy-to-eks to create Kubernetes Cluster, create deployments and Services

### I created an eks cluster (an elastic kubernetes cluster) to be able to deploy manifest files.This was created by terraform files which includes:
#### provider.tf :To declare provider and availabity zones
#### vpc.tf: To create vpcs
#### igw.tf:To create internet gateway
#### nat.tf : To create nat gateway
#### routes.tf :To create route tables
#### eks.tf: To create eks cluster and attach the iam role policy.
#### nodes.tf: To create the node groups and attach 3 policies for the iam roles which have been declared in this file.
#### oidc.tf: To create the tls certificate for this cluser
#### terrafor tfvars and variables.tf: contains declared variables
#### The nginix controller folder contains files used to create nginix
#### The prometheus folder contains files used to create prometheus
#### The Jenkinsfile which gives directives to the jenkins server by giving it a name of what it would do,telling it to go to particular directory and perform a certain action as seen in below

       stage("Deploy sock-shop to EKS") {
            steps {
                script {
                    dir('sock-shop') {
                        sh "kubectl apply -f complete-deployment.yaml"
                    }
                }
            }
        } 


#### The jenkins file deployed my manifests file for both sock-app and myvote-app using kubernetes command by asking the shell to run kubectl apply -f (service and deployment file for both applications).I combined my service and deployment files in one file.
#### I created git repository and pushed all the files in there.
#### I then created a new pipeline on the jenkins server,pasted my github url in the url entry space in the jenkins server and built.so it deployed the web application.This is seen in the screenshot below
![Building-with-jenkins-pipeline](https://github.com/damiogun92/my-pipeline-deployment/blob/main/pipeline-for-exam/images/Screenshot%202023-03-19%20at%2012.19.39.png)
## Domain name creation
#### In my AWS it had created the loadbalancer,instance,eks cluster and other resources and on putting the url of my load balancer on the web,it displayed the applications.see image below:
#### I used route 53 to create domain names and used Acm to get my domain name encrypted.

## Domain names:sock-shop.damiogun.live and voting.damiogun.live

 