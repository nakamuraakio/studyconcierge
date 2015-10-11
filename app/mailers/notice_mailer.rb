class NoticeMailer < ApplicationMailer
  default from: "studyconcierge@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.register_confirm.subject
  #
=begin
  def register_confirm(user)
    @user = user

    mail(to: user.email, subject: '【Study Concierge】登録完了のお知らせ')
  end
=end

  def tutor_register_confirm(tutor)
    @tutor = tutor

    mail(to: tutor.email, bcc: 'studyconcierge@gmail.com', subject: '【Study Concierge】登録完了のお知らせ')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.message_confirm.subject
  #


  def comment_notice_to_user(user, tutor, comment)
    @user = user
    @tutor = tutor
    @comment = comment

    mail to: "#{user.email}", bcc: 'studyconcierge@gmail.com', subject: "【StudyConcierge】【新着コメントのお知らせ】"
  end

  def comment_notice_to_tutor(user, tutor, comment)
    @user = user
    @tutor = tutor
    @comment = comment

    mail to: "#{tutor.email}", bcc: 'studyconcierge@gmail.com', subject: "【StudyConcierge】【新着コメントのお知らせ】"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.report_confirm.subject
  #
  def report_notice_to_user(user)
    @user = user

    mail to: "#{user.email}", bcc: 'studyconcierge@gmail.com', subject: "【StudyConcierge】【報告作成のお知らせ】"
  end

  def report_notice_to_tutor(tutor)
    @tutor = tutor

    mail to: "#{tutor.email}", bcc: 'studyconcierge@gmail.com', subject: "【StudyConcierge】【報告作成のお知らせ】"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.designation_confirm.subject
  #
  def designation_notice_to_tutor(user, tutor)
    @user = user
    @tutor = tutor

    mail to: "#{tutor.email}", bcc: 'studyconcierge@gmail.com', subject: "【StudyConcierge】【チューター申請のお知らせ】"
  end

  def inquiry_form(username, useremail, message)
    @username = username
    @useremail = useremail
    @message = message
    mail(to: useremail, bcc: 'studyconcierge@gmail.com', subject: "【お問い合わせフォーム】【#{username}】")
  end
end
