class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.register_confirm.subject
  #
  def register_confirm(user)
    @user = user

    mail(to: user.email, subject: '【Study Concierge】登録完了のお知らせ')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.message_confirm.subject
  #
  def message_confirm(user, message)
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.report_confirm.subject
  #
  def report_confirm
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.designation_confirm.subject
  #
  def designation_confirm
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
