class WelcomeController < ApplicationController
  def index
    if current_user
      @last_result_sheet = current_user&.result_sheets.last
    end
  end
end
