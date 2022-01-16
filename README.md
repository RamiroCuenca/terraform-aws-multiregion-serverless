
# AWS Multi-Region deployed using Terraform

In this project I create a multi-region infrastructure over Amazon Web Services by using Terraform as IaC (Infrastructure as Code) tool.

This project was a challenge for me for different reasons. First, as it was my first experience
using Terraform, i had to face for the first time a bunch of either syntax or CLI errors... and, adding the multi-region scope really level up the difficulty of the project. 


## Run Locally

Clone the project.

```bash
  git clone https://github.com/RamiroCuenca/terraform-aws-multiregion-serverless.git
```

Go to the project directory.

```bash
  cd terraform-aws-multiregion-serverless
```

Init the Terraform project in order to download required providers (AWS).

```bash
  terraform init
```

Launch Terraform and apply changes to the cloud.

```bash
  terraform apply -auto-approve
```

After validating it ran well... destroy created resources in order to avoid unexpected costs from AWS cloud provider.

```bash
  terraform destroy -auto-approve
```
## AWS Resources

**IAM**

Used IAM in order to create a role for our Lambda functions through which we provide full access to them over DynamoDB (required in order to be able to make operations inside it).
- Global resource.

**API Gateway**

Used API Gateway in order to provide access to the user to the Lambda functions. We deployed it in both regions in order to be prepared against us-east-1 region's fail over or drop.
- us-east-1
- us-east-2

**Lambda**

Used Lambda in order to provide execute and manage each DynamoDB's data manipulation (create, read & delete) through Lambda functions. Also, as API Gateway, we deployed it in both regions in order to be prepared against us-east-1 region's fail over or drop.
- us-east-1
- us-east-2

**DynamoDB**

Used DynamoDB as database. We take advantage of it feature called "global tables" which allow us to have a clon of our database (with which our database is linked and share all it data) running in an alternative region (in this case us-east-2). 
- us-east-1 (original table)
- us-east-2 (global table; us-east-1's clon)

**CloudWatch**

Used CloudWatch in order to have logs from what happend in our Lambda functions no matter in which region they are being called.
- us-east-1
- us-east-2
## API Reference
Make sure you first copy the API Gateway endpoint from Terraform output's (when you executed "terraform apply" command). From now on, in each endpoint we are going to refer to this API Gateway endpoint as "example.com", remember to change it for the one that corresponds.

#### Create a new user

```http
  POST example.com/sandbox/create
```

| Parameters | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `username` | `string` | **Required**|
| `email` | `string` | **Required** - Must include an '@'.|

Return the created User as a json object.

#### Read all users

```http
  GET example.com/sandbox/getall
```

Return all fetched Users as a json object.

#### Read an existing user

```http
  GET example.com/sandbox/get?{id}
```
Return an existing User as a json object. 'id' must be sent through the URL.


#### Delete an existing user

```http
  DELETE example.com/sandbox/delete?{id}
```
Return the deleted User as a json object. 'id' must be sent through the URL.

## Tech Stack

**Language:**
- Go (for the APIs deployed to Lambda as functions)
- HCL (Terraform)

**Database:**
- DynamoDB (MongoDB)

  
## Author

- [@RamiroCuenca](https://www.linkedin.com/in/ramiro-cuenca-salinas-749a2020a/)

  
