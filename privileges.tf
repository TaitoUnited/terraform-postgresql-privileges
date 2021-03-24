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

resource "postgresql_grant" "permission" {
  depends_on  = [ postgresql_role.user ]
  for_each    = {for item in local.permissions: item.key => item}
  database    = each.value.database
  role        = each.value.role
  schema      = each.value.schema
  object_type = each.value.type
  privileges  = each.value.privileges
}

resource "postgresql_grant" "connect_permission" {
  depends_on  = [ postgresql_role.user ]
  for_each    = {for item in local.connectPermissions: item.key => item}
  database    = each.value.database
  role        = each.value.role
  schema      = "public"
  object_type = "database"
  privileges  = [ "CONNECT" ]
}
