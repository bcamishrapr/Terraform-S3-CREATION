

// This is used to create KMS-key for enabling Encryption


resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket" "Log-Bucket" {
  bucket = "log438929"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "test" {
  bucket = "my-tf-test-bucket3123"
  acl    = "private"

//For Bucket Versioning

  versioning {
    enabled = true
  }

// For Bucket Logging you need to create bucket with log_delivery_write acl

 logging {
    target_bucket = aws_s3_bucket.Log-Bucket.id
    target_prefix = "log/"
  }


// Configuring KMS-keys

server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }



  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
