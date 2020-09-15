# PostgreSQL privileges

Terraform module for managing PostgreSQL cluster privileges. Example usage with two PostgreSQL clusters:

```
locals {
  databases = yamldecode(file("${path.root}/../databases.yaml"))
}

provider "postgresql" {
  alias           = "postgres1"
  host            = databases["postgres1"].host
  port            = databases["postgres1"].port
  username        = databases["postgres1"].adminUsername
  password        = var.postgres1_password
}

provider "postgresql" {
  alias           = "postgres2"
  host            = databases["postgres2"].host
  port            = databases["postgres2"].port
  username        = databases["postgres2"].adminUsername
  password        = var.postgres2_password
}

module "postgres1_privileges" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.0"
  provider                   = "postgresql.postgres1"
  privileges                 = databases["postgres1"]
}

module "postgres2_privileges" {
  source                     = "TaitoUnited/privileges/postgresql"
  version                    = "1.0.0"
  provider                   = "postgresql.postgres2"
  privileges                 = databases["postgres2"]
}
```

Example databases.yaml:

```
postgres1:
  host: 127.127.127.127
  port: 5432
  adminUsername: postgres

  # privileges
  roles:
    - name: my_project_admin
      privileges:
        - database: my_project_database
          schema: public
          type: table
          privileges: ["ALL"]
        - database: my_project_database
          schema: public
          type: sequence
          privileges: ["ALL"]
    - name: my_project_support
      privileges:
        - database: my_project_database
          schema: public
          type: table
          privileges: ["SELECT", "UPDATE"]
  users:
    - name: john.doe
      roles: [ "my_project_support" ]
      privileges:
        - database: another_database
          schema: public
          type: table
          privileges: ["SELECT"]

postgres2:
  host: 127.127.127.127
  port: 5432
  adminUsername: postgres

  # privileges
  users:
    - name: john.doe
      privileges:
        - database: some_database
          schema: public
          type: table
          privileges: ["SELECT"]
```

TIP: This module is used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/).

Contributions are welcome!
