lambda_functions = [
    {
        name = "rsalinas-users-create"
        description = "creates a new user"
        zipfile = "lambdas/create_user.zip"
    },
    {
        name = "rsalinas-users-delete"
        description = "deletes an existing user"
        zipfile = "lambdas/delete_user.zip"
    },
    {
        name = "rsalinas-users-get"
        description = "fetch an existing user"
        zipfile = "lambdas/get_user.zip"
    },
    {
        name = "rsalinas-users-getall"
        description = "fetch all users"
        zipfile = "lambdas/getall_user.zip"
    }
]