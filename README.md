# PostgreSQL privileges

Terraform module for managing PostgreSQL cluster privileges. Example usage with two PostgreSQL clusters:

```
locals {
  databases = yamldecode(file("${path.root}/../databases.yaml"))
}

provider "postgresql" {
  alias           = "postgresql1"
  host            = databases["postgresql1"].host
  port            = databases["postgresql1"].port
  username        = databases["postgresql1"].adminUsername
  password        = var.postgresql1_password
}

provider "postgresql" {
  alias           = "postgresql2"
  host            = databases["postgresql2"].host
  port            = databases["postgresql2"].port
  username        = databases["postgresql2"].adminUsername
  password        = var.postgresql2_password
}

module "postgresql1_privileges" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.0"
  providers = {
    postgresql = postgresql.postgresql1
  }

  privileges                 = databases["postgresql1"]
}

module "postgresql2_privileges" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.0"
  providers = {
    postgresql = postgresql.postgresql2
  }

  privileges                 = databases["postgresql2"]
}
```

Example databases.yaml:

```
postgresql1:
  host: 127.127.127.127
  port: 5432
  adminUsername: postgres

  # privileges
  roles:
    - name: my_project_admin
      permissions:
        - database: my_project_database
          schema: public
          type: table
          privileges: ["ALL"]
        - database: my_project_database
          schema: public
          type: sequence
          privileges: ["ALL"]
    - name: my_project_support
      permissions:
        - database: my_project_database
          schema: public
          type: table
          privileges: ["SELECT", "UPDATE"]
  users:
    - name: john_doe
      roles: [ "my_project_support" ]
      permissions:
        - database: another_database
          schema: public
          type: table
          privileges: ["SELECT"]

postgresql2:
  host: 127.127.127.127
  port: 5432
  adminUsername: postgres

  # privileges
  users:
    - name: john_doe
      permissions:
        - database: some_database
          schema: public
          type: table
          privileges: ["SELECT"]
```

TIP: This module is used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/).

Contributions are welcome!
