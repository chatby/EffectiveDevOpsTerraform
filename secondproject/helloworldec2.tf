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
    Name = "helloworld2"
  }
# Helloworld Appication code
  provisioner "remote-exec" {
    connection {
      user = "ec2-user"
      host = self.public_ip
      private_key = "${file("~/.ssh/EffectiveDevOpsAWS.pem")}"
    }
    inline = [
      "sudo yum install --enablerepo=epel -y nodejs",
      "sudo wget https://raw.githubusercontent.com/yogeshraheja/Effective-DevOps-with-AWS/master/Chapter02/helloworld.js -O /home/ec2-user/helloworld.js",
      "sudo wget https://raw.githubusercontent.com/yogeshraheja/Effective-DevOps-with-AWS/master/Chapter02/helloworld.conf -O /etc/init/helloworld.conf",
      "sudo start helloworld",
    ]
  }
}
