module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  for_each = toset(var.microservices) # Dynamically iterate over microservices

  repository_name = "${each.key}-smruti" # Use the microservice name directly as the repository name

  repository_image_tag_mutability = "MUTABLE"

  repository_read_write_access_arns = ["arn:aws:iam::218306567362:role/ecr-access-role-${each.key}"]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  
}
