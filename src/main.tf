resource "azuredevops_project" "project" {
  name        = var.project_name
  description = "This is a project template that is used to create the same project structure across different teams"
}

