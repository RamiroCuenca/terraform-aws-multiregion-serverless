lambda_functions = [
    {
        name = "rsalinas-users-create"
        description = "creates a new user"
        zipfile = "lambdas/create_user.zip"
        method = "POST"
    },
    {
        name = "rsalinas-users-delete"
        description = "deletes an existing user"
        zipfile = "lambdas/delete_user.zip"
        method = "DELETE"
    },
    {
        name = "rsalinas-users-get"
        description = "fetch an existing user"
        zipfile = "lambdas/get_user.zip"
        method = "GET"
    },
    {
        name = "rsalinas-users-getall"
        description = "fetch all users"
        zipfile = "lambdas/getall_user.zip"
        method = "GET"
    }
]