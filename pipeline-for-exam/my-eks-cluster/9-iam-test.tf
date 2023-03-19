data "aws_iam_policy_document" "myprojapp_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "myprojapp_oidc" {
  assume_role_policy = data.aws_iam_policy_document.myprojapp_oidc_assume_role_policy.json
  name               = "myproj-oidc"
}

resource "aws_iam_policy" "myprojapp-policy"{
  name = "myprojapp-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::myprojapp"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "myprojapp_attach" {
  role       = aws_iam_role.myprojapp_oidc.name
  policy_arn = aws_iam_policy.myprojapp-policy.arn
}

output "myprojapp_policy_arn" {
  value = aws_iam_role.myprojapp_oidc.arn
}
