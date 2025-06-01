resource "aws_ssm_parameter" "vpc_id"{
    name = "/${var.project_name}/${var.environment}/vpc_id"
    type = "String"
    value = module.vpc.vpc_id
}

#["id1","id2"] terraform format
# id1, id2 -> AWS SSM format
resource "aws_ssm_parameter" "public_subnet_id"{
    name = "/${var.project_name}/${var.environment}/public_subnet_id"
    type = "StringList"
    value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_id"{
    name = "/${var.project_name}/${var.environment}/private_subnet_id"
    type = "StringList"
    value = join(",", module.vpc.private_subnet_ids) #inorder to catch and store values here it has to be declared in output of module development
}

resource "aws_ssm_parameter" "db_subnet_group_name" {
  name  = "/${var.project_name}/${var.environment}/db_subnet_group_name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}