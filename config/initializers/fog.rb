CarrierWave.configure do |config|
  config.fog_provider = "fog/aws"
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: Rails.application.credentials.dig(:aws, :aws_access_key),
    aws_secret_access_key: Rails.application.credentials.dig(:aws, :aws_secret_access_key),
    region: "ap-northeast-2",
  }
  config.fog_directory = Rails.application.credentials.dig(:aws, :aws_bucket_name)
  config.fog_public = false
  config.cache_dir = "#{Rails.root}/tmp/uploads"         # To let CarrierWave work on Heroku
  config.storage = :fog
  config.asset_host = Rails.application.credentials.dig(:aws, :cloudfront_url)
end
