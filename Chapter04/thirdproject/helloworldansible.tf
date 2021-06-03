
# Provider Configuration for AWS
provider "aws" {
  region = "us-east-1"
}

# Resource Configuration for AWS
resource "aws_instance" "myserver" {
  ami = "ami-cfe4b2b0"
  instance_type = "t2.micro"
  key_name = "EffectiveDevOpsAWS"
  vpc_security_group_ids = ["sg-0da9cae0f21af7c7e"]

  tags = {
    Name = "helloworld"
  }

# Provisioner for applying Ansible playbook
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      host = self.public_ip
      private_key = "${file("~/.ssh/EffectiveDevOpsAWS.pem")}"
    }
    inline = [
    "ls -ltr"
    ]
  }
  
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' > ./myinventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i myinventory --private-key=~/.ssh/EffectiveDevOpsAWS.pem helloworld.yml"
  } 
}

# IP address of newly created EC2 instance
output "myserver" {
 value = "${aws_instance.myserver.public_ip}"
}
