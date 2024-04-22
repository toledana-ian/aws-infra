data "external" "get_lambda_list" {
  program = [
    "bash", "${path.module}/scripts/list_s3_zip_contents.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename
  ]
}

data "external" "get_lambda_source_code_hash" {
  program = [
    "bash", "${path.module}/scripts/get_s3_zip_code_hash.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename
  ]
}

data "archive_file" "lambda_cloudfront_basic_auth_source_code" {
  output_path = "/tmp/lambda_cloudfront_basic_auth_soruce_code.zip"
  type        = "zip"
  source {
    filename = "index.js"
    content  = <<-EOF
      exports.handler = (event, context, callback) => {
        var request = event.Records[0].cf.request;
        var authHeader = request.headers['authorization'];
        var expected = "Basic ZHluYW06JiFlJTNONWRkJHgza150OQ==";

        if (!authHeader || !authHeader[0] || authHeader[0].value !== expected) {
          var unauthorizedResponse = {
            status: '401',
            statusDescription: 'Unauthorized',
            headers: {
              'www-authenticate': [{
                  key: 'WWW-Authenticate',
                  value: 'Basic realm="Enter credentials for this super secure site"'
              }],
              'content-type': [{
                  key: 'Content-Type',
                  value: 'text/html'
              }]
            },
            body: 'Unauthorized access'
          };
          callback(null, unauthorizedResponse);
        } else {
          callback(null, request);
        }
      };
    EOF
  }
}
