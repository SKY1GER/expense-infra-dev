resource "aws_key_pair" "openvpn"{
  key_name = "openvpn"
  #you can paste public key directly
  public_key = file("~/.ssh/openvpn.pub")
}


resource "aws_instance" "vpn" {
  key_name = aws_key_pair.openvpn.key_name
  #name = "${var.project_name}-${var.environment}-vpn"
  user_data = file("user_data.sh")
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  # convert StringList to list and get first element
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id
  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-vpn"
    }
  )
}