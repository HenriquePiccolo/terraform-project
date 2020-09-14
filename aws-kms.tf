resource "aws_kms_key" "s3kmskey" {}

resource "aws_kms_alias" "s3kmskey" {
    name = "alias/myKmsKey"
    target_key_id = aws_kms_key.s3kmskey.key_id
}