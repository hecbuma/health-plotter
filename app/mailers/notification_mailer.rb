# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def results_ready
    @result_sheet = params[:result_sheet]

    mail(to: @result_sheet.user.email, subject: 'Your results are ready')
  end
end
