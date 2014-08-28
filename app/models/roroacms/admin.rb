module Roroacms 
  class Admin < ActiveRecord::Base

    include GeneralHelper
    include ViewHelper

    ## constants ##

    GET_ADMINS = Admin.all
    
    ## associations ##

    has_many :posts

    ## validations ##

    validates :username, presence: true
    validates :username, :uniqueness => { case_sensitive: false }
    validates :access_level, presence: true
    validates :password, length: { in: 6..128 }, on: :create
    validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

    ## callbacks ##

    before_create :deal_with_abnormalaties

    ## devise ##
    
    attr_accessor :login
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    ## methods ##

    # a devise check to check against username as well as email address
    # Params:
    # +warden_conditions+:: devise parameters

    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
      else
        where(conditions).first
      end
    end

    # sets the profile image to image being uploaded
    # Params:
    # +admin+:: user ID
    # +image+:: image path
    # +type+:: the column name you want to save the image against (almost always set to avatar)

    def self.deal_with_profile_images(admin, image, type)
      admin[type.to_sym] = image
      admin.save
    end

    # returns the user group options - these can be set and created in the administration panel

    def self.access_levels

      arr = Array.new

      ActiveSupport::JSON.decode(Setting.get('user_groups')).each do |k,v|
        arr << k
      end

      arr

    end

    # set the defaults for the admin

    def deal_with_abnormalaties
      self.overlord = 'N'
      self.avatar = site_url('assets/roroacms/default-profile.jpg')
    end

    # checks if the cover image is blank and sets the cover image to blank if this is the case
    # Params:
    # +params+:: all parameters

    def deal_with_cover(params)
      self.cover_picture = '' if defined?(params[:has_cover_image]) && params[:has_cover_image].blank?
    end

  end
end