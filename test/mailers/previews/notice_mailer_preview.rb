# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/register_confirm
  def register_confirm
    NoticeMailer.register_confirm
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/message_confirm
  def message_confirm
    NoticeMailer.message_confirm
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/report_confirm
  def report_confirm
    NoticeMailer.report_confirm
  end

  # Preview this email at http://localhost:3000/rails/mailers/notice_mailer/designation_confirm
  def designation_confirm
    NoticeMailer.designation_confirm
  end

end
