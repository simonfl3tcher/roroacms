class Emailer < ActionMailer::Base
  add_template_helper(AdminRoroaHelper)  
  default from: Setting.get('smtp_domain')
  
  class MailSettingsInterceptor
    def self.delivering_email(message)
      message.delivery_method.settings.merge!(Setting.mail_settings)
    end
  end
  register_interceptor MailSettingsInterceptor

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
  
end
