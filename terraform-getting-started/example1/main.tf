# Lines with # at the beginning are comments
#
# Every Terraform resource is formed by a "resource" block with two arguments:
#
#  - "local_file" is the name of the Terraform provider which only creates local files
#  - "myfile1" is any logical name chosen for our resource. This name must be unique among
#    all .tf files in the current directory
#
# The contents of the "resource" block are driven by the Terraform provider. In this example, we're using two parameters:
#
#  - "content" which defines the content of the file
#  - "filename" defines the name and path of the file to create
resource "local_file" "myfile1" {
  content  = "This is just a test file"
  filename = "test-file-01.txt"
}

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