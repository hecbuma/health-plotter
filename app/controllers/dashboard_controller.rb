class DashboardController < ApplicationController
  def index
    if current_user
      @general_studies = current_user.studies
      if  params[:search].present? && params[:search][:search] != ''
        @general_studies = current_user.studies.search_by_name(params[:search][:search])
      end
    end
  end
end
