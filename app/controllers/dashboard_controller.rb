# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user
      @general_studies = current_user.studies
      if params[:search].present? && params[:search][:search] != ''
        @general_studies = current_user.studies.search_by_group(params[:search][:search])
      end
    end
  end
end
