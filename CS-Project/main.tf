# AWS provider configuration
provider "aws" {
  region = "us-east-1"
}

# Vault provider configuration
provider "vault" {
  address = "http://3.93.76.255:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"
    method = "approle"

    parameters = {
      role_id = "2ca3990f-b919-8ba9-8ea2-b23f7b97a8d7"
      secret_id = "669b83f1-c8ab-d991-5731-82280b24f634"
    }
  }
}

# Vault KV secret data source
data "vault_kv_secret_v2" "example_vault" {
  mount = "secret"
  name  = "test-secret"
}

# AWS instance resource
resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name   = "vault-test-instance"
    Secret = data.vault_kv_secret_v2.example_vault.data["username"]
  }
}
