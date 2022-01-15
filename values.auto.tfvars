lambda_functions = [
  {
    name        = "rsalinas-users-create"
    description = "creates a new user"
    zipfile     = "lambdas/create_user.zip"
    method      = "POST"
    path        = "create"
  },
  {
    name        = "rsalinas-users-delete"
    description = "deletes an existing user"
    zipfile     = "lambdas/delete_user.zip"
    method      = "DELETE"
    path        = "delete"
  },
  {
    name        = "rsalinas-users-get"
    description = "fetch an existing user"
    zipfile     = "lambdas/get_user.zip"
    method      = "GET"
    path        = "get"
  },
  {
    name        = "rsalinas-users-getall"
    description = "fetch all users"
    zipfile     = "lambdas/getall_user.zip"
    method      = "GET"
    path        = "getall"
  }
]