# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def results_ready
    NotificationMailer.with(result_sheet: ResultSheet.last).results_ready.deliver_now
  end
end
