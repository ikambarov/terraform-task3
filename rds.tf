module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.6.0"

  name           = "wordpress-rds"
  engine         = "aurora-mysql"
  database_name  = "wordpress"
  instance_class = "db.t3.medium"
  instances = {
    1 = {
      instance_class = "db.t3.medium"
    }
    2 = {
      instance_class = "db.t3.medium"
    }
  }

  vpc_id  = aws_vpc.task_vpc.id
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]

  allowed_cidr_blocks = ["0.0.0.0/0"]

  storage_encrypted   = true
  apply_immediately   = true
  skip_final_snapshot = true
  monitoring_interval = 10

  tags = merge(var.common_tags, {
    Name = "wordpress-rds"
  })
}