# require 'rails_helper'

# RSpec.describe "Admin::Revisions", :type => :request do

#   let(:admin) { FactoryGirl.create(:admin) }
#   let!(:revision) { Post.where(:post_type => 'autosave').first }
#   let!(:post) { Post.find_by_id(revision.parent_id) }

#   before { sign_in(admin) }

#   describe "GET /admin/revisions/#id/edit" do

#     before(:each) do
#       visit edit_admin_revision_path(revision.id)
#     end

#     it "should show list of revisions" do

#       expect(page).to have_content('Revision for')
#       expect(page).to have_content('Keycode')
#       expect(page).to have_content('Revision Saved At')

#     end

#     it "should have option to restore" do

#       click_link "Restore"

#       if post.post_type == 'page'
#         url = "/admin/pages/#{post.id}/edit"
#       elsif post.post_type == 'post'
#         url = "/admin/articles/#{post.id}/edit"
#       end

#       expect(current_path).to eq(url)

#     end

#   end

# end
