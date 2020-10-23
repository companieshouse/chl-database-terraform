# ------------------------------------------------------------------------------
# Role Association
# ------------------------------------------------------------------------------
resource "aws_db_instance_role_association" "s3_read" {
  db_instance_identifier = module.db.this_db_instance_arn
  feature_name           = "S3_INTEGRATION"
  role_arn               = aws_iam_role.rds_role.arn
}

# ------------------------------------------------------------------------------
# Role
# ------------------------------------------------------------------------------
resource "aws_iam_role" "rds_role" {
  name               = "chl-db-dump-read-s3-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

# ------------------------------------------------------------------------------
# Policy
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy" "s3_read" {
  name = "chl-db-dump-s3-read"
  role = aws_iam_role.rds_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": [
          "arn:aws:s3:::${var.aws_profile}-chl-db-dump.ch.gov.uk",
          "arn:aws:s3:::${var.aws_profile}-chl-db-dump.ch.gov.uk/*"
        ]
      }
    ]
  }
  EOF
}
