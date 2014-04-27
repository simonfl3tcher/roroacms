class Notifier < ActionMailer::Base
  default from: Setting.get('site_email')

  # sends an email to the admin email address (set in the admin panel)
  # notifying them that a new administrator has been set up
  def profile admin = nil
    @admin = admin
    mail to: Setting.get('site_email')
  end

  # sends an email to the admin email address (set in the admin panel)
  # when someone comments on a blog post

  def comment com
    @comment = com

    mail to: Setting.get('site_email')
  end

  # sends an email to the admin email address (set in the admin panel)
  # when someone sends an email via the contact form

  def contact_form params
    @params = params
    mail to: Setting.get('site_email')
  end
  
end
