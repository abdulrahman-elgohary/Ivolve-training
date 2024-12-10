
module "networking" {
    source = "./modules/networking"
    aws_vpc_cidr = "10.0.0.0/16"
    aws_region = "us-east-1"
    availability_zones = ["us-east-1a","us-east-1b"]
    aws_private_subnet_cidrs = ["10.0.0.0/24","10.0.2.0/24"]
    aws_public_subnet_cidrs = ["10.0.1.0/24","10.0.3.0/24"]  
}

module "security_group" {
    source = "./modules/security_groups"
    vpc_id = module.networking.vpc_id
}

module "compute" {
    source = "./modules/compute"
    
    sg_proxy_tr = module.security_group.sg-proxy-id
    public_subnet_id = module.networking.public_subnets_id
   

    sg_http_tr = module.security_group.sg-http-id
    private_subnet_id = module.networking.private_subnets_id
    in-lb-arn = module.loadbalancer.in-lb-tr-arn
    in-lb-dns-name = module.loadbalancer.in-lb-tr-dns-name
    
    aws_ec2_size = "t2.micro"
    depends_on = [ module.networking ]
}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc_id = module.networking.vpc_id
    proxy-instances-id = module.compute.proxy-instances-id
    public_subnets = module.networking.public_subnets_id
    sg-lb-tr = module.security_group.sg-lb-tr

    http-instances-id = module.compute.http-instnces
    private_subnets = module.networking.private_subnets_id
    sg-in-lb-tr = module.security_group.sg-in-lb-tr
    
}
