resource "aws_db_option_group" "s3_integration" {
  name                     = "oracle-se2-12-1-s3-integration"
  option_group_description = "Allows Integration with s3"
  engine_name              = "oracle-se2"
  major_engine_version     = "12.1"

  option {
    option_name = "S3_INTEGRATION"
    version     = "1.0"
  }
}
