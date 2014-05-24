class AddSortOrderToPosts < ActiveRecord::Migration
   def change
    add_column :post, :sort_order, :int, :after => :post_visible
  end
end
