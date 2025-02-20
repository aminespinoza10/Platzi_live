resource "azuredevops_project" "project" {
  name        = var.project_name
  description = "This is a project template that is used to create the same project structure across different teams"
}

resource "azuredevops_dashboard" "azdo_dashboard" {
  project_id = azuredevops_project.project.id
  name       = "Metrics dashboard"
}

resource "azuredevops_git_repository" "azdo_code_repo" {
  project_id     = azuredevops_project.project.id
  name           = "Code"
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization
    ]
  }
}

resource "azuredevops_git_repository" "azdo_infra_repo" {
  project_id     = azuredevops_project.project.id
  name           = "Infrastructure"
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization
    ]
  }
}

resource "azuredevops_build_definition" "azdo_pipeline" {
  project_id = azuredevops_project.project.id
  name       = "Code Continous Integration"
  path       = "\\.azdo"

  ci_trigger {
    use_yaml = true
  }

  schedules {
    branch_filter {
      include = ["main"]
      exclude = ["test", "regression"]
    }
    days_to_build              = ["Wed", "Sun"]
    schedule_only_with_changes = true
    start_hours                = 10
    start_minutes              = 59
    time_zone                  = "(UTC) Coordinated Universal Time"
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.azdo_code_repo.id
    branch_name = azuredevops_git_repository.azdo_code_repo.default_branch
    yml_path    = "code-ci.yml"
  }

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name         = "PipelineSecret"
    secret_value = "ZGV2cw"
    is_secret    = true
  }
}

resource "azurerm_resource_group" "azure_rg" {
  name = "rg-platzi-template"
  location = "East US 2"
}