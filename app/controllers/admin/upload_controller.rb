class Admin::UploadController < ApplicationController

	  include AWS::S3

  def index
    @songs = AWS::S3::Bucket.find(BUCKET).objects
  end

  def create

        where = BUCKET

      begin
        AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, where, :access => :public_read)
        redirect_to root_path
      rescue
        render :text => "Couldn't complete the upload"
      end
   end

end