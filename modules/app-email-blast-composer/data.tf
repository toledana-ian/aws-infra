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
      const crypto = require('crypto');
      const AWS = require('aws-sdk');
      const secretsManager = new AWS.SecretsManager();
      const DIGEST_AUTHENTICATION_SECRET_NAME = '${aws_secretsmanager_secret.digest_authentication.name}';

      exports.handler = (event, context, callback) => {
        var request = event.Records[0].cf.request;
        var authHeader = request.headers['authorization'];
        var expectedValue = '';

        if (!authHeader || !authHeader[0]) {
          return sendUnauthorizedResponse(callback);
        }

        const credentialsStore = await secretsManager.getSecretValue({
          SecretId: DIGEST_AUTHENTICATION_SECRET_NAME
        }).promise();

        const credentials = parseDigestHeader(authHeader[0].value);
        const password = JSON.parse(credentialsStore)[credentials.username];

        if (!password) {
          return sendUnauthorizedResponse(callback);
        }

        const expectedResponse = generateDigestResponse(credentials, 'GET', password);

        if (credentials.response !== expectedResponse) {
          return sendUnauthorizedResponse(callback);
        }

        callback(null, request);
      };

      function parseDigestHeader(header) {
        const parts = header.slice(7).split(',').reduce((acc, current) => {
          const [key, value] = current.trim().split('=');
          acc[key] = value.replace(/"/g, '');
          return acc;
        }, {});

        return parts;
      }

      function generateDigestResponse(credentials, method, password) {
        var username = credentials.username;
        var realm = credentials.realm;
        var nonce = credentials.nonce;
        var uri = credentials.uri;
        var qop = credentials.qop;
        var nc = credentials.nc;
        var cnonce = credentials.cnonce;

        var ha1 = crypto.createHash('md5').update(username + ':' + realm + ':' + password).digest('hex');
        var ha2 = crypto.createHash('md5').update(method + ':' + uri).digest('hex');
        var response = crypto.createHash('md5').update(ha1 + ':' + nonce + ':' + nc + ':' + cnonce + ':' + qop + ':' + ha2).digest('hex');
        return response;
      }

      function sendUnauthorizedResponse(callback) {
        var nonce = generateNonce(); // Implement this function to generate a unique nonce
        var opaque = generateOpaque(); // Implement this function to generate a unique opaque value
        var unauthorizedResponse = {
          status: '401',
          statusDescription: 'Unauthorized',
          headers: {
            'www-authenticate': [{
              key: 'WWW-Authenticate',
              value: 'Digest realm="Access to the site", qop="auth", nonce="' + nonce + '", opaque="' + opaque + '"'
            }],
            'content-type': [{
              key: 'Content-Type',
              value: 'text/html'
            }]
          },
          body: 'Unauthorized access.'
        };
        callback(null, unauthorizedResponse);
      }

      function generateOpaque() {
        //return crypto.randomBytes(16).toString('hex');
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return today.getTime();
      }

      function generateNonce() {
        //return crypto.randomBytes(16).toString('hex');
        return generateOpaque();
      }
    EOF
  }
}
