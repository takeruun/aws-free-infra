output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "s3_endpoint" {
  value = aws_route53_record.site.name
}
