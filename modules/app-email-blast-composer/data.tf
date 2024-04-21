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
          statusCode: 401,
          statusDescription: "Unauthorized",
          headers: {
            "www-authenticate": {
              value: 'Basic realm="Enter credentials for this super secure site"',
            },
          },
        };

        var request = event.request;

        if (!request || !request.headers) {
          return errorResponse;
        }

        var authHeaders = request.headers.authorization;

        if (!authHeaders || authHeaders.value !== "Basic ZHluYW06JiFlJTNONWRkJHgza150OQ==") {
          return errorResponse;
        }

        return {
          statusCode: 200,
          statusDescription: 'OK',
          headers: request.headers,
          body: request.body,
        };
      }

      module.exports.handler = handler;
    EOF
  }
}
