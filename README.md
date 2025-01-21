# Infrastructure-Automation-Deploying-An-EC2-Jenkins-Server-With-Terraform
" The power of Terraform"

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/e12c6764f3ecb74f7e90cb4c481ab55bbcd430b2/images/Screenshot%202025-01-21%20104642.png)

# Introduction

Today, I'm going to show you how we can use Terraform for infrastructure automation to install a Jenkins Server on AWS, as well as other resources, but first, I'm going to teach Terraform principles in an uncommon approach.

Assume you're building a house with LEGO blocks. Instead of building it one brick at a time, you have a magical wand that allows you to construct the entire house with a single wave, and you can also use the same wand to demolish it with another wave.

Now say you want to build the same house in a different city. Instead of having to rebuild the entire house from start, you can just use your powerful wand tool to reproduce it in the new place.

Terraform is similar to that magical wand, but instead of building houses with LEGO bricks, it creates full cloud infrastructures for your apps using code. It enables you to define your whole infrastructure as code, allowing you to simply duplicate and manage your infrastructure across different environments and providers. Terraform, like the wand, makes it simple to take down and modify your infrastructure with a few lines of code.

## What is Terraform

Terraform is an open-source infrastructure as code (IaC) platform that lets developers define and manage cloud infrastructure resources declaratively.

Declarative is a programming concept where a program describes what should be accomplished, rather than how to accomplish it. In the context of Terraform, a declarative approach means that you define the desired state of your infrastructure and Terraform takes care of figuring out the necessary actions to achieve that state.

In Terraform, you define the desired state of your infrastructure using a configuration file, which specifies the resources you want to create, their properties and any dependencies between them. You do not need to write procedural code that specifies how to create and manage those resources. Instead, Terraform compares the desired state with the current state of the infrastructure and determines the necessary actions to achieve the desired state.

Terraform is also cloud agnostic. This means it supports multiple cloud providers such as Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP), as well as various other services, such as databases, DNS, and monitoring tools.

## Benefits of using Terraform

1.Infrastructure as code: Terraform provides a way to define infrastructure as code, which means you can version control and manage your infrastructure just like you would with application code.

2.Reusability: Terraform allows you to reuse infrastructure code across different environments, making it easier to manage and deploy consistent infrastructure.

3.Cloud-agnostic: Terraform can manage resources across multiple cloud providers and services, making it a great tool for multi-cloud deployments.

4.Consistency: Terraform ensures that the infrastructure deployed is consistent across all environments, making it easier to manage and maintain.

# Background

## Terraform Providers

A provider is a plugin that enables Terraform to interact with a particular infrastructure platform, service, or system. Providers are responsible for translating Terraform configuration files into API calls to create and manage resources.

## Resources

Resources are the most basic building blocks that represent a piece of infrastructure that you want to manage and can represent a wide variety of infrastructure components, such as virtual machines, databases, load balancers, DNS records, or any other resource that can be created or managed by a particular provider.

## Resource Type

A resource type is a category or class of infrastructure resources that can be created, updated, or destroyed using Terraform.

## Resource Name

A resource name is a unique identifier assigned to a specific resource within a given Terraform configuration.

## Resource Arguments

Resource arguments are the parameters or attributes that are passed to a resource block in Terraform. They provide the necessary information for Terraform to provision and manage a specific resource.

## Variables

Variables are used to define values that can be passed into a Terraform configuration at runtime. These variables can be easily changed or customized in your configurations to make them more dynamic and reusable.

## Jenkins

Jenkins is a powerful and popular open-source automation tool that helps software developers and engineers automate their development processes to build, test and deploy software projects.

# Main Terraform Commands

## Terraform init

The “terraform init” command initializes a new or existing Terraform working directory by downloading and installing the necessary plugins and modules for the Terraform configuration in that directory specified in the configuration files.

## Terraform validate

The “terraform validate” command checks the syntax and structure of the Terraform configuration files in the current working directory and validates the Terraform code for any errors or mistakes before deploying it to the target environment.

## Terraform plan

The “terraform plan” command creates an execution plan and generates a list of all the changes that Terraform will make to the infrastructure resources to bring it to the desired state defined in the Terraform configuration files.

## Terraform apply

The “terraform apply” command applies the changes by deploying the infrastructure resources defined in the configuration files to the target environment.

## Terraform destroy

The “terraform destroy” command removes all the resources that Terraform has created in the target environment based on the configuration files.

# Prerequisites

1.Basic knowledge and understanding of Terraform concepts and commands

2.Basic Linux command line knowledge

3.AWS Account with an IAM user with administrative privileges

4.Visual Code Studio set up and read for use

5.AWS CLI installed and configured in Visual Code Studio 

# Use Case

You are an Infrastructure Automation Engineer at Up The Chelsea. Your team wants to start utilising Jenkins as a CI/CD tool to build pipelines for DevOps initiatives. Your manager has assigned you the responsibility of deploying the Jenkins server on Amazon Web Services (AWS) using Terraform so that it may be used in various environments and changes to the environment are more easily tracked.

# Objectives

1.Deploy an EC2 Instances in the Default VPC.

2.Bootstrap the EC2 instance with a script that will install and start Jenkins.

3.Create and assign a Security Group to the Jenkins EC2 server which allows traffic on port 22 for SSH, port 443 for HTTPS and traffic from port 8080, which is the default port the Jenkins service uses.

4.Create an private S3 bucket for the Jenkins Artifacts.

5.Verify that you can reach the Jenkins install via port 8080 in a browser.

6.Create an IAM Role that allows S3 read/write access for the Jenkins Server and assign the role to the Jenkins server.

7.Verify functionality by connecting into your instance and archiving access to the S3 bucket using AWS CLI commands without leveraging your credentials.

## Step 0: Install latest Terraform version in Visual Code Studio

 Note that in this project i used linux for windows Ubuntu WSL to create the file and then run the file using Visual Code Studio.
 You should latest Terraform version installed on your Visual Code Studio.

 Run `terraform version` to verify the latest version is installed on your your Visual Code Studio terminal.

 ![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/b137e9cf464cfb179bd3ceb0433f5e4f8ef55a25/images/Screenshot%202025-01-21%20141808.png)


 ## Step 1: Create providers.tf Terraform file

 `nano providers.tf`

 Copy and paste the code below into the text editor, press “Ctrl and O” key together to save the file, then press Enter. Press “Ctrl and X” to exit the text editor.

```language
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
```

## Code explanation

This code configures the AWS provider with a specific region. The provider block is used to define the details of the AWS provider and inside the block contains its configuration options.

The region argument is set to the value of the variable var.aws_region.By using this syntax, Terraform will look for a variable named aws_region in the current workspace. We will see how we can define this variable in a separate variables.tf file.

## Step 2: Create Jenkins server’s security group Terraform configuration file

To fulfill our objectives, we need to create a security group for the Jenkins EC2 server and allow the appropriate ports so we can connect to the server over the internet.

Run the following command to create the file using the nano text editor —

`nano jenkins-sg.tf`

Again, copy and paste the code below into the text editor, save the file, then exit it as previously done in Step 1.

```language
#Jenkins Security Group Resource
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow Port 22 and 8080"

  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8080 Traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Code explanation

This Terraform code defines an AWS security group resource for the Jenkins server. A security group acts as a virtual firewall that controls inbound and outbound traffic to and from the EC2 instance.

The resource block defines the resource type aws_security_group and its name jenkins-sg. The description field provides a brief description of the security group.

The ingress blocks specify the inbound traffic rules for the security group. There are three ingress blocks, each allowing traffic on different ports (22, 443, and 8080) using the TCP protocol. The cidr_blocks argument specifies the IP address of range 0.0.0.0/0 to have access the Jenkins server, therefore allowing traffic from any IP address.

The egress block specifies the outbound traffic rules for the security group. In this case, all outbound traffic is allowed. The from_port and to_port arguments are set to 0 and the protocol argument is set to -1 to allow any outbound traffic.

## Step 3: Create IAM role that allows Jenkins server read/write access to S3 bucket

We need an IAM Role to be assumed by the Jenkins server with a policy that allows S3 read/write access.

This can be accomplished by creating a separate Terraform file called s3-iam-role.tf.

Run the following command to create the file —

`nano s3-iam-role.tf`

Copy and paste the code below into the text editor, save the file, then exit.

```language
resource "aws_iam_role" "s3-jenkins-role" {
  name = "s3-jenkins_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3-jenkins-rw-policy" {
  name   = "s3-jenkins-rw-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ReadWriteAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket}",
        "arn:aws:s3:::${var.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-jenkins-s3-access" {
  policy_arn = aws_iam_policy.s3-jenkins-rw-policy.arn
  role       = aws_iam_role.s3-jenkins-role.name
}

resource "aws_iam_instance_profile" "s3-jenkins-profile" {
  name = "s3-jenkins-profile"
  role = aws_iam_role.s3-jenkins-role.name
}
```
## Code explanation

The aws_iam_role resource defines a new IAM role called s3-jenkins_role that can be assumed by Jenkins EC2 instance. The assume_role_policy argument specifies a JSON-encoded policy that will allow the Jenkins EC2 instance to assume the role.

The aws_iam_policy resource defines a new IAM policy called s3-jenkins-rw-policy that allows read and write access to the S3 bucket. The policy argument specifies the policy document in JSON format.

The aws_iam_role_policy_attachment resource attaches the IAM policy to the IAM role by specifying the policy ARN and the role name.

The aws_iam_instance_profile resource creates an IAM instance profile called s3-jenkins-profile and associates it with the IAM role. The instance profile will be used to launch the Jenkins EC2 instance with the IAM role and associated permissions.

## Step 4: Create bash script file to automate installation of Jenkins on EC2 instance

When we launch the EC2 instance, this bash script with run automatically as the EC2’s user data which will install and start the Jenkins service.

Run the following command to create the file using the nano text editor —

`nano install_jenkins.sh`

Copy and paste the code below into the text editor, save the file, then exit.

```language
#!/bin/bash
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
```

## Code explanation

This bash script installs and starts Jenkins on the EC2 instance. Let’s go through what each command does:

1.sudo yum update -y: This updates the package manager and all installed packages to their latest version.

2.sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo: This downloads the Jenkins repository file and saves it to /etc/yum.repos.d/ directory.

3.sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key: This imports the Jenkins GPG key to verify package integrity.

4.sudo yum upgrade -y: This command upgrades all installed packages to their latest version.

5.sudo amazon-linux-extras install java-openjdk11 -y: This command installs Java 11 from the Amazon Linux Extras repository.

6.sudo yum install jenkins -y: This installs the Jenkins package from the Jenkins repository.

7.sudo systemctl enable jenkins: This command enables the Jenkins service to start automatically on boot.

8.sudo systemctl start jenkins: This command starts the Jenkins service.

## Step 5: Create main.tf Terraform file

The main.tf Terraform file contains the main set of configuration for your module.

Run the following command to create the file using the nano text editor —

`nano main.tf`

Copy and paste the code below into the text editor, save the file, then exit.

```language
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  user_data                   = file("install_jenkins.sh")
  iam_instance_profile        = aws_iam_instance_profile.s3-jenkins-profile.name

  tags = {
    Name = var.jenkins-tag-name
  }
}

resource "aws_s3_bucket" "jenkins-s3-bucket" {
  bucket = var.bucket

  tags = {
    Name = var.jenkins-tag-name
  }
}

resource "aws_s3_bucket_acl" "jenkins-s3-acl" {
  bucket = aws_s3_bucket.jenkins-s3-bucket.id
  acl    = "private"
  
}
```

## Code explanation 

This Terraform code contains resource blocks that define infrastructure resources that will be provisioned in AWS.

The terraform block declares aws as the required provider and specifies the source and version. The provider is responsible for managing and interacting with resources in AWS.

The resource block defines an EC2 instance resource with the name jenkins. It defines attributes like the Amazon Machine Image (AMI) to use, the instance type, the security group and tags. The user_data attribute specifies the install_jenkins.sh script to run when the instance is launched.

The aws_s3_bucket resource block defines an S3 bucket, and aws_s3_bucket_acl block sets the access control list (ACL) for the S3 bucket.

## Step 6: Create Terraform file that stores configuration variables

To prevent us from hard coding arguments in our main.tf file or other files, we can define variables in the variables.tf file that can be used throughout the Terraform environment. Variables are used to parameterize Terraform code, making it more reusable and configurable.

Let’s create the file —

`nano variables.tf`

Copy and paste the code below into the text editor, save the file, then exit.

```language
variable "aws_region" {
  default = "us-west-1"
  type    = string
}

variable "ami" {
  default = "ami-0118dc74bd8f98b13"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "princeKeypair"
  type    = string
}

variable "associate_public_ip_address" {
  default = "true"
  type    = bool
}

variable "jenkins-tag-name" {
  default = "Jenkins-Server"
  type    = string
}

variable "bucket" {
  default = "jenkins-s3-bucket-mario-moyo20"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}

variable "policy_arn" {
  default = "arn:aws:iam::aws:policy/AmazonS3ReadWriteAccess"
  type    = string
}
```

## Code explanation

This Terraform code defines several input variables that are used throughout of Terraform infrastructure deployment.

Let me give an explanation of each variable:

1.aws_region: Specifies the AWS region where the infrastructure should be deployed which has a default value of us-west-1.

2.ami: Specifies the ID of the Amazon Machine Image (AMI) that should be used to launch the EC2 instance. This variable has a default value of ami-0118dc74bd8f98b13, which corresponds to an Amazon Linux 2 AMI.

3.instance_type: Specifies the t2.micro instance type of the EC2 instance which is a low-cost, general-purpose instance type.

4.key_name: Specifies the name of the key pair that should be used to connect to the EC2 instance. This variable has a default value of princeKeypair.

5.associate_public_ip_address: Specifies whether the EC2 instance should be launched with a public IP address and has the default value of true.

6.jenkins-tag-name: Specifies the name of the tag that should be applied to the EC2 instance and S3 bucket resources and has a default value of Jenkins-Server.

7.bucket: Specifies the name of the S3 bucket that should be created to the value of jenkins-s3-bucket-mario-moyo20.

8.acl: Specifies the access control list (ACL) that should be applied to the S3 bucket. This variable has a default value of private.

## Step 7: Create output Terraform file to show the Jenkins Server’s Public IP Address

The output.tf file can be used to reference the public IP address of the Jenkins server instance. It will be displayed as part of the Terraform output after the infrastructure has been created or updated to be used to connect to the Jenkins server through a browser.

Let’s create the file —

`nano output.tf`

Copy and paste the code below into the text editor, save the file, then exit.

```language
#Jenkins Server Output
output "instance_public_ip" {
  value = aws_instance.jenkins.public_ip
}
```

## Code explanation

This Terraform code defines an output named instance_public_ip that will expose the public IP address of an AWS EC2 instance running the Jenkins server.

The value attribute is set to aws_instance.jenkins.public_ip, which means that the output value will be the public IP address of the aws_instance resource named jenkins.

## Step 8: Terraform init, validate, plan and apply

In your Visual Code studio terminal, run the following command to initialize the required providers —

`terraform init`

After it has finished initializing, you will be greeted with a successful prompt, as shown below.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/5b861d367a1149d42cbaa7c3ec9b43d9f7700282/images/Screenshot%202025-01-21%20110049.png)


Next, lets validate that our code doesn't have any syntax errors by running the following command —

`terraform validate`

You should receive a success message stating that the configuration is valid, as show below.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/ca7a670cb919624e0724f2bd82d391d9ca05de45/images/Screenshot%202025-01-21%20110120.png)


Now let’s run the following command to generate a list of all the changes that Terraform will make —

`terraform plan`

You should be able to see listed all the changes Terraform is expect to make to the infrastructure resources. The “+” sign is what is going to be added and the “ — ”is what is going to be destroyed.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/7a609d0418316752844961cd66c53e64ac7d1076/images/Screenshot%202025-01-21%20110225.png)


Now let’s deploy this bad boy! Run the following command to apply the changes and deploy the infrastructure resources.

Note — Make sure to type “yes” to agree to the changes after running this command

`terraform apply`

Terraform will begin applying all the changes to the infrastructure. Be patient, give it a few seconds to finish deploying. It should end with an Apply complete message and state the amount of resources added, changed and destroyed along with the Jenkins server’s public IP address as an output.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/24fde14ca0d3e819e2a702b88628d88cf5514b9c/images/Screenshot%202025-01-21%20110707.png)

Make sure to copy and save the Jenkins servers public IP address, as it will needed to access the Jenkins server from a browser.Take note that it only one resource appliead it because i had a error at the firts run and resource had passesd already. 

## Step 9: Verify Services — EC2 Instance, Security Group, IAM Role and S3 Bucket

In the AWS Management Console, head to the EC2 dashboard and verify that the Jenkins server was launched.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/950ae66746fff0af9a3ef9749736209ee43c0bce/images/Screenshot%202025-01-21%20110801.png)


If you scroll down and click on the EC2’s Security tab you should also be able to see the s3-jekins_role created along with the security group jenkins-sg.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/c19bea5608559ea5baf876eb5ece23b2e126aa0c/images/Screenshot%202025-01-21%20110830.png)


Scroll down again and view the inbound rules of the security group. Verify that it matches the desired configuration of allowing ports 22, 443 and 8080 from anywhere.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/6db341d25c06e89b53d9653684514cef2568e1d2/images/Screenshot%202025-01-21%20110858.png)


Now, head to the S3 dashboard and verify that the S3 bucket was created.


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/d9fbdfc19f4ccce75b7d3711634c5b89b0739434/images/Screenshot%202025-01-21%20111101.png)


Click on your bucket, select the Permission tab and hover the mouse over Access. As configured, the S3 bucket is not public.


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/e3a5b6f0ef30d187ebe4c89f8cc4ce5e77a3b1f4/images/Screenshot%202025-01-21%20111153.png)

Now that we have validated all our resources have been created by Terraform, let’s head to Step 10 to connect into the Jenkins Server and verify that Jenkins service is running.

## Step 10: SSH to EC2 Instance and verify Jenkins service is running

In the EC2 dashboard, click on the Jenkins server, then click Connect on the top right.


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/a3b5601c12f6bf2ce9f34f5daebbb2fb6e03283b/images/Screenshot%202025-01-21%20111225.png)


Select EC2 Instance Connect, then click Connect or SSH Client


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/3eb40aa5cd226d9bf1c7f68c52b0dd7fb7f6bf25/images/Screenshot%202025-01-21%20111248.png)

Once connected, run the following command to get the status of the Jenkins service —

`systemctl status jenkins`


You should be be able to see that the Jenkins server is active (running).

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/95559ed37bad5b841b405c7c7ff4f3a830627ec0/images/Screenshot%202025-01-21%20130936.png)

Copy and save the Jenkins administrator password which is shown at the end of the first line that start with a date. In this case, to get your password run this command `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`. This will be used to unlock Jenkins once we connect to it over the browser.


## Step 11: Connect to Jenkins Server from Browser

Open up you desired browser and paste the public IP address of the Jenkins Server mapped to port 8080 in the format below —

`<public_ip_address>:8080`


## Success!

If you did all the steps correctly, you should now be connected to your Jenkins server! You’ve used Terraform to automatically deploy your AWS infrastructure by leveraging the power of Infrastructure as Code!


## Set up Jenkins

We can now proceed to set up the Jenkins Server by pasting the administrator password in the field provided, then clicking Continue.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/c321547e279f6f09171af1c1a989fe6211906371/images/Screenshot%202025-01-21%20131126.png)


Select Install suggested plugins, then go through the rest of prompts.


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/dff261fdcaeb5b0236e1b2270a57b20a58731615/images/Screenshot%202025-01-21%20131200.png)

Fill in the fields to create your admin user, then continue.


![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/f39c9ee94d5abeb5f5ff4937428dfd518d0b8ffe/images/Screenshot%202025-01-21%20131508.png)



At the end you should be greated with the awesome message, “Jenkins is ready!”

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/de36ede23715e7899a614edbfe37b9a9b7c94c37/images/Screenshot%202025-01-21%20131727.png)


## Success!

You’ve just set up your first Jenkins Server running on an Amazon EC2 instance deployed by Terraform.



## Step 12: Verify that IAM role allows S3 bucket access from Jenkins Server

Head to S3 in the AWS Management Console, select the S3 bucket, then click Upload to upload a file to the S3 bucket.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/3fad22af41bc117500238c3f86a29e739b3f4933/images/Screenshot%202025-01-21%20132033.png)

Select your file then click Upload. In this demonstration, I will be uploading the David Wallace Foster "This is water" commencement speech.pdf file.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/47c7db687374cffff79c103c3ada6637bcc6c749/images/Screenshot%202025-01-21%20132320.png)

You should now be able to see your file successfully uploaded.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/e5ec413e3bda11b9460f6e63cb562102d94cb101/images/Screenshot%202025-01-21%20132337.png)

Now, connect back to you Jenkins Server using EC2 Instance Connect from the EC2 dashboard.

Run the following command to attempt to list the objects in your S3 bucket including the name of the S3 bucket—

In this demonstration, I used the name of my S3 bucket created by Terraform.

`aws ls s3://<s3_bucket_name>`

As seen below, we can view, list, access the object previously uploaded into the S3 bucket.

Additionally, if I run the command again, without specifying the S3 bucket which the Jenkins server has access to via the IAM role, we will be greeted with an AccessDenied message prompt.

We have verified that we do not have access to other S3 buckets and their contents.

![image_alt](https://github.com/Tatenda-Prince/Infrastructure-Automation-Deploying-An-EC2-Jenkins-CI-CD-Server-With-Terraform/blob/200c16950ac2527d570ab9006d468dd3376136af/images/Screenshot%202025-01-21%20133451.png)


# Congratulations!

You’ve successfully completed “The power of Terraform”. You’ve learned basic and fundamental concepts of Terraform and leveraged this powerful for infrastructure automation to deploy a Jenkins Server on AWS, along with other resources like Security Groups, S3 buckets and IAM roles.

# Clean up

## Destroy infrastructure

Run the follow command to remove/delete/tear down all the resources previously provisioned from Terraform —

`terraform destroy`

Wait for it to complete. At the end, you should receive a prompt stating Destroy complete along with how many resources were destroyed.

![image_alt]()






















































 

 







