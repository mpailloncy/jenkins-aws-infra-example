resource "aws_key_pair" "provisioner" {
  key_name = "provisioner-key"
  public_key = "${file("../provisioner-key.pub")}"
}

// used inside configuration of Jenkins EC2 Plugin to communicate with agents
resource "aws_key_pair" "jenkins-infra" {
  key_name = "jenkins-infra-key"
  public_key = "${file("../jenkins-infra-key.pub")}"
}
