output "converse" {
  description = "result received from calling foundation module using converse method"
  value       = var.use_foundation_model ? module.use_foundation_model[0].converse : null
}

output "invoke_model" {
  description = "result received from calling foundation module using invoke_model method"
  value       = var.use_foundation_model ? module.use_foundation_model[0].invoke_model : null
}
