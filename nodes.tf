# Ansible node1
resource "aws_instance" "ans-n1" {
  ami           = "ami-0e7bad923e8155ef5"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ans-sn-1.id
  key_name = "jenkins"
  private_ip = "10.0.0.101"
  vpc_security_group_ids = [aws_security_group.ans_nodes_sg.id]

  tags = {
    Name = "n1"
  }
}

# Ansible node2
resource "aws_instance" "ans-n2" {
  ami           = "ami-0e7bad923e8155ef5"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.ans-sn-1.id
  key_name = "jenkins"
  private_ip = "10.0.0.102"
  vpc_security_group_ids = [aws_security_group.ans_nodes_sg.id]

  tags = {
    Name = "n2"
  }
}
