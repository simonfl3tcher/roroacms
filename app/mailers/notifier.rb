class Notifier < ActionMailer::Base
  default from: Setting.find_by_setting_name('site_email')[:setting]

  # sends an email to the admin email address (set in the admin panel)
  # notifying them that a new administrator has been set up
  def profile admin = nil
    @admin = admin
    mail to: Setting.find_by_setting_name('site_email')[:setting]
  end

  # sends an email to the admin email address (set in the admin panel)
  # when someone comments on a blog post

  def comment com
    @comment = com

    mail to: Setting.find_by_setting_name('site_email')[:setting]
  end

  # sends an email to the admin email address (set in the admin panel)
  # when someone sends an email via the contact form

  def contact_form params
    @params = params
    mail to: Setting.find_by_setting_name('site_email')[:setting]
  end
  
end
