class WelcomeController < ApplicationController
  def index
    if current_user
      @general_studies = general_studies(current_user.result_sheets)
    end
  end
end
