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

resource "postgresql_role" "role" {
  for_each    = {for item in local.roles: item.name => item}
  name        = each.value.name
  login       = false
}

resource "random_string" "user_password" {
  for_each    = {for item in local.users: item.name => item}

  length  = 32
  special = false
  upper   = true

  keepers = {
    name      = each.value.name
  }
}

resource "postgresql_role" "user" {
  depends_on  = [ postgresql_role.role ]
  for_each    = {for item in local.users: item.name => item}

  name        = each.value.name
  roles       = each.value.roles
  login       = true
  password    = random_string.user_password[each.key].result
  /* TODO: valid_until */
  connection_limit = 5
}
