data "external" "get_lambda_list" {
  program = ["bash", "${path.module}/scripts/list_s3_zip_contents.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename]
}

data "external" "get_lambda_source_code_hash" {
  program = ["bash", "${path.module}/scripts/get_s3_zip_code_hash.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename]
}

data "archive_file" "lambda_cloudfront_basic_auth_source_code"{
  output_path = "/tmp/lambda_cloudfront_basic_auth_soruce_code.zip"
  type        = "zip"
  source {
    filename = "index.js"
    content  = <<-EOF
      function handler(event) {
        var errorResponse = {
          status: 401,
          statusDescription: "Unauthorized",
          headers: {
            "www-authenticate": {
              value: 'Basic realm="Enter credentials for this super secure site"',
            },
          },
        };

        const request = event.Records[0].cf.request;

        if (!request || !request.headers) {
          return errorResponse;
        }

        // Extract the authorization header
        const authHeaders = request.headers['authorization'];

        // Check the authorization header against the expected value
        if (!authHeaders || !authHeaders[0] || authHeaders[0].value !== "Basic ZHluYW06JiFlJTNONWRkJHgza150OQ==") {
            return errorResponse;
        }

        return request;
      }

      module.exports.handler = handler;
    EOF
  }
}
