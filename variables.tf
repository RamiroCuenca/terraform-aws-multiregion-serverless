variable "lambda_functions" {
    type = list(object({
        name = string
        description = string
        zipfile = string
    }))
}