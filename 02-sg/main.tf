module "db"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for db mysql instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "db"
}

module "backend"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for backend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "backend"
}

module "frontend"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for frontend instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "frontend"
}

module "bastion"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for bastion instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "bastion"
}



module "app_alb"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for app_alb instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags
    sg_name = "app_alb"
}

module "vpn"{
    source = "../../expense-security-group"
    project_name = var.project_name
    environment = var.environment
    sg_description = "sg for vpn instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    inbound_rules = var.vpn_sg_rules
    common_tags = var.common_tags
    sg_name = "vpn"

}


module "web_alb" {
  source = "../../expense-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Web ALB Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "web-alb"
}

#DB is accepting connection from backend

resource "aws_security_group_rule" "db_backend"{
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id 
    security_group_id = module.db.sg_id
}

#DB is accepting connection from bastion

resource "aws_security_group_rule" "db_bastion"{
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = module.backend.sg_id 
    security_group_id = module.bastion.sg_id
}

resource "aws_security_group_rule" "db_vpn"{
    type = "ingress"
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id 
    security_group_id = module.bastion.sg_id
}

#backend is accepting connection from app_alb
resource "aws_security_group_rule" "backend_app_alb"{
    type = "ingress"
    from_port = "8080"
    to_port = "8080"
    protocol = "tcp"
    source_security_group_id = module.app_alb.sg_id
    security_group_id = module.backend.sg_id
}

#backend is accepting connection from bastion
resource "aws_security_group_rule" "backend_bastion"{
    type = "ingress"
    from_port = "22"#8080
    to_port = "22"
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.backend.sg_id
}

#backend is accepting connection from vpn_ssh
resource "aws_security_group_rule" "backend_vpn_ssh"{
    type = "ingress"
    from_port = "22"#8080
    to_port = "22"
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id
    security_group_id = module.backend.sg_id
}

#backend is accepting connection from vpn_http
resource "aws_security_group_rule" "backend_vpn_http"{
    type = "ingress"
    from_port = "8080"#8080
    to_port = "8080"
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id
    security_group_id = module.backend.sg_id
}


#frontend is accepting connection from public
resource "aws_security_group_rule" "frontend_public"{
    type = "ingress"
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend.sg_id
}

#bastion is accepting connection from bastion
resource "aws_security_group_rule" "bastion_public"{
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}


#bastion is accepting connection from deafult_vpc
resource "aws_security_group_rule" "backend_default_vpc"{
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    security_group_id = module.backend.sg_id
}
#backend is accepting connection from vpn_ssh
resource "aws_security_group_rule" "app_alb_vpn"{
    type = "ingress"
    from_port = "80"#8080
    to_port = "80"
    protocol = "tcp"
    source_security_group_id = module.vpn.sg_id
    security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id # source is where you are getting traffic from
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id 
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
  security_group_id = module.frontend.sg_id
}

#added as part of Jenkins CICD
resource "aws_security_group_rule" "frontend_default_vpc" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["172.31.0.0/16"]
  security_group_id = module.frontend.sg_id
}