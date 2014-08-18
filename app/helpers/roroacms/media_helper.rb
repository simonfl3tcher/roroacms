module Roroacms  

  module MediaHelper

    require "aws-sdk"

    BUCKET = Setting.get('aws_bucket_name')
   
    AWS.config(
        :access_key_id => Setting.get('aws_access_key_id'),
        :secret_access_key => Setting.get('aws_secret_access_key')
    )

    S3 = AWS::S3.new

    def upload_images(file, type, initial_folder = 'users')
        path = "#{BUCKET}/" + initial_folder.to_s + "/" + type.to_s + "/" + file.original_filename
        begin
            obj = S3.buckets[BUCKET].objects["#{path}"].write(:file => file, :acl => :public_read)
            unauthenticated_url(obj)
        rescue => e
            logger.warn e.to_s
            return nil
        end
    end


    def unauthenticated_url(obj = nil)
      obj = obj.url_for(:read).to_s.split("?")[0] if !obj.nil?
      obj
    end

  end

end