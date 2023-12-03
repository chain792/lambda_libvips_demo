require 'image_processing/vips'
require 'aws-sdk-s3'

# ローカルで動作させる
# Aws.config.update({
#   credentials: Aws::Credentials.new('minio_user', 'minio_password'),
#   endpoint: 'http://minio:9000',
#   force_path_style: true
# })

def lambda_handler(event:, context:)
  # 画像データ取得
  s3_client = Aws::S3::Client.new(:region => 'ap-northeast-1')
  key = 'image.jpg'
  uploaded_data = s3_client.get_object(:bucket => ENV['BUCKET_NAME'], :key => key).body.read

  # 画像リサイズ
  uploaded_file = Vips::Image.new_from_buffer(uploaded_data, '')
  resized_file_path = ImageProcessing::Vips.source(uploaded_file).resize_to_limit!(200, 200).path

  # アップロード実行
  s3_resource = Aws::S3::Resource.new()
  s3_resource.bucket(ENV['BUCKET_NAME']).object("resize_image.jpg").upload_file(resized_file_path,  content_type: "image/jpeg")
end
