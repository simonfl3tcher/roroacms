class RemoveAwsSettings < ActiveRecord::Migration
  def change
  	remove_column :post, :aws_access_key_id
  	remove_column :post, :aws_secret_access_key
  	remove_column :post, :aws_bucket_name
  end
end
