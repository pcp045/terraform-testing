# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-southeast-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

#######################################################################################################

variable "identifier" {
  description = "Cluster identifier"
  type        = string
  default     = "aurora"
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying Aurora storage layer should be encrypted"
  type        = bool
  default     = false
}

variable "port" {
  description = "The port on which to accept connections"
  type        = string
  default     = "3306"
}

variable "engine" {
  description = "Aurora database engine type: aurora (for MySQL 5.6-compatible Aurora), aurora-mysql (for MySQL 5.7-compatible Aurora), aurora-postgresql"
  type        = string
  default     = "aurora-mysql"
}

variable "db_instance_count" {
  description = "instance count for primary Aurora cluster"
  default = 1
}

variable "instance_class" {
  type        = string
  description = "Instance type to use at replica instance"
  default     = "db.t3.medium"
}

variable "engine_version_mysql" {
  description = "Aurora database engine version."
  type        = string
  default     = "8.0.mysql_aurora.3.02.0"
}

variable "database_dev_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = "smrdtdev"
}

variable "db_dev_username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "db_dev_password" {
  description = "Master DB password"
  type        = string
  default     = "Password123"
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "skip creating a final snapshot before deleting the DB"
  #set the value to false for production workload
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}


variable "enable_audit_log" {
  description = "Enable MySQL audit log export to Amazon Cloudwatch."
  type        = bool
  default     = false
}

variable "enable_error_log" {
  description = "Enable MySQL error log export to Amazon Cloudwatch."
  type        = bool
  default     = false
}

variable "enable_general_log" {
  description = "Enable MySQL general log export to Amazon Cloudwatch."
  type        = bool
  default     = false
}

variable "enable_slowquery_log" {
  description = "Enable MySQL slowquery log export to Amazon Cloudwatch."
  type        = bool
  default     = false
}

variable "enable_mysql_log" {
  description = "Enable PostgreSQL log export to Amazon Cloudwatch."
  type        = bool
  default     = false
}


########################################################################################################
variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "713088647877.dkr.ecr.ap-southeast-1.amazonaws.com/pimcore_smretail_tf:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "4096"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "8192"
}

