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

resource "postgresql_grant" "privilege" {
  depends_on  = [ postgresql_role.user ]
  count       = length(local.privileges)
  database    = local.privileges[count.index].database
  role        = local.privileges[count.index].role
  schema      = local.privileges[count.index].schema
  object_type = local.privileges[count.index].type
  privileges  = local.privileges[count.index].privileges
}

resource "postgresql_grant" "connect_privilege" {
  depends_on  = [ postgresql_role.user ]
  count       = length(local.connectprivileges)
  database    = local.privileges[count.index].database
  role        = local.privileges[count.index].role
  schema      = "public"
  object_type = "database"
  privileges  = [ "CONNECT" ]
}
