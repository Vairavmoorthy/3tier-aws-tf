resource "aws_db_instance" "masterdb" {
  engine                = "mysql"
  allocated_storage     = 10
  engine_version        = "8.0.31"
  storage_type          = "gp2"
  identifier            = "vmdb"
  username              = "admin"
  password              = "adelaide64"
  instance_class        = "db.t2.micro"
  multi_az              = false
  db_subnet_group_name  = aws_db_subnet_group.db_subnets.id
  vpc_security_group_ids = [aws_security_group.db_sec.id]
  deletion_protection   = false
  publicly_accessible   = false
  backup_retention_period = 7

  skip_final_snapshot  = true  # Set to false to create a final snapshot
  #final_snapshot_identifier = "masterdb-final-snapshot"  # Unique name for the final snapshot

  tags = {
    Environment = "free tier"
  }
}

resource "aws_db_instance" "replica-masterdb" {
  instance_class       = "db.t3.micro"
  backup_retention_period = 7

  #skip_final_snapshot  = false # Set to false to create a final snapshot
  #final_snapshot_identifier = "replica-masterdb-final-snapshot"  # Unique name for the final snapshot
  replicate_source_db = aws_db_instance.masterdb.identifier
}
