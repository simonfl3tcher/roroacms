class Notifier < ActionMailer::Base
  default from: "simonfletcher0@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.profile.subject
  #
  def profile admin = nil
    @admin = admin
    mail to: Setting.find_by_setting_name('site_email')[:setting]
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.comment.subject
  #
  def comment com
    @comment = com

    mail to: Setting.find_by_setting_name('site_email')[:setting]
  end
end
