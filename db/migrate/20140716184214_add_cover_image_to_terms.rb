class AddCoverImageToTerms < ActiveRecord::Migration
  def change
  	add_column :terms, :cover_image, :text, :after => :parent
  end
end
