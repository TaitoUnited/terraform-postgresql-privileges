/**
 * Copyright 2020 Taito United
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

  roles = try(var.privileges.roles, [])

  users = try(var.privileges.users, [])

  allRoles = concat(local.roles, local.users)

  privileges = flatten([
    for role in keys(local.allRoles): [
      for privilege in try(role.privileges, []):
      merge(privilege, {
        role = role.name
      })
    ]
  ])

  /* Grant connect for every role that has some kind of access to a database */
  connectprivileges = flatten([
    for role in keys(local.allRoles): [
      for database in unique([
        for privilege in try(role.privileges, []):
        privilege.database
      ]):
      {
        name     = role.name
        database = database
      }
    ]
  ])

}
