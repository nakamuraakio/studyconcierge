require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  test "register_confirm" do
    mail = NoticeMailer.register_confirm
    assert_equal "Register confirm", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "message_confirm" do
    mail = NoticeMailer.message_confirm
    assert_equal "Message confirm", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "report_confirm" do
    mail = NoticeMailer.report_confirm
    assert_equal "Report confirm", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "designation_confirm" do
    mail = NoticeMailer.designation_confirm
    assert_equal "Designation confirm", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
