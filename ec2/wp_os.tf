variable "ami" {}
variable "inst_type" {
  type = string
  default = "t2.micro"
}
# t2.small
variable "key_name" {}
variable "sg_id" {}
variable "subnet_id" {}
variable "db_host_name" {}
variable "wordpress_db_name" {}

resource "aws_instance" "wp_inst" {
  ami             = var.ami
  instance_type   = var.inst_type
  key_name        = var.key_name
  vpc_security_group_ids = [var.sg_id,]
  subnet_id       = var.subnet_id
  
  user_data       = templatefile("${path.module}/installmaria.sh", {
    DB_USERNAME       = random_string.this.result
    DB_HOST           = var.db_host_name
    WORDPRESS_DB_NAME = var.wordpress_db_name
    WORDPRESS_DB_USER = random_string.this.result
    DB_USER_PASSWORD  = random_password.this.result
    DB_ROOT_PASSWORD  = random_password.this.result    
  })

  tags = {
    Name = "wp_os"
  }
}

output "db" {
  value = aws_instance.wp_inst
}

resource "random_string" "this" {
 length    = 24
 special   = false
 min_upper = 5
 min_lower = 5
}

resource "random_password" "this" {
 length    = 24
 special   = false
 min_upper = 5
 min_lower = 5
}