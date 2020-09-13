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

resource "postgresql_grant" "permission" {
  depends_on  = [ postgresql_role.user ]
  count       = length(local.permissions)
  database    = local.permissions[count.index].database
  role        = local.permissions[count.index].role
  schema      = local.permissions[count.index].schema
  object_type = local.permissions[count.index].type
  privileges  = local.permissions[count.index].privileges
}

resource "postgresql_grant" "connect_permission" {
  depends_on  = [ postgresql_role.user ]
  count       = length(local.connectPermissions)
  database    = local.permissions[count.index].database
  role        = local.permissions[count.index].role
  schema      = "public"
  object_type = "database"
  privileges  = [ "CONNECT" ]
}
