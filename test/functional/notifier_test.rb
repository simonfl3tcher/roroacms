require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "profile" do
    mail = Notifier.profile
    assert_equal "Profile", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "comment" do
    mail = Notifier.comment
    assert_equal "Comment", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
