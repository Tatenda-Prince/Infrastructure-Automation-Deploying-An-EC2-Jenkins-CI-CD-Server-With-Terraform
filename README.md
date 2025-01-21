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

 ![image_alt]()

 

 







