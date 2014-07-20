class Comment < ActiveRecord::Base

  ## misc ##

  has_ancestry

  ## associations ##

  belongs_to :post

  ## validations ##

  validates :email, presence: true, :format => { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :author, :comment, :presence => true

  ## callbacks ##

  before_create :set_defaults
  before_save :deal_with_abnormalaties

  ## methods ##

  # The bootstrap for the bulk update function. It takes in the call
  # and decides what function to call in order to get the correct output
  # Params:
  # +params+:: all parameters
  
  def self.bulk_update(params)

    action = params[:to_do]
    action = action.gsub(' ', '_')

    if !params[:comments].blank?

      case action.downcase
      when "unapprove"
        # bulk unapprove given comments
        Comment.where(:id => params[:comments]).update_all(:comment_approved => "N")
        return 'unapproved'
      when "approve"
        # bulk approve given comments
        Comment.where(:id => params[:comments]).update_all(:comment_approved => "Y")
        return 'approved'
      when "mark_as_spam"
        # bulk mark as spam for given comments
        Comment.where(:id => params[:comments]).update_all(:comment_approved => "S", :is_spam => 'Y')
        return 'marked as spam'
      when "destroy"
        # bulk delete given comments
        Comment.where(:id => params[:comments]).destroy_all
        return 'destroyed'
      end
    else
      return 'ntd'
    end

  end


  private

  # strip any sort of html, we don't want javascrpt injection

  def deal_with_abnormalaties
    self.comment = comment.to_s.gsub(%r{</?[^>]+?>}, '').gsub(/<script.*?>[\s\S]*<\/script>/i, "")
    website = self.website.sub(/^https?\:\/\//, '').sub(/^www./,'')
    unless self.website[/\Awww.\/\//] || self.website[/\Awww.\/\//]
      website = "www.#{website}"
    end
    self.website = "http://#{website}"
  end

  # set default values of the record before adding to the database

  def set_defaults
    self.comment_approved = 'N'
    self.submitted_on = Time.now.to_s(:db)
  end

end
