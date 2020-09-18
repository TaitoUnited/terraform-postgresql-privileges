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

resource "postgresql_role" "role" {
  count       = length(local.roles)
  name        = local.roles[count.index].name
  login       = false
}

resource "random_string" "user_password" {
  count    = length(local.users)

  length  = 32
  special = false
  upper   = true

  keepers = {
    name      = local.users[count.index].name
  }
}

resource "postgresql_role" "user" {
  depends_on  = [ postgresql_role.role ]
  count       = length(local.users)

  name        = local.users[count.index].name
  roles       = local.users[count.index].roles
  login       = true
  password    = random_string.user_password[count.index].result
  /* TODO: valid_until */
  connection_limit = 5
}
