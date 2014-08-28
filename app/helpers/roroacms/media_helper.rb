module Roroacms  

  module MediaHelper

    require "aws-sdk"

    BUCKET = Setting.get('aws_bucket_name')
   
    AWS.config(
        :access_key_id => Setting.get('aws_access_key_id'),
        :secret_access_key => Setting.get('aws_secret_access_key')
    )

    S3 = AWS::S3.new

    # uploads images one by one to the AWS server via the details that the user has given in settings
    # Params:
    # +file+:: the file object
    # +type+:: this is a folder that you want to store the images in - mainly for internal use
    # +initial_folder_path+:: if you want to create a few subdirectories please put the path in here


    def upload_images(file, type, initial_folder_path = 'users')
        path = "#{BUCKET}/" + Setting.get("aws_folder") + "/" + initial_folder_path.to_s + "/" + type.to_s + "/" + file.original_filename
        begin
            obj = S3.buckets[BUCKET].objects["#{path}"].write(:file => file, :acl => :public_read)
            unauthenticated_url(obj)
        rescue => e
            logger.warn e.to_s
            return nil
        end
    end

    # returns a publically accessable url for the system to save in its records
    # Params:
    # +obj+:: the URL object that you want to retrive a public URL for

    def unauthenticated_url(obj = nil)
      obj = obj.url_for(:read).to_s.split("?")[0] if !obj.nil?
      obj
    end

  end

end