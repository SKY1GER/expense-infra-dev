variable "project_name"{
    type = string
    default = "expense"
}

variable "environment"{
    type = string
    default = "dev"
}

variable "common_tags"{
    type = map
    default = {
        terraform = true
        project_name = "expense"
        Environment = "dev"

    }
}

variable "public_subnet_cidrs"{
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs"{
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs"{
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "is_peering_required"{
    type = bool
    default = true
}