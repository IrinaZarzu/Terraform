# Database tier 3

resource "aws_db_instance" "primary-dbtier3" {
  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_name
  engine                  = "mysql"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_type
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group
  skip_final_snapshot     = true
  backup_retention_period = 5
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db-tier3.id]
  identifier              = "primary-dbtier3"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags

}

resource "aws_db_instance" "replica-dbtier3" {
  instance_class         = var.db_instance_type
  skip_final_snapshot    = true
  replicate_source_db    = aws_db_instance.primary-dbtier3.identifier
  identifier             = "replica-dbtier3"
  parameter_group_name   = var.db_parameter_group
  vpc_security_group_ids = [aws_security_group.db-tier3.id]
  apply_immediately      = true

  depends_on = [aws_db_instance.primary-dbtier3]

  tags = local.common_tags

}
# DB subnet group for RDS 

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet5.id, aws_subnet.private_subnet6.id]

  tags = local.common_tags

}