# Terraform Guide - Getting started

## What is Terraform?

It's an Open Source tool used for provisioning Infrastructure resources programatically. That is, by the use of pure source code. That is why this is an IaC (Infrastructure as Code) tool.  In fact, it's one of the most used pieces of software preferred by DevOps engineers, Cloud engineers and Cloud architects nowadays.

According to [Terraform documentation](https://www.terraform.io/docs/index.html), there are a mix of concepts like Terraform CLI, Terraform Cloud, Terraform Enterprise, Terraform Language, Terraform Providers and Modules, among others. So for now, let's just focus on Terraform CLI, which is the tool that we're going to review in this document.

## Why can this tool be useful for me?

Mainly because you can take advantage of many of the benefits that Infrastructure as Code provides. Some of them are:

- **Automated provisioning of infrastructure**, *create, destroy and maintain infrastructure resources in just minutes or seconds instead of doing repetitive and manual tasks*
- **Infrastructure versioning**, *when managing infrastructure as source code this can be easily versioned with tools such as Git or SVN in the same way developers control versioning of their software*
- **Increased security, standardization and reduced human errors**, *when doing manual tasks -such as provisioning virtual machines using GUI- there's always some room for mistakes, especially when we need to do it many times and we're feeling tired at midnight. Instead, just put some effort developing source code for provisioning your infrastructure by following good standard and security practices so in the future you can easily reuse this work for deploying always with the same guaranteed results.*
- **It's almost a de factor standard**, *you might have already noticed that many IT engineers and architects (DevOps and Cloud) have heard about Terraform, they're using it or are seeking to learn it. Also, many companies expect to hire candidates who master this awesome tool. So, why wouldn't you get involved too?*

Well, there are some other benefits, but I don't pretend to make this document boring. So let's jump into action right now!

## What kind of things can I do with Terraform?

Terraform is capable of deploying a huge amount of different resources in many Cloud providers, Virtualization platforms and many Cloud based services. Hence, it can deploy infrastructure resources in Amazon Web Services, Google Cloud Platform, Microsoft Azure, VMware vSphere, Kubernetes, etc.

All the platforms supported is based on the concept of Terraform Providers. Actually, a list of providers can be browsed [here](https://registry.terraform.io/browse/providers).

Terraform Providers define what kind of resouces can be deployed on a supported platform. For example, on Amazon Web Services you can create Virtual Machines, Load Balancers, VPCs, S3 Buckets, RDS instances, Lambda functions and a huge list of cloud resources. Just take a look at the [AWS Terraform Provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to have a bare idea.

## How can I install Terraform?

Go to [https://www.terraform.io/](https://www.terraform.io/) and click on "Download CLI" button. Choose the right URL of the installer for your operating system. As Terraform is a CLI tool, it consists of just a single binary which is gotten as a ZIP file from [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

Once you've downloaded the ZIP file, extracts its contents into a directory which is part of your PATH environment variable. You can use these examples as a reference:

On Windows PowerShell
```powershell
Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_windows_amd64.zip" -OutFile "C:\terraform.zip"
Expand-Archive -LiteralPath "C:\terraform.zip" -DestinationPath "C:\bin"
```

On Linux or Mac
```shell
wget -O terraform.zip https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_windows_amd64.zip
sudo unzip terraform.zip -d /usr/local/bin
sudo chmod 755 /usr/local/bin/terraform
```

Finally, check that Terraform command works fine by checking the current version installed

```shell
terraform version
```

## OK, what can I do now? How do I use it?

First off, some tips and facts about Terraform before the hands-on:
- You need a text editor or code editor, not a word processor. So discard the use of Microsoft Word for this.
- For now, let's just use any basic text editor such as Notepad on Windows or any equivalent in other platforms.
- We need to make sure to write ***plain text*** code on the following examples.
- Terraform configuration files must have a *.tf* extension
- Terraform uses HCL (Hashicorp Configuration Language) for its *.tf* files
- For now, this guide will only show you the very basics of Terraform to manage some local resources in your PC or laptop. We'll later document other introductory guides for AWS, GCP and Azure.

Remember to follow this well-known **Terraform workflow**:

1. Create a dedicated directory for each Terraform project
2. Write your code in one or more *.tf* files
3. Initialize Terraform providers and backends by running `terraform init`
4. Validate your source code syntax by running `terraform validate`
5. Do a dry-run or preview of the changes you're about to do by running `terraform plan`
6. Make your changes effective by running `terraform apply`
7. If you want to destroy the resources you created, run `terraform destroy`


### Example 1 - Create a text file locally with some fixed content

Create a directory called *example1* and a *main.tf* inside with a content like this:

```hcl
# Lines with # at the beginning are comments
#
# Every Terraform resource is formed by a "resource" block with two arguments:
#
#  - "local_file" is the name of the resource type, which in this case, it only creates local files
#  - "myfile1" is any logical name chosen for our resource. This name must be unique among
#    all .tf files in the current directory
#
# The contents of the "resource" block are driven by the Terraform provider. In this example, we're using two parameters:
#
#  - "content" which defines the content of the file
#  - "filename" defines the name and path of the file to create
resource "local_file" "myfile1" {
  content = "This is just a test file"
  filename = "test-file-01.txt"
}
```

1.1. After saving changes, initialize the providers by running this command from the same directory where *main.tf* file is located:

```shell
terraform init
```

1.2. Now, check if the syntax is OK:

```shell
terraform validate
```

1.3. Do a dry-run of the changes:

```shell
terraform plan
```

1.4. Apply changes and answer yes when prompted "Enter a value":

```shell
terraform apply
```

1.5. Check if the *test-file-01.txt* file exists and check its contents:

```shell
# Linux or Mac
ls
cat test-file-01.txt

# Windows Powershell
Get-ChildItem
Get-Content test-file-01.txt
```

1.6. I also found some files like *terraform.tfstate*, *.terraform.lock.hcl* and a *.terraform* directory. What are they for?

  - ***terraform.tfstate*** - Is the state file where Terraform keeps track of all resources created and changes made to them. If you remove this file, Terraform won't know if the resource exists or not so it will attempt to created it again, but this can cause problems if the resources already exist. So, don't remove this file.
  - ***.terraform.lock.hcl*** - It's a hidden file that helps Terraform keep track of provider dependencies. Just leave this file intact.
  - ***.terraform*** - It's a hidden directory where Terraform saves a copy of the providers (which can size several megabytes) and modules (external terraform configurations) for use as part of the current project/directory. Don't touch this foler or its contents. If you remove it, you'll need to run `terraform init` again.

1.7. Try running `terraform plan` again to see what happens:

```shell
terraform plan
```

No changes detected, right?

1.8. What if you remove the *test-file-01.txt* file and do a plan again?

```shell
# Linux or Mac
rm test-file-01.txt

# Windows Powershell
Remove-Item test-file-01.txt

terraform plan
```

Did you see how Terraform tries to create again the resource?

### Example 2 - Create another file with a randon suffix

Edit the same *main.tf* file and add the following content at the end of the file:

```hcl
# This is the definition of a variable called "random_file_content" with a default
# value set
variable "random_file_content" {
  default = "This is a default content"
}

# This is a local variable called "random_file_name" which defines the prefix and suffix
# of the file to create. This local variable cannot be overriden or changed on the fly because
# of its local nature.
# This local variable combines a fixed value (prefix) with the value of another resource (random suffix)
# which is of type "random_id", with a logical name of "rand_suffix" and we get the "hex" attribute from it
locals {
  random_file_name = "test-file-${random_id.rand_suffix.hex}.txt"
}

# This is another resource for creating a file with a logical name of "myrandomfile"
# The contents of this file are defined by the value of the "file_content" variable
# The name of this file is defined by the value of the "random_file_name" local variable
resource "local_file" "myrandomfile" {
  content  = var.random_file_content
  filename = local.random_file_name
}

# We create a resource of type "random_id" with a logical name of "rand_suffix"
# This random ID has a length of 4 bytes
resource "random_id" "rand_suffix" {
  byte_length = 4
}

# Section of outputs. Each of them exposes or shows certain values at the screen
# after runnnig "terraform apply" or "terraform output"

# Name of the random file
output "random_file_name" {
  value = local.random_file_name
}

# Content of the random file
output "random_file_content" {
  value = var.random_file_content
}

# Name of the fixed file
output "fixed_file_name" {
  value = local_file.myfile1.filename
}

# Content of the fixed file
output "fixed_file_content" {
  value = local_file.myfile1.content
}
```

2.1. After saving changes, let's initialize Terraform again because this time we're using a new provider (random_id). Also, check the syntax:

```shell
terraform init
terraform validate
```

2.2. Run a plan and see what changes are proposed"

```shell
terraform plan
```

Pay attention to the proposed content of the `local_file.myrandomfile` resource. Now see what happens when passing a value for the `random_file_content` variable

```shell
terraform plan -var random_file_content="This is another non-default content"
```

Did you see any difference on the content of the `local_file.myrandomfile` resource?

2.3. Make changes without passing a value for any variables and without asking for confirmation:

```shell
terraform apply -auto-approve
```

Notice the outputs of the previous commands. You can see what are the names and contents of both the fixed and random file. Verify the same with manual commands such as `ls`, `cat`, `Get-ChildItem`, `Get-Content`

2.4. See if any changes are detected and show only the outputs:

```shell
terraform plan

terraform output
```

2.5. Now make changes by passing a value for the `random_file_content` variable:

```shell
terraform apply -auto-approve -var random_file_content="This is not the same content"
```

2.6. Once last try: make changes without passing a value for the `random_file_content` variable:

```shell
terraform apply -auto-approve
```

See how the content of the random file changes depending on the default or custom value of a variable.

## Conclusion

This guide was an introduction to Terraform which showed some concepts, facts and tips before getting our hands dirty with the configurations and commands. Then we presented two examples with increased complexity to explain many of the key aspects of this tool: providers, configuration files, terraform actions or commands, resources, variables and outputs.

In a next tutorial, we will see how to create real Cloud resources in some Cloud providers. Hope this guide was useful just as an introduction.
