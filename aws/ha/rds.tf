resource "aws_db_subnet_group" "mysql" {
  name       = join(var.dl, [var.name_prefix, "mysql"])
  subnet_ids = [aws_subnet.wp["primary-private"].id, aws_subnet.wp["secondary-private"].id]

  tags = {
    Name = join(var.dl, [var.name_prefix, "mysql"])
  }
}

resource "aws_db_instance" "mysql" {
  identifier = join(var.dl, [var.name_prefix, "mysql"])

  allocated_storage     = 20
  max_allocated_storage = 50 // this enables storage auto-scaling
  storage_encrypted     = true

  engine         = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"

  name     = "wordpress"
  username = "admin"
  password = var.rds_user_password

  publicly_accessible    = false
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.id
  vpc_security_group_ids = [aws_security_group.db.id]

  backup_retention_period = 35
  apply_immediately       = true
  skip_final_snapshot     = true

  tags = {
    Name = join(var.dl, [var.name_prefix, "mysql"])
  }
}