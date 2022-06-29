

###############################################################################

resource "random_password" "master_password" {
  length  = 10
  special = false
}


###########
# DB Subnet
###########

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "database subnets"
  subnet_ids = aws_subnet.private.*.id
  tags = {
    Name = "Database Subnets"
  }
}

#############
# RDS Aurora
#############

#resource "aws_rds_global_cluster" "smretailpdev" {
#  count                     = 1
#  provider                  = aws.primary
#  global_cluster_identifier = "${var.identifier}-globaldb"
#  engine                    = var.engine
#  engine_version            = var.engine_version_mysql
#  storage_encrypted         = var.storage_encrypted
#}

resource "aws_rds_cluster" "smretail_devcls" {
#  provider                         = aws.primary
#  global_cluster_identifier        = var.setup_globaldb ? aws_rds_global_cluster.globaldb[0].id : null
  cluster_identifier               = "aurora-cluster-smrdt"
  engine                           = var.engine
  engine_version                   = var.engine_version_mysql
#  allow_major_version_upgrade      = var.allow_major_version_upgrade
  availability_zones               = ["ap-southeast-1a", "ap-southeast-1b"]
  db_subnet_group_name             = aws_db_subnet_group.rds_subnet_group.name
  port                             = var.port
  database_name                    = var.database_dev_name
  master_username                  = var.db_dev_username
  master_password                  = var.db_dev_password
#  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group_p.id
#  db_instance_parameter_group_name = var.allow_major_version_upgrade ? aws_db_parameter_group.aurora_db_parameter_group_p.id : null
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.preferred_backup_window
  storage_encrypted                = var.storage_encrypted
#  kms_key_id                       = var.storage_encrypted ? aws_kms_key.kms_p[0].arn : null
  apply_immediately                = true
  skip_final_snapshot              = var.skip_final_snapshot
#  final_snapshot_identifier        = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.identifier}-${var.region}-${random_id.snapshot_id.hex}"
#  snapshot_identifier              = var.snapshot_identifier != "" ? var.snapshot_identifier : null
  enabled_cloudwatch_logs_exports  = local.logs_set
#  tags                             = var.tags
  depends_on                       = [
    # When this Aurora cluster is setup as a secondary, setting up the dependency makes sure to delete this cluster 1st before deleting current primary Cluster during terraform destroy
    # Comment out the following line if this cluster has changed role to be the primary Aurora cluster because of a failover for terraform destroy to work
    #aws_rds_cluster_instance.secondary,
  ]
  lifecycle {
    ignore_changes = [
      replication_source_identifier,
    ]
  }
}

#resource "aws_rds_cluster_instance" "smretail_ist" {
#  cluster_identifier = aws_rds_cluster.smretail_devcls.id
#  instance_class     = db.t3.medium
#  engine             = aws_rds_cluster.smretail_devcls.engine
#  engine_version     = var.engine_version_mysql
#    }

resource "aws_rds_cluster_instance" "smretail_devinst" {
  count                        = var.db_instance_count
#  provider                     = aws.primary
identifier                   = "aurora-cluster-smrdt"
#  identifier                   = "${var.name}-${var.region}-${count.index + 1}"
  cluster_identifier           = aws_rds_cluster.smretail_devcls.id
  engine                       = aws_rds_cluster.smretail_devcls.engine
  engine_version               = var.engine_version_mysql
#  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  instance_class               = db.r3.large
  db_subnet_group_name         = aws_db_subnet_group.rds_subnet_group.name
#  db_parameter_group_name      = aws_db_parameter_group.aurora_db_parameter_group_p.id
  performance_insights_enabled = true
#  monitoring_interval          = var.monitoring_interval
#  monitoring_role_arn          = aws_iam_role.rds_enhanced_monitoring.arn
  apply_immediately            = true
#  tags                         = var.tags
}

###############################################################################


#resource "aws_rds_cluster" "smrdt_clst" {
#  cluster_identifier      = "aurora-cluster-smrdt"
#  engine                  = "aurora-mysql"
#  engine_version          = "8.0.mysql_aurora.3.02.0"
#  engine_mode             = "provisioned"
#  availability_zones      = ["ap-southeast-1a", "ap-southeast-1b"]
#  database_name           = "smrdtdb"
#  master_username         = "admin"
#  master_password         = "Admin123"
#  backup_retention_period = 5
#  preferred_backup_window = "02:00-04:00"
#  #apply_immediately         = true
#  #final_snapshot_identifier = "aurora-cluster-smrdt-backup"
#  skip_final_snapshot       = true
#  apply_immediately         = true

#  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
#  vpc_security_group_ids  = [aws_security_group.smrdt_db_sg.id]
 


#  serverlessv2_scaling_configuration {
#    max_capacity = 8.0 #  1 ACU provides 2 GiB of memory and corresponding compute and networking
#    min_capacity = 4.0 #  1 ACU provides 2 GiB of memory and corresponding compute and networking
#  }
#}

#resource "aws_rds_cluster_instance" "smrdt_istc" {
#  cluster_identifier = aws_rds_cluster.smrdt_clst.id
#  instance_class     = "db.serverless"
#  engine             = aws_rds_cluster.smrdt_clst.engine
#  engine_version     = aws_rds_cluster.smrdt_clst.engine_version
#    }