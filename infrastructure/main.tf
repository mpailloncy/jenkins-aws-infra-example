data "aws_ami" "ubuntu_docker" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-16.04-docker-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins-master" {
  ami = "${data.aws_ami.ubuntu_docker.id}"

  instance_type = "${var.jenkins_master_instance_type}"

  key_name = "${aws_key_pair.provisioner.id}"

  subnet_id              = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.web_inbound_security_group.id}"]

  associate_public_ip_address = true

  tags {
    Name = "jenkins-master"
  }

}

// TODO - improve the provisioning through a bastion machine


/*resource "aws_instance" "bastion" {

  ami           = "${data.aws_ami.fedora_ansible.id}"

  instance_type = "t2.micro"

  key_name = "${aws_key_pair.provisioner.id}"

  subnet_id = "${aws_subnet.public_subnet_eu_central_1a.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]

  associate_public_ip_address = true

  tags {
    Name = "ansible-bastion"
  }

}
*/

