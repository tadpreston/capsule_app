json.message 'Success'
json.set! :config do
  json.set! :aws do
    json.aws_secret_access_key ENV['AWS_ACCESS_KEY_ID']
    json.aws_secret_access_key ENV['AWS_SECRET_ACCESS_KEY']
    json.aws_s3_bucket ENV['AWS_S3_BUCKET']
  end
  json.set! :smtp do
    json.smtp_address ENV['SMTP_ADDRESS']
    json.smtp_username ENV['SENDGRID_USERNAME']
    json.smtp_password ENV['SENDGRID_PASSWORD']
  end
  json.set! :cdn do
    json.domain ENV['CLOUDFRONT_DOMAIN']
  end
end
