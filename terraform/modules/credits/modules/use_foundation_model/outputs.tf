output "converse" {
  description = "result received from calling foundation module using converse method"
  value = {
    aws_region  = jsondecode(aws_lambda_invocation.converse.result).aws_region
    model_id    = jsondecode(aws_lambda_invocation.converse.result).model_id
    prompt      = jsondecode(jsondecode(aws_lambda_invocation.converse.result).body).prompt
    response    = jsondecode(jsondecode(aws_lambda_invocation.converse.result).body).response
    status_code = jsondecode(aws_lambda_invocation.converse.result).statusCode
    timestamp   = jsondecode(aws_lambda_invocation.converse.result).timestamp
  }
}

output "invoke_model" {
  description = "result received from calling foundation module using invoke_model method"
  value = {
    aws_region  = jsondecode(aws_lambda_invocation.invoke_model.result).aws_region
    model_id    = jsondecode(aws_lambda_invocation.invoke_model.result).model_id
    prompt      = jsondecode(jsondecode(aws_lambda_invocation.invoke_model.result).body).prompt
    response    = jsondecode(jsondecode(aws_lambda_invocation.invoke_model.result).body).response
    status_code = jsondecode(aws_lambda_invocation.invoke_model.result).statusCode
    timestamp   = jsondecode(aws_lambda_invocation.invoke_model.result).timestamp
  }
}
