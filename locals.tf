locals {
	logs_set = compact([
		var.enable_audit_log && (var.engine != "aurora-mysql") ? "audit" : "",
		var.enable_error_log && (var.engine != "aurora-mysql") ? "error" : "",
		var.enable_general_log && (var.engine != "aurora-mysql") ? "general" : "",
		var.enable_slowquery_log && (var.engine != "aurora-mysql") ? "slowquery" : "",
		var.enable_mysql_log && (var.engine == "aurora-mysql") ? "aurora-mysql" : "",
  ])
}
