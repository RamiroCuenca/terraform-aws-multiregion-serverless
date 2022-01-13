variable "lambda_functions" {
    type = list(object({
        name = string
        description = string
        zipfile = string
        method = string
        path = string
    }))
}