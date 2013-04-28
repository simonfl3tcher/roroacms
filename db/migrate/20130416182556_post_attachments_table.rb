class PostAttachmentsTable < ActiveRecord::Migration
  def up
  	create_table :attachments do |t|
      t.integer :post_id
      t.text :attachment_name
      t.text :attachment_content
      t.timestamps
    end
  end

  def down
  	drop_table :attachments
  end
end
