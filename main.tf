/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  roles = var.privileges.roles != null ? var.privileges.roles : []
  users = var.privileges.users != null ? var.privileges.users : []

  allRoles = concat(local.roles, local.users)

  permissions = flatten([
    for role in local.allRoles: [
      for permission in try(role.permissions, []):
      merge(permission, {
        key  = "${role.name}-${permission.database}-${permission.schema}-${permission.type}"
        role = role.name
      })
    ]
  ])

  /* Grant connect for every role that has some kind of access to a database */
  connectPermissions = flatten([
    for role in local.allRoles: [
      for database in distinct([
        for permission in try(role.permissions, []):
        permission.database
      ]):
      {
        key      = "${role.name}-${database}"
        role     = role.name
        database = database
      }
    ]
  ])

}
