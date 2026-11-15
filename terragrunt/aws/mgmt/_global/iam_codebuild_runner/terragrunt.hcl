include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "component" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_components/iam_codebuild_runner.hcl"
}

dependency "github_connection" {
  config_path = "../codeconnections"

  mock_outputs = {
    github_connection_arn = "arn:aws:codeconnections:us-east-1:123456789012:connection/abcd1234-ef56-7890-abcd-1234567890ab"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  github_connection_arn = dependency.github_connection.outputs.github_connection_arn
}
